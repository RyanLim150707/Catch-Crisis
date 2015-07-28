//
//  AppDelegate.m
//  LevelHelper2-SpriteKit
//
//  Created by Bogdan Vladu on 22/05/14.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//



#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <Chartboost/Chartboost.h>
#import "Flurry.h"
#import "shared.h"
#import <SpriteKit/SpriteKit.h>
#import "achievements.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   
    
//    [Chartboost setShouldRequestInterstitialsInFirstSession:NO];
  //  [Chartboost showRewardedVideo:CBLocationDefault];
//    [Chartboost startWithAppId:@"555f30e643150f490bc16d0d"
//                  appSignature:@"f3d7b8c15fe7b3999b7f7390d9748a24c42caa57"
//                      delegate:self];
    
    //[Chartboost showRewardedVideo:CBLocationMainMenu];
    
    [Flurry startSession:@"GTMCH3R4KYZMXDVMFY88"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}
-(void)moveSliderWithValue:(int)value{
    NSLog(@"in method");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   //// /Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"appIsActive" object:nil];

 
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appIsActive" object:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
   [[NSNotificationCenter defaultCenter] postNotificationName:@"appIsActive" object:nil];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification

{
    [shared sharedInstance].flag=1;
}


-(void)applicationWillTerminate:(UIApplication *)application{
    
    NSDate *now = [NSDate date];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDictionary *userInfo=[NSDictionary dictionaryWithObject:@"localnotification" forKey:@"monkey"];
    int daysToAdd = 2;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    localNotification.userInfo = userInfo;
    localNotification.fireDate = newDate1;
    localNotification.alertBody = @"Get a free monkey";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                       UIUserNotificationTypeSound categories:nil]];
    }

}



@end
