//
//  ViewController.m
//  DaysSince
//
//  Created by Sam Cole on 3/9/15.
//  Copyright (c) 2015 Sam Cole.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

+ (NSString *)counterPath {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSURL *docsDirectory = [delegate applicationDocumentsDirectory];
    return [[docsDirectory URLByAppendingPathComponent:@"counter"] path];
}

- (void)reset {
    self.startTime = [NSDate date];
    NSLog(@"Start time set to %@", self.startTime);
    [self refresh];
    [self saveCounterData];
}

- (void)refresh {
    
    // # seconds since startTime
    int timeElapsed = [[NSDate date] timeIntervalSinceDate:self.startTime];
    NSLog(@"%d seconds since start time", timeElapsed);
#ifndef DEBUG
    // Convert to days
    timeElapsed /= (60 * 60 * 24);
#endif
    [self.counterLabel setText:[NSString stringWithFormat:@"%d", timeElapsed]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#ifdef DEBUG
    NSLog(@"Debug mode");
    [self.timeSinceLabel setText:@"seconds since"];
#else
    self.refreshButton.hidden = YES;
#endif
    
    NSString *counterPath = [ViewController counterPath];
    if([[NSFileManager defaultManager] fileExistsAtPath:counterPath]) {
        
        NSLog(@"Loading counter from file %@", counterPath);
        Counter *counter = [NSKeyedUnarchiver unarchiveObjectWithFile:counterPath];
        self.eventTextField.text = counter.event;
        self.startTime = counter.startTime;
        NSLog(@"Counter successfully loaded");
        [self refresh];
        
    }
    else
        [self reset];
    
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

- (BOOL)saveCounterData {
    
    Counter *counter = [[Counter alloc] initWithStartTime:[self startTime] event:self.eventTextField.text];
    NSError *error = nil;
    
    NSData *counterData = [NSKeyedArchiver archivedDataWithRootObject:counter];
    
    NSString *counterPath = [ViewController counterPath];
    
    BOOL success = [counterData writeToFile:counterPath options:NSDataWritingFileProtectionNone error:&error];
    
    if(success)
        NSLog(@"Successfully wrote counter data to file %@", counterPath);

    
    return success;
}

@end
