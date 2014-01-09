//
//  RSOQuestion.h
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

//{
//    "tags": [
//             "c#",
//             "windows",
//             "xaml",
//             "store",
//             "scrollviewer"
//             ],
//    "answer_count": 1,
//    "answers": [
//                {
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
//                ],
//    "favorite_count": 0,
//    "question_timeline_url": "/questions/19448087/timeline",
//    "question_comments_url": "/questions/19448087/comments",
//    "question_answers_url": "/questions/19448087/answers",
//    "question_id": 19448087,
//    "owner": {
//        "user_id": 2814230,
//        "user_type": "registered",
//        "display_name": "user2814230",
//        "reputation": 1,
//        "email_hash": "e56022dd60bfbe64f0ea0d0b80334cfa"
//    },
//    "creation_date": 1382094168,
//    "last_activity_date": 1382807588,
//    "up_vote_count": 0,
//    "down_vote_count": 0,
//    "view_count": 22,
//    "score": 0,
//    "community_owned": false,
//    "title": "multiple stackpanels in ScrollViewer Windows 8 XAML",
//    "comments": []
//}

#import "RSOPost.h"

@class RSOAnswer;

@interface RSOQuestion : RSOPost
@property (nonatomic) BOOL hasAcceptedAnswer;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, copy) NSArray *comments;
@property (nonatomic, weak) RSOAnswer *acceptedAnswer;

+ (RSOQuestion *)questionForDictionary:(NSDictionary *)questionDictionary;

@end


