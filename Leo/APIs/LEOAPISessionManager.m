    //
//  LeoAPISessionManager.m
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPISessionManager.h"
#import "Configuration.h"
#import "LEOCredentialStore.h"
#import "LEOSession.h"
#import "Configuration.h"

@implementation LEOAPISessionManager

+ (LEOAPISessionManager *)sharedClient {
    static LEOAPISessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSURL *baseURL = [NSURL URLWithString:[Configuration APIBaseURL]];
        
        _sharedClient = [[LEOAPISessionManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];

        AFSecurityPolicy *securityPolicy;

#if defined(LOCAL)
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
#endif

#if defined(INTERNAL) || defined(RELEASE)
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
#endif

#if defined(LOCAL) || defined(INTERNAL) || defined(RELEASE)
        NSString *certificatePath = [[NSBundle mainBundle] pathForResource:[Configuration selfSignedCertificate] ofType:@"cer"];
        NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certificatePath];
        securityPolicy.pinnedCertificates = @[certificateData];
        _sharedClient.securityPolicy = securityPolicy;
#endif

    });

    return _sharedClient;
}

- (NSURLSessionDataTask *)standardGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 401) {

            [LEOSession logout];
        }

        [self formattedErrorFromError:&error];

        NSLog(@"Fail: %@",error.userInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)unauthenticatedGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;
    
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];

        NSLog(@"%@",paramsBlock);
        NSLog(@"%@",urlStringBlock);
        NSLog(@"Fail: %@",error.userInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}


- (NSURLSessionDataTask *)unauthenticatedImageGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {
    
    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;
    self.responseSerializer = [AFImageResponseSerializer serializer];
    
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil);
            });
        }
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];

        NSLog(@"%@",paramsBlock);
        NSLog(@"%@",urlStringBlock);
        NSLog(@"Fail: %@",error.userInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];

    }];
    

    return task;
}


- (NSURLSessionDataTask *)standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self POST:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];

        NSLog(@"Fail: %@", error.userInfo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}


- (NSURLSessionDataTask *)standardPUTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self PUT:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];

        NSLog(@"Fail: %@", error.userInfo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];
        NSLog(@"Fail: %@", error.userInfo);

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}


- (NSURLSessionDataTask *)standardDELETERequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self DELETE:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self formattedErrorFromError:&error];
        NSLog(@"Fail: %@",error.userInfo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}

- (NSMutableDictionary *)authenticatedParamsWithParams:(NSDictionary *)params {
    
    if (!params) {
        params = [NSDictionary new];
    }
    
    NSMutableDictionary *authenticatedParams = [params mutableCopy];
    
    [authenticatedParams setValue:[LEOAPISessionManager authToken] forKey:APIParamToken];
    
    return authenticatedParams;
}

- (void)formattedErrorFromError:(NSError * __autoreleasing *)error {
    
    NSError *errorPointer = *error;
    NSData *data = errorPointer.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

    if (data) {

        NSError *serializationError;
        NSDictionary *responseErrorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];

        id deserializedData = responseErrorDictionary;
        if (serializationError) {
            deserializedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }

        if (deserializedData) {

            NSMutableDictionary *userInfo = [errorPointer.userInfo mutableCopy];
            userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = deserializedData;
            *error = [NSError errorWithDomain:errorPointer.domain code:errorPointer.code userInfo:[userInfo copy]];
        }
    }
}

//FIXME: To be updated with the actual user token via keychain at some point.
+ (NSString *)authToken {
    return [LEOSession authToken];;
}


@end
