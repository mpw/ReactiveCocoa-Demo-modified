//
//  RSOOwner.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSOOwner : NSObject

@property (nonatomic, copy) NSString *screenName;

+ (RSOOwner *)ownerForDictionary:(NSDictionary *)ownerDictionary;

@end
