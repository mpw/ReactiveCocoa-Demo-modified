//
//  RSOAppDelegate.m
//  StackOverflow
//
//  Created by Howard Vining on 10/30/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOAppDelegate.h"
#import "RSOStore.h"
#import <MPWFoundation/MPWFoundation.h>
#import <MethodServer/MethodServer.h>
#import <ObjectiveSmalltalk/MPWStCompiler.h>


@implementation RSOAppDelegate


objectAccessor(MethodServer, methodServer, setMethodServer)

-(void)createMethodServer
{
    NSLog(@"createMethodServer, pre-existing: %@",[self methodServer]);
    [self setMethodServer:[[MethodServer alloc] initWithMethodDictName:@"stackoverflow"]];
    [[self methodServer] setupMethodServer];
    
//    NSLog(@"initialized method server: %@",[self methodServer]);
//    NSLog(@"instance methods: %@",[[[[self methodServer] interpreter] methodStore] classes]);
//    NSLog(@"class methods: %@",[[[[self methodServer] interpreter] methodStore] metaClasses]);
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSMutableArray *navControllers = [NSMutableArray array];
    for ( NSString *category in @[ @"Android" ,@"Windows", @"iOS" , @""] ) {
        RSOQuestionsTableViewController *table = [[RSOQuestionsTableViewController alloc] init];
        table.category=category;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:table];
        navController.tabBarItem.title =  category;
        [navControllers addObject:navController];
    }
    [self createMethodServer];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:navControllers];
    
    [tabBarController setSelectedViewController:[navControllers lastObject]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    NSLog(@"Start %@", [NSDate date]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
