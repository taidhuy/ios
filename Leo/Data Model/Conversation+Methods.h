//
//  Conversation+Methods.h
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Conversation.h"

@interface Conversation (Methods)

+ (Conversation * __nonnull)insertEntityWithFamilyID:(nonnull NSNumber *)familyID conversationID:(nullable NSNumber *)conversationID managedObjectContext:(nonnull NSManagedObjectContext *)context;
+ (Conversation * __nonnull)insertEntityWithJSONDictionary:(nonnull NSDictionary *)jsonResponse managedObjectContext:(nonnull NSManagedObjectContext *)context;

@end