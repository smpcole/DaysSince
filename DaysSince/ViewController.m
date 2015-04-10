//
//  ViewController.m
//  DaysSince
//
//  Created by Sam Cole on 3/9/15.
//  Copyright (c) 2015 Sam Cole.
//

#import "ViewController.h"
#import "DaysSinceShared.h"
#import "DataSource.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)resetToDate:(NSDate *)date {
    self.startTime = date;
    NSLog(@"Start time set to %@", self.startTime);
    [self refresh];
    [self saveCounterData];
}

- (void)reset {
    [self resetToDate:[NSDate date]];
}

- (void)refresh {
    
    // # seconds since startTime
    NSInteger timeElapsed = [[NSDate date] timeIntervalSinceDate:self.startTime];
    NSLog(@"%ld seconds since start time", (long)timeElapsed);
#ifndef DEBUG
    // Convert to days
    timeElapsed /= (60 * 60 * 24);
    
    // Handle special case of 1 day
    NSString *days = @"days";
    if(timeElapsed == 1)
        days = @"day";
    self.timeSinceLabel.text = [NSString stringWithFormat:@"%@ since", days];
    
#endif
    [self.counterLabel setText:[NSString stringWithFormat:@"%ld", (long)timeElapsed]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#ifdef DEBUG
    [self.timeSinceLabel setText:@"seconds since"];
    self.fileLabel.text = [NSString stringWithFormat:@"File: counter%ld", (long)self.counterIndex];
#else
    NSArray *hiddenElements = @[
                                self.refreshButton,
                                self.fileLabel,
                                self.startTimePicker,
                                self.setStartTimeButton
                                ];
    for(NSUInteger i = 0; i < hiddenElements.count; i++)
        ((UIView *)[hiddenElements objectAtIndex:i]).hidden = YES;
#endif
    
    self.counterPath = pathToStoredCounter(self.counterIndex);
    if([[NSFileManager defaultManager] fileExistsAtPath:self.counterPath]) {
        
        NSLog(@"Loading counter from file %@", self.counterPath);
        Counter *counter = [NSKeyedUnarchiver unarchiveObjectWithFile:self.counterPath];
        self.eventTextField.text = counter.event;
        self.startTime = counter.startTime;
        NSLog(@"Counter successfully loaded");
        [self refresh];
        
    }
    else {
        // We are saving a new counter to disk, so increment numStoredCounters
        numStoredCounters++;
        [self reset];
    }
    
    [self.startTimePicker setDate:self.startTime animated:NO];
    
    // This is the most recent view to load, so save its index in currentView
    NSNumber *currentView = [NSNumber numberWithInteger:self.counterIndex];
    NSError *error = nil;
    
    NSData *currentViewData = [NSKeyedArchiver archivedDataWithRootObject:currentView];
    
    BOOL success = [currentViewData writeToFile:pathToCurrentViewIndex() options:NSDataWritingFileProtectionNone error:&error];
    
    if(success)
        NSLog(@"Successfully wrote counter index %ld to file %@", (long)self.counterIndex, pathToCurrentViewIndex());
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmAction:(NSString *)action handler:(void (^)(UIAlertAction *))yesHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Confirm %@", action] message:[NSString stringWithFormat:@"Are you sure you want to %@ this counter?", action] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:yesHandler];
    [alert addAction:no];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)resetButtonPushed:(id)sender {
    NSLog(@"Reset button pushed");
    
    // Ask the user to confirm before resetting
    [self confirmAction:@"reset" handler:^(UIAlertAction *action) {
        [self reset];
    }];
    
}

- (IBAction)refreshButtonPushed:(id)sender {
    NSLog(@"Refresh button pushed");
    [self refresh];
}

- (IBAction)eventEdited:(id)sender {
    NSLog(@"Event updated to \"%@\"", self.eventTextField.text);
    [self saveCounterData];
}

- (IBAction)plusButtonPushed:(id)sender {
    NSLog(@"+ button pushed");
    
    UIPageViewController *parent = (UIPageViewController *)self.parentViewController;
    NSLog(@"Parent view controller: %@", parent);
    
    // Increase number of pages
    DataSource *dataSource = parent.dataSource;
    extern NSInteger numStoredCounters;
    
    /* Display the new view
     *
     * When this is called, the highest index counter stored on disk should be numStoredCounters - 1;
     * when viewDidLoad is called, it will attempt to load a counter from index numStoredCounters.  
     * When it doesn't find the file, it will increment numStoredCoutners and call reset, 
     * which will initialize a new Counter with default values and save it to disk.
     */
    NSArray *newView = @[[dataSource viewControllerAtIndex:numStoredCounters storyboard:self.storyboard]];
    [parent setViewControllers:newView direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (IBAction)minusButtonPushed:(id)sender {
    NSLog(@"- button pushed");
    
    // The actual deletion proc
    void (^deleteProc)(UIAlertAction *) = ^(UIAlertAction *action) {
        NSLog(@"Counter %ld will be deleted.", (long)self.counterIndex);
        
        // Delete the counter at this index
        removeStoredCounter(self.counterIndex);
        
        // Decrement remaining indices to fill in the hole
        extern NSInteger numStoredCounters;
        for(NSInteger i = self.counterIndex + 1; i < numStoredCounters; i++)
            [[NSFileManager defaultManager] moveItemAtPath:pathToStoredCounter(i) toPath:pathToStoredCounter(i - 1) error:nil
             ];
        
        /*
         * Decrement numStoredCounters and determine the index of the previous view
         *
         * If numStoredCounters == 0 after decrementing, then we just deleted the last stored counter,
         * so we should display counter 0, which will cause a new counter to be created 
         * and saved to counter0.
         */
        NSInteger prev;
        if(--numStoredCounters == 0)
            prev = 0;
        // If we deleted index 0, display the highest index counter
        else if(!self.counterIndex)
            prev = numStoredCounters - 1;
        else
            prev = self.counterIndex - 1;
        
        
        
        // Display the previous view
        UIPageViewController *pageViewController = (UIPageViewController *)self.parentViewController;
        DataSource *dataSource = (DataSource *)pageViewController.dataSource;
        ViewController *prevPage = [dataSource viewControllerAtIndex:prev storyboard:self.storyboard];
        [pageViewController setViewControllers:@[prevPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        NSLog(@"counter%ld deleted\n%ld counter(s) remaining", (long)self.counterIndex, (long)numStoredCounters);
        
    };
    
    [self confirmAction:@"delete" handler:deleteProc];
    
}

- (IBAction)setStartTimeButtonPushed:(id)sender {
    NSLog(@"Set start time button pushed");
    [self resetToDate:self.startTimePicker.date];
}

- (BOOL)saveCounterData {
    
    Counter *counter = [[Counter alloc] initWithStartTime:[self startTime] event:self.eventTextField.text];
    NSError *error = nil;
    
    NSData *counterData = [NSKeyedArchiver archivedDataWithRootObject:counter];
    
    BOOL success = [counterData writeToFile:self.counterPath options:NSDataWritingFileProtectionNone error:&error];
    
    if(success)
        NSLog(@"Successfully wrote counter data to file %@", self.counterPath);

    
    return success;
}

@end
