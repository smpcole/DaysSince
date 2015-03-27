//
//  DaysSinceShared.m
//  DaysSince
//
//  Created by Sam Cole on 3/14/15.
//
//

#import <Foundation/Foundation.h>
#import "DaysSinceShared.h"

NSInteger numStoredCounters = 0;

NSURL *applicationDocumentsDirectory() {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSString *pathToStoredCounter(NSInteger counterNum) {
    NSURL *docsDirectory = applicationDocumentsDirectory();
    return [[docsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"counter%ld", (long)counterNum]] path];

}

NSInteger calculateNumStoredCounters() {
    extern NSInteger numStoredCounters;
    numStoredCounters = 0;
    
    while([[NSFileManager defaultManager] fileExistsAtPath:pathToStoredCounter(numStoredCounters)])
        numStoredCounters++;
    
    NSLog(@"%ld counters(s) found on disk.", (long)numStoredCounters);
    
    return numStoredCounters;
}

NSString *pathToCurrentViewIndex() {
    return [[applicationDocumentsDirectory() URLByAppendingPathComponent:@"currentView"] path];
}

BOOL removeStoredCounter(NSInteger counterNum) {
    NSString *path = pathToStoredCounter(counterNum);
    BOOL fileRemoved = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    if(fileRemoved)
        NSLog(@"Removed file %@", path);
    return fileRemoved;
}