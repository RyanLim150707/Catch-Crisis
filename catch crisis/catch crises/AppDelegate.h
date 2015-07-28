//
//  AppDelegate.h
//  LevelHelper2-SpriteKit
//
//  Created by Bogdan Vladu on 22/05/14.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Chartboost/Chartboost.h>
#import "MoveSliderDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ChartboostDelegate,MoveSliderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSTimer *speedC;
@property (strong,nonatomic) NSTimer *timec;
@end
