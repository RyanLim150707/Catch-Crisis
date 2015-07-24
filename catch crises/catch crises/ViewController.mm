//
//  ViewController.m
//  LevelHelper2-SpriteKit
//
//  Created by Bogdan Vladu on 22/05/14.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import "ViewController.h"
#import "LHSceneSubclass.h"
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "shared.h"
#import <Social/Social.h>
#import  "endsecreen.h"
#import  <Chartboost/Chartboost.h>
#import "achievements.h"
@implementation ViewController
BOOL gameCenterEnabled;
int o=0;

NSMutableArray *gm;
- (void)viewDidLoad
{
    [super viewDidLoad];
       [self authenticateLocalPlayer];
  
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [LHSceneSubclass scene];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [skView presentScene:scene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGameScene)
                                                 name:@"PauseGameScene"
                                               object:nil];
}

- (void)pauseGameScene {
    //achievements *nextScene = [[achievements alloc] init];
       // [[NSNotificationCenter defaultCenter]addObserver:[shared sharedInstance].nextScene selector:@selector(makepause) name:@"makepause" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self showLeaderboardAndAchievements:YES];

}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    
    gm=[[NSMutableArray alloc]init];
    NSLog(@"running");
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier=@"catchCrisis";
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
    if (leaderboardRequest != nil) {
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
            if (error != nil) {
                //Handle error
            }
            else{
                //[delegate onLocalPlayerScoreReceived:leaderboardRequest.localPlayerScore];

                for (GKScore *s in scores)
                    
                {
                    NSMutableString *temp=[NSMutableString stringWithString:s.player.alias];
                
                   
                    NSString *temp2=s.formattedValue;
                    for(int i=(int)temp.length;i<14;i++){
                        [temp appendString:@" "];
                    }
                    
                    [temp appendString:temp2];
                    [gm insertObject:temp atIndex:o];
                   // NSLog(@"ab%@",my);
                    o++;
                    
                }
                //NSLog(@"%@",gm);
                [[shared sharedInstance].gamecenter addObjectsFromArray:gm];
                //NSLog(@"%@gamecenter",[shared sharedInstance].gamecenter);

                
            }
        }];
    }
}

-(void)authenticateLocalPlayer{
    NSLog(@"game center");
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                gameCenterEnabled = YES;
            }
            
            else{
              
                gameCenterEnabled = NO;
               
            }
        }
    };
    
    if(gameCenterEnabled){
    
    [shared sharedInstance].playername=localPlayer.alias;
    }
    else{
       [shared sharedInstance].playername=@"Your Score";
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)showShareScreen{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"TestTweet from the Game !!"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    
    
}

@end
