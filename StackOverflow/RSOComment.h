//
//  RSOComment.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOPost.h"

@interface RSOComment : RSOPost

@property (nonatomic, weak) RSOPost *post;

@end
