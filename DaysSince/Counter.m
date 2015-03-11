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
    self = [self init];
    if(self) {
        self.startTime = [decoder decodeObjectForKey:@"startTime"];
        self.event = [decoder decodeObjectForKey:@"event"];
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
        self.startTime = [NSDate date];
        self.event = @"I last pushed \"reset\".";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.event forKey:@"event"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Event: %@\nStart time: %@", self.event, self.startTime];
}

@end
