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
        NSLog(@"%d counter(s) found on disk", self.numViews);
    }
    return self;
}

- (ViewController *)viewControllerAtIndex:(int)index storyboard:(UIStoryboard *)storyboard {
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewController.counterPath = pathToStoredCounter(index);
    return viewController;
}

@end
