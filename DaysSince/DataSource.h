//
//  DataSource.h
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface DataSource : NSObject <UIPageViewControllerDataSource>

- (ViewController *)viewControllerAtIndex:(NSInteger)index storyboard:(UIStoryboard *)storyboard;

@end
