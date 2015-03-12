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

@property NSDate *startTime;

- (IBAction)resetButtonPushed:(id)sender;
- (IBAction)refreshButtonPushed:(id)sender;

- (void)refresh;
- (void)reset;

+ (NSString *)counterPath;

@end

