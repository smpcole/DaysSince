//
//  ViewController.h
//  DaysSince
//
//  Created by Sam Cole on 3/9/15.
//  Copyright (c) 2015 Sam Cole.
//

#import <UIKit/UIKit.h>
#import "Counter.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSinceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIButton *setStartTimeButton;

@property NSDate *startTime;

@property NSString *counterPath;
@property NSInteger counterIndex;

- (IBAction)resetButtonPushed:(id)sender;
- (IBAction)refreshButtonPushed:(id)sender;
- (IBAction)eventEdited:(id)sender;
- (IBAction)plusButtonPushed:(id)sender;
- (IBAction)minusButtonPushed:(id)sender;
- (IBAction)setStartTimeButtonPushed:(id)sender;

- (void)refresh;
- (void)resetToDate:(NSDate *)date;
- (void)reset;
- (BOOL)saveCounterData;

// Helper function for confirmation alerts
- (void)confirmAction:(NSString *)action handler:(void (^)(UIAlertAction *))yesHandler;

@end

