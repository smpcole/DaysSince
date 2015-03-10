//
//  ViewController.h
//  DaysSince
//
//  Created by Sam Cole on 3/9/15.
//  Copyright (c) 2015 Sam Cole.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *counter;
@property (weak, nonatomic) IBOutlet UILabel *timeSinceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property NSDate *startTime;

- (IBAction)resetButtonPushed:(id)sender;
- (IBAction)refreshButtonPushed:(id)sender;

@end

