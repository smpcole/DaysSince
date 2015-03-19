//
//  DaysSinceShared.h
//  DaysSinceShared
//
//  Created by Sam Cole on 3/14/15.
//
//

#import <UIKit/UIKit.h>

//! Project version number for DaysSinceShared.
FOUNDATION_EXPORT double DaysSinceSharedVersionNumber;

//! Project version string for DaysSinceShared.
FOUNDATION_EXPORT const unsigned char DaysSinceSharedVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DaysSinceShared/PublicHeader.h>


NSURL *applicationDocumentsDirectory();

NSString *pathToStoredCounter(int counterNum);
