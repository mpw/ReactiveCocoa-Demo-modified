//
//  RSOComment.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOPost.h"

//{
//    "comment_id": 28455253,
//    "creation_date": 1381153793,
//    "owner": {
//        "user_id": 856145,
//        "user_type": "registered",
//        "display_name": "sLedgem",
//        "reputation": 241,
//        "email_hash": "26a2d4ccf8540a41f00c9aaca72ee3df"
//    }
//{
//    "comment_id": 29253483,
//    "creation_date": 1383169771,
//    "owner": {
//        "user_id": 1558269,
//        "user_type": "registered",
//        "display_name": "JabberwockyDecompiler",
//        "reputation": 392,
//        "email_hash": "6965bd4f13092f374313c699d12c5063"
//    },
//    "post_id": 19693972,
//    "post_type": "answer",
//    "score": 0,
//    "body": "Haha, nice software.  I installed it, but I will probably just run IE seperatly."
//}
@interface RSOComment : RSOPost
@property (nonatomic, weak) RSOPost *post;


@end
