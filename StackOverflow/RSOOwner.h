//
//  RSOOwner.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

//    "owner": {
//        "user_id": 2814230,
//        "user_type": "registered",
//        "display_name": "user2814230",
//        "reputation": 1,
//        "email_hash": "e56022dd60bfbe64f0ea0d0b80334cfa"
//    }

#import <Foundation/Foundation.h>

@interface RSOOwner : NSObject
@property (nonatomic, copy) NSString *screenName;

@end
