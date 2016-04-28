//
//  PracticeScheduleException.h
//  Leo
//
//  Created by Zachary Drossman on 4/26/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PracticeScheduleException : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSArray *)exceptionsWithJSONArray:(NSArray *)jsonResponse;

NS_ASSUME_NONNULL_END
@end
