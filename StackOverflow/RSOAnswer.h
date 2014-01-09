//
//  RSOAnswer.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

//{
    //                    "answer_id": 19609521,
    //                    "accepted": false,
    //                    "answer_comments_url": "/answers/19609521/comments",
    //                    "question_id": 19448087,
    //                    "owner": {
    //                        "user_id": 2868772,
    //                        "user_type": "registered",
    //                        "display_name": "snacky",
    //                        "reputation": 56,
    //                        "email_hash": "ec5d49c858cc14e81047333b9860b90f"
    //                    },
    //                    "creation_date": 1382807588,
    //                    "last_activity_date": 1382807588,
    //                    "up_vote_count": 1,
    //                    "down_vote_count": 0,
    //                    "view_count": 22,
    //                    "score": 1,
    //                    "community_owned": false,
    //                    "title": "multiple stackpanels in ScrollViewer Windows 8 XAML",
    //                    "comments": []
    //                }

#import "RSOPost.h"

@class RSOQuestion;

@interface RSOAnswer : RSOPost
@property (nonatomic, weak) RSOQuestion *question;

+ (RSOAnswer *)answerForDictionary:(NSDictionary *)answerDictionary;

@end
