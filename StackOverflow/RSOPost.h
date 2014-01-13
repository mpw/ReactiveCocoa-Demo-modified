//
//  RSOPost.h
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSOOwner.h"

@interface RSOPost : NSObject

@property (nonatomic) NSUInteger postID;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic) NSUInteger score;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) RSOOwner *owner;

@end
