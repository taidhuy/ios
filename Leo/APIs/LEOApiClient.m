//
//  LEOApiClient.m
//  Leo
//
//  Created by Zachary Drossman on 5/12/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOApiClient.h"
#import "LEOAPISessionManager.h"
#import "LEOS3SessionManager.h"
#import "User.h"
#import "Configuration.h"

@implementation LEOApiClient


+ (void)createUserWithParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointUsers params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)loginUserWithParameters:(NSDictionary *)loginParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointLogin params:loginParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)resetPasswordWithParameters:(NSDictionary *)resetParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointResetPassword params:resetParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}


+ (void)getCardsForUser:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointCards params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}

+ (void)getSlotsWithParameters:(NSDictionary *)slotParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointSlots params:slotParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getPracticesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointPractices params:nil completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
    
}

+ (void)getPracticeWithParameters:(NSDictionary *)practiceParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    NSString *getPracticeURLString = [NSString stringWithFormat:@"%@/%@",APIEndpointPractices, practiceParams[APIParamID]];
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getPracticeURLString params:practiceParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getAppointmentTypesWithCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointAppointmentTypes params:@{} completion:^(NSDictionary *rawResults, NSError *error) { //MARK: no parameters I suspect for this endpoint
        //TODO: Error terms
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)cancelAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getFamilyWithUserParameters:(NSDictionary *)userParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointFamily params:userParams completion:^(NSDictionary *rawResults, NSError *error) {
        
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)createAppointmentWithParameters:(NSDictionary *)apptParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:APIEndpointAppointments params:apptParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}

+ (void)getConversationsForFamilyWithParameters:(NSDictionary *)conversationParams withCompletion:(void (^)(NSDictionary  *rawResults, NSError *error))completionBlock {

    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConversations params:conversationParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];

}

+ (void)createMessageForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *createMessageForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [[self leoSessionManager] standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:createMessageForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getMessagesForConversation:(NSString *)conversationID withParameters:(NSDictionary *)messageParams withCompletion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSString *getMessagesForConversationURLString = [NSString stringWithFormat:@"%@/%@/%@",APIEndpointConversations,conversationID, APIEndpointMessages];
    
    [[self leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:getMessagesForConversationURLString params:messageParams completion:^(NSDictionary *rawResults, NSError *error) {
        if (completionBlock) {
            completionBlock(rawResults, error);
        }
    }];
}

+ (void)getAvatarFromURL:(NSString *)avatarURL withCompletion:(void (^)(NSData *data, NSError *error))completionBlock {
    
    //FIXME: This is a basic implementation. Nil params is an issue as well. What security does s3 support for users only accessing URLs they should have access to?
    [[self s3SessionManager] standardGETRequestForDataFromS3WithURL:avatarURL params:nil completion:^(NSData *data, NSError *error) {
        if (completionBlock) {
            completionBlock(data, error);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

+ (LEOS3SessionManager *)s3SessionManager {
    return [LEOS3SessionManager sharedClient];
}

@end
