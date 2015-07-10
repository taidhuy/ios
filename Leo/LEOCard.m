//
//  Card.m
//  Leo
//
//  Created by Zachary Drossman on 5/20/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCard.h"
#import "LEOConstants.h"

@implementation LEOCard

#pragma mark - Initializers

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(NSString *)type associatedCardObjects:(NSArray *)associatedCardObjects {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _priority = priority;
        _type = type;
        _associatedCardObjects = associatedCardObjects;
    }
    
    return self;
}

//MARK: Should this be abstract?

- (instancetype)initWithJSONDictionary:(NSDictionary *)cardDictionary {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


//+ (NSArray *)cardsFromJSONDictionary:(NSDictionary *)jsonResponse {
//
//    NSArray *jsonCards = jsonResponse[@"cards"];
//
//    NSMutableArray *cards = [[NSMutableArray alloc] init];
//
//    for (NSDictionary *jsonCard in jsonCards) {
//        LEOCard *card = [self cardFromCardDictionary:jsonCard];
//        [cards addObject:card];
//    }
//
//    return cards;
//}

#pragma mark - Abstract methods
- (CardLayout)layout {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString *)title {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (NSString *)body {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSDate *)timestamp {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIImage *)icon {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (UIColor *)tintColor {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (User *)primaryUser {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (User *)secondaryUser {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSArray *)actionsAvailableForState {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (void)returnToPriorState {
    
    //optional?
}


@end
