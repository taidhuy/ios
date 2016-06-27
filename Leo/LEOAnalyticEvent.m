//
//  LEOAnalyticEvent.m
//  Leo
//
//  Created by Annie Graham on 6/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOAnalyticEvent.h"
#import "LEOSession.h"
#import "Family.h"
#import "Family+Analytics.h"
#import "Guardian+Analytics.h"

@implementation LEOAnalyticEvent

+ (NSDictionary *)getAttributesWithFamily:(Family *)family {

    Guardian *guardian = [LEOSession user];

    NSMutableDictionary *attributeDictionary = [[family getAttributes] mutableCopy];
    [attributeDictionary addEntriesFromDictionary:[guardian getAttributes]];

    return attributeDictionary;
}

+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary
       andFamily:(Family *)family {

    NSMutableDictionary *mutableAttributeDictionary = [[self getAttributesWithFamily:family] mutableCopy];
    [mutableAttributeDictionary addEntriesFromDictionary:attributeDictionary];
    [self tagEvent:eventName withAttributes:mutableAttributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
      withFamily:(Family *)family {

    NSDictionary *attributeDictionary = [self getAttributesWithFamily:family];
    [self tagEvent:eventName withAttributes:attributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName
  withAttributes:(NSDictionary *)attributeDictionary {

    [Localytics tagEvent:eventName
              attributes:attributeDictionary];
}

+ (void)tagEvent:(NSString *)eventName {
    [self tagEvent:eventName withAttributes:nil];
}

@end
