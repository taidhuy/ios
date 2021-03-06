//
//  LEOS3Image.m
//  Leo
//
//  Created by Zachary Drossman on 1/14/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOS3Image.h"
#import "LEOMediaService.h"
#import <UIImage-Resize/UIImage+Resize.h>
#import "NSDictionary+Extensions.h"

@implementation LEOS3Image

static CGFloat kImageSideSizeScale1Avatar = 100.0;
static CGFloat kImageSideSizeScale2Avatar = 200.0;
static CGFloat kImageSideSizeScale3Avatar = 300.0;

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder
                          image:(UIImage *)image
                    nonClinical:(BOOL)nonClinical {

    self = [super init];
    if (self) {

        _baseURL = [baseURL copy];
        _parameters = [parameters copy];
        _placeholder = placeholder;
        _underlyingImage = image;
        _nonClinical = nonClinical;
    }

    return self;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL
                     parameters:(NSDictionary *)parameters
                    placeholder:(UIImage *)placeholder
                    nonClinical:(BOOL)nonClinical {

    return [self initWithBaseURL:baseURL
                      parameters:parameters
                     placeholder:placeholder
                           image:nil
                     nonClinical:nonClinical];
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *baseURL = [jsonDictionary leo_itemForKey:APIParamImageBaseURL];
    NSDictionary *parameters = [jsonDictionary leo_itemForKey:APIParamImageURLParameters];

    BOOL nonClinical = [[jsonDictionary leo_itemForKey:APIParamImageNonClinical] boolValue];

    UIImage *image = [jsonDictionary leo_itemForKey:APIParamImage];
    UIImage *placeholder = [jsonDictionary leo_itemForKey:APIParamImagePlaceholder];

    return [self initWithBaseURL:baseURL
                      parameters:parameters
                     placeholder:placeholder
                           image:image
                     nonClinical:nonClinical];
}

- (UIImage *)image {

    [self refreshIfNeeded];

    if (!self.underlyingImage) {
        return self.placeholder;
    }
    return self.underlyingImage;
}

+ (NSDictionary *)serializeToJSON:(LEOS3Image *)image {

    if (!image) {
        return nil;
    }

    NSMutableDictionary *jsonDictionary = [NSMutableDictionary new];
    jsonDictionary[APIParamImageBaseURL] = image.baseURL;
    jsonDictionary[APIParamImageURLParameters] = image.parameters;
    jsonDictionary[APIParamImageNonClinical] = @(image.nonClinical);

    jsonDictionary[APIParamImage] = image.underlyingImage;
    jsonDictionary[APIParamImagePlaceholder] = image.placeholder;

    return [jsonDictionary copy];
}

- (BOOL)isPlaceholder {

    [self refreshIfNeeded];
    return !self.underlyingImage;
}

- (LEOCachePolicy *)cachePolicy {

    if (!_cachePolicy) {
        _cachePolicy = [LEOCachePolicy new];
        _cachePolicy.get = LEOCachePolicyGETCacheElseGETNetworkThenPUTCache;
    }
    return _cachePolicy;
}

- (void)setNeedsRefresh {

    self.underlyingImage = nil;
}

- (LEOPromise *)refreshIfNeeded {

    if (!self.underlyingImage && self.baseURL && !self.downloadPromise.executing) {

        LEOMediaService *service = [LEOMediaService serviceWithCachePolicy:self.cachePolicy];

        __weak typeof(self) weakSelf = self;
        self.downloadPromise = [service getImageForS3Image:self withCompletion:^(UIImage * rawImage, NSError * error) {
            __strong typeof(self) strongSelf = weakSelf;
            if (!error && rawImage) {

                strongSelf.underlyingImage = rawImage;
                if (strongSelf.downloadPromise.executing) {
                    // Only send the notification if we are waiting for completion
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDownloadedImageUpdated object:strongSelf];
                }
            }

            strongSelf.downloadPromise = [LEOPromise finishedCompletion];
        }];
    }

    return self.downloadPromise;
}

-(void)setImage:(UIImage *)image {

    self.underlyingImage = image;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationImageChanged object:self];
}

- (id)copyWithZone:(NSZone *)zone {

    LEOS3Image *s3Copy = [[LEOS3Image allocWithZone:zone] initWithBaseURL:[self.baseURL copy] parameters:[self.parameters copy] placeholder:[self.placeholder copy] nonClinical:self.nonClinical];

    if (self.underlyingImage) {
        s3Copy.underlyingImage = [self.underlyingImage copy];
    }

    return s3Copy;
}

+ (UIImage *)resizeLocalAvatarImageBasedOnScreenScale:(UIImage *)avatarImage {

    CGFloat resizedImageSideSize = kImageSideSizeScale3Avatar;

    NSInteger scale = (int)[UIScreen mainScreen].scale;

    switch (scale) {

        case 1:
            resizedImageSideSize = kImageSideSizeScale1Avatar;
            break;

        case 2:
            resizedImageSideSize = kImageSideSizeScale2Avatar;
            break;

        case 3:
            resizedImageSideSize = kImageSideSizeScale3Avatar;
            break;
    }
    
    return [avatarImage resizedImageToSize:CGSizeMake(resizedImageSideSize, resizedImageSideSize)];
}


@end
