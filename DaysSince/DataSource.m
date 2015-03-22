//
//  DataSource.m
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import "DataSource.h"
#import "DaysSinceShared.h"
#import "ViewController.h"

@implementation DataSource

- (id)init {
    self = [super init];
    if(self) {
        self.numViews = numStoredCounters();
        NSLog(@"%ld counter(s) found on disk", (long)self.numViews);
    }
    return self;
}

- (ViewController *)viewControllerAtIndex:(NSInteger)index storyboard:(UIStoryboard *)storyboard {
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.counterIndex = index;
    return viewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger nextIndex = (((ViewController *)viewController).counterIndex + 1) % self.numViews;
    return [self viewControllerAtIndex:nextIndex storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger nextIndex = (((ViewController *)viewController).counterIndex - 1) % self.numViews;
    return [self viewControllerAtIndex:nextIndex storyboard:viewController.storyboard];
}

@end
