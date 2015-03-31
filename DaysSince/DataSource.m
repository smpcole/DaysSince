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

- (ViewController *)viewControllerAtIndex:(NSInteger)index storyboard:(UIStoryboard *)storyboard {
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.counterIndex = index;
    return viewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    extern NSInteger numStoredCounters;
    NSInteger nextIndex = (((ViewController *)viewController).counterIndex + 1) % numStoredCounters;
    return [self viewControllerAtIndex:nextIndex storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    extern NSInteger numStoredCounters;
    NSInteger currentIndex = ((ViewController *)viewController).counterIndex;
    NSInteger nextIndex = currentIndex ? currentIndex - 1 : numStoredCounters - 1;
    return [self viewControllerAtIndex:nextIndex storyboard:viewController.storyboard];
}

@end
