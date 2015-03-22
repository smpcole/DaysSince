//
//  DaysSinceShared.m
//  DaysSince
//
//  Created by Sam Cole on 3/14/15.
//
//

#import <Foundation/Foundation.h>
#import "DaysSinceShared.h"

NSURL *applicationDocumentsDirectory() {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSString *pathToStoredCounter(NSInteger counterNum) {
    NSURL *docsDirectory = applicationDocumentsDirectory();
    return [[docsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"counter%ld", (long)counterNum]] path];

}

NSInteger numStoredCounters() {
    NSInteger numCounters = 0;
    
    while([[NSFileManager defaultManager] fileExistsAtPath:pathToStoredCounter(numCounters)])
        numCounters++;
    
    return numCounters;
}

NSString *pathToCurrentViewIndex() {
    return [[applicationDocumentsDirectory() URLByAppendingPathComponent:@"currentView"] path];
}