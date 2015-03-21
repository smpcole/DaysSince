//
//  RootViewController.h
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property DataSource *dataSource;
@property UIPageViewController *pageViewController;

@end
