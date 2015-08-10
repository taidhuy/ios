//
//  Appointment.h
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;
@class Provider;
@class User;
@class PrepAppointment;
@class AppointmentType;


@interface Appointment : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, copy, nullable) NSString *objectID;
@property (nonatomic, strong) AppointmentType *appointmentType;
@property (nonatomic) AppointmentStatusCode statusCode;
@property (nonatomic) AppointmentStatusCode priorStatusCode;
@property (nonatomic, strong) User *bookedByUser;
@property (nonatomic, strong) Patient *patient;
@property (nonatomic, strong) Provider *provider;
@property (nonatomic, strong) NSString *note;


-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(nullable AppointmentType *)appointmentType patient:(nullable Patient *)patient provider:(nullable Provider *)provider bookedByUser:(User *)bookedByUser note:(nullable NSString *)note statusCode:(AppointmentStatusCode)statusCode;

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse;

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment;

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment;

NS_ASSUME_NONNULL_END
@end
