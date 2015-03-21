//
//  DataSource.m
//  DaysSince
//
//  Created by Sam Cole on 3/16/15.
//
//

#import "DataSource.h"
#import "DaysSinceShared.h"

@implementation DataSource

- (id)init {
    self = [super init];
    if(self) {
        self.numViews = numStoredCounters();
        NSLog(@"%d counter(s) found on disk", self.numViews);
    }
    return self;
}

@end
