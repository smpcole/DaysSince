//
//  DataSource.h
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface DataSource : NSObject <UIPageViewControllerDataSource>

@property int numViews;

@end
