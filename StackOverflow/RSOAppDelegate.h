//
//  RSOAppDelegate.h
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MethodServer;

@interface RSOAppDelegate : UIResponder <UIApplicationDelegate>
{
    MethodServer *methodServer;
}


@property (strong, nonatomic) UIWindow *window;

@end
