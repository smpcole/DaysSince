//
//  Counter.m
//  DaysSince
//
//  Created by Sam Cole on 3/10/15.
//
//

#import "Counter.h"

@implementation Counter

- (id)initWithCoder:(NSCoder *)decoder {
    NSDate *startTime = [decoder decodeObjectForKey:@"startTime"];
    NSString *event = [decoder decodeObjectForKey:@"event"];
    return [self initWithStartTime:startTime event:event];
}

- (id)initWithStartTime:(NSDate *)startTime event:(NSString *)event {
    self = [super init];
    if(self) {
        self.startTime = startTime;
        self.event = event;
    }
    return self;
}

- (id)init {
    return [self initWithStartTime:nil event:nil];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.event forKey:@"event"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Event: %@\nStart time: %@", self.event, self.startTime];
}

@end
