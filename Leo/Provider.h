//
//  Provider.h
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"

@interface Provider : User <NSCoding>
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSArray *credentials;
@property (copy, nonatomic) NSArray *specialties;

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(UIImage *)avatar credentialSuffixes:(NSArray *)credentials specialties:(NSArray *)specialties;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse;

+ (NSDictionary *)dictionaryFromUser:(Provider *)provider;

NS_ASSUME_NONNULL_END
@end