//
//  RSOOwner.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOOwner.h"

@implementation RSOOwner

+ (RSOOwner *)ownerForDictionary:(NSDictionary *)ownerDictionary
{
    RSOOwner *owner = [RSOOwner new];
    owner.screenName = ownerDictionary[@"display_name"];
    return owner;
}

@end
