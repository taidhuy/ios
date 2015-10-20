//
//  LEOUserService.h
//  Leo
//
//  Created by Zachary Drossman on 9/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

@class User, SessionUser, Guardian, Family, Patient;

#import <Foundation/Foundation.h>

@interface LEOUserService : NSObject

- (void)createGuardian:(Guardian *)newGuardian withCompletion:(void (^)(Guardian *guardian, NSError *error))completionBlock;
- (void)createPatient:(Patient *)newPatient withCompletion:(void (^)(Patient * patient, NSError *error))completionBlock;

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password withCompletion:(void (^)(SessionUser *user, NSError *error))completionBlock;
- (void)enrollUser:(Guardian *)guardian password:(NSString *)password withCompletion:(void (^) (BOOL success, NSError *error))completionBlock;
- (void)updateEnrollmentOfUser:(Guardian *)guardian withCompletion:(void (^) (BOOL success, NSError *error))completionBlock;
- (void)resetPasswordWithEmail:(NSString *)email withCompletion:(void (^)(NSDictionary *  rawResults, NSError *error))completionBlock;
- (void)getAvatarForUser:(User *)user withCompletion:(void (^)(UIImage *rawImage, NSError *error))completionBlock;
- (void)postAvatarForUser:(User *)user withCompletion:(void (^)(BOOL success, NSError *error))completionBlock;

@end