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

- (void)reset {
    self.startTime = [NSDate date];
    NSLog(@"Start time set to %@", self.startTime);
    [self refresh];
    [self saveCounterData];
}

- (void)refresh {
    
    // # seconds since startTime
    NSInteger timeElapsed = [[NSDate date] timeIntervalSinceDate:self.startTime];
    NSLog(@"%ld seconds since start time", (long)timeElapsed);
#ifndef DEBUG
    // Convert to days
    timeElapsed /= (60 * 60 * 24);
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
    self.refreshButton.hidden = YES;
    self.fileLabel.hidden = YES;
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
    else
        [self reset];
    
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

- (IBAction)resetButtonPushed:(id)sender {
    NSLog(@"Reset button pushed");
    [self reset];
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
    NSInteger numViews = ++numStoredCounters;
    
    /* Display the new view
     *
     * When viewDidLoad is called, it will attempt to load a Counter from file counterN on disk,
     * where N is the new index.  When it doesn't find the file, it will simply call reset, which
     * will initialize a new Counter with default values and save it to disk.
     */
    NSArray *newView = @[[dataSource viewControllerAtIndex:numViews - 1 storyboard:self.storyboard]];
    [parent setViewControllers:newView direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (IBAction)minusButtonPushed:(id)sender {
    NSLog(@"- button pushed");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm delete" message:@"Are you sure you want to delete this counter?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
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
        numStoredCounters--;
        
        // If numStoredCounters == 0 (i.e., we just deleted the last counter), then a new Counter will be saved to counter0
        // when we attempt to display the nonexistent counter stored in counter0.
        // Hence, we treat the case when there are no more stored counters as if there were 1 stored counter.
        if(!numStoredCounters)
            numStoredCounters = 1;
        
        // Display the previous view
        UIPageViewController *pageViewController = (UIPageViewController *)self.parentViewController;
        ViewController *prevPage = (ViewController *)[pageViewController.dataSource pageViewController:pageViewController viewControllerBeforeViewController:self];
        [pageViewController setViewControllers:@[prevPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        NSLog(@"counter%ld deleted\n%ld counter(s) remaining", (long)self.counterIndex, (long)numStoredCounters);
        
    };
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:deleteProc];
    [alert addAction:no];
    [alert addAction:yes];
    
    [self presentViewController:alert animated:YES completion:nil];
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
