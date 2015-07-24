//
//  LHSceneSubclass.m
//  SpriteKitAPI-DEVELOPMENT
//
//  Created by Bogdan Vladu on 16/05/14.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import "LHSceneSubclass.h"
#import "changescene.h"
#import "achievements.h"
#import "achievement.h"
#import "AVFoundation/AVFoundation.h"
#import "endsecreen.h"
#import "pause_game.h"
#import "endsecreen.h"
#import "custom cellTableViewCell.h"
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "shared.h"
#import "JADSKScrollingNode.h"
#import "Flurry.h"



@implementation LHSceneSubclass



static const CGFloat kScrollingNodeWidth = 360;
static const CGFloat kScrollingNodeHeight = 250;
SKAction *soundAction;
AVAudioPlayer *bplay,*buttonpressed;
#define YOUR_APP_STORE_ID 928441104 //Change this one to your ID
SKSpriteNode *listof_items,*node1,*rectNode,*temp,*left,*playericon,*abutton,* scrollbutton,*heart1,*heart2,*quicklifebox,*arrow,*text,*two;
CGPoint  currentlc,twodefault,thriddefault,rightdefault,leftdefault,mypos,shopcurrent,shopmoveloc,textpos,arrowpos;;
SKNode *my,*third,*right,*mydef,*currentnode,*globale;
SKView *twoview;
int i=0,locked=0,outerlock=0,animatelock=0,u=0;
int screen_identifier=0,firstmove=0,secondmove=0,achtext=2;
CGPoint currentLocation,instantlocation;
UISwipeGestureRecognizer *swipeup, *siwpedown,*swiperight,*swipeleft;
NSTimeInterval startTime;
NSString *highscorelist,*selection,*arrowstring,*textstring;
long actualPlayerLevel=1,coin=0;
int table_for=0;
int table=0,fmove=-1,add=0,shop=0,checkid=0, preindex=0,heartnum=0,heartli=0,myindex=0,backindex=0,bactiveindex=0;
NSDate *pauseStart, *previousFireDate;
int old=0,shopbuttonscroll=0;
float maxshopButtonpos=0.0,minshopButtonpos=0.0,dragvalue=-325;
bool customswipe=YES,mybool=YES;
NSMutableArray *gmarray;
+(id)scene{
    [shared sharedInstance].mainScene=[[self alloc] initWithContentOfFile:@"final/my.lhplist"];
    return [shared sharedInstance].mainScene;
}
-(id)initWithContentOfFile:(NSString *)levelPlistFile{
    
    if(self = [super initWithContentOfFile:levelPlistFile])
    {
        
         _pointsarray=[[NSMutableArray alloc]init];
        _check=[[NSMutableArray alloc]init];
        
        for(int r=0;r<5;r++){
            
            [_check addObject:[NSNumber numberWithInt:0]];
             [_pointsarray addObject:[NSNumber numberWithLong:0]];
        }
        
       
        
        
        [self checkinitialize];
        _nodesitems=[[NSMutableArray alloc]init];
        globale=[[SKSpriteNode alloc]init];
         //[self scroolnode];
        third=[self childNodeWithName:@"shop_background"];
         //   NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myImage.png"];
        //third=[SKSpriteNode spriteNodeWithImageNamed:imagePath];
        text=(SKSpriteNode*)[self childNodeWithName:@"menu_button2"];
        arrow=(SKSpriteNode*)[self childNodeWithName:@"menu_shop"];
        my=[self childNodeWithName:@"menu_background"];
        two=(SKSpriteNode *)[self childNodeWithName:@"achievements_background"];
        left=(SKSpriteNode *)[self childNodeWithName:@"quick_backgroundOriginal1"];
        right=[self childNodeWithName:@"quick_backgroundOriginal"];
        playericon=(SKSpriteNode *)[self childNodeWithName:@"quick_warrior2"];
        twodefault=two.position;
        thriddefault=third.position;
        leftdefault=left.position;
        rightdefault=right.position;
        mypos=my.position;
        _top5=[[NSMutableArray alloc]init];
        [_top5 addObjectsFromArray:[shared sharedInstance].gamecenter];
        [self changeskin];
        [self firstonmenuscreen:0];
    }
    
    
    
    
    return self;
}
-(void)rewardedvideo{
    NSLog(@"rewarded video");
    [Chartboost startWithAppId:@"555f30e643150f490bc16d0d"
                  appSignature:@"f3d7b8c15fe7b3999b7f7390d9748a24c42caa57"
                      delegate:self];

     [Chartboost showRewardedVideo:CBLocationHomeScreen];
}
-(void)movetoachievement{
    table=1;
    [self dragaction:1 firstnode:two srcondnode:my move:0 defaultpos:mypos];
    
    screen_identifier=2;
}
-(void)movetoshop{
    [self dragaction:0 firstnode:third srcondnode:my move:0 defaultpos:mypos];
       screen_identifier=1;
    [self updatelist:@"monkey" add:0 heartnum:0];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Get a Free Monkey Costume!"
                                                      message:@"Monkey Costume Unlocked!"
                                                     delegate:self
                                            cancelButtonTitle:@"Got it Thanks!"                                                otherButtonTitles:nil];
    [message show];
    
 
}
-(void)checkinitialize{
    
    
    for(int r=0;r<5;r++){
        
        [_check replaceObjectAtIndex:r withObject:[NSNumber numberWithInt:0]];
    }
}
#pragma mark Did move to view
-(void)didMoveToView:(SKView *)view {
    
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameMusic/Brahmsters-Inc.-Stream" ofType:@"mp3"]];
     bplay = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [bplay setNumberOfLoops:-1];
    [bplay prepareToPlay];
  [bplay play];
    
    my.position=mypos;
    two.position=twodefault;
    third.position=thriddefault;
    right.position=rightdefault;
    left.position=leftdefault;
    screen_identifier=0;
    firstmove=-1;
    i=0,locked=0,outerlock=0,animatelock=0;
    currentlc={0.0,0.0};
    currentLocation={0.0,0.0};
    
    _challege=[[NSMutableArray alloc]init];
    _challege_name=[[NSMutableArray alloc]init];
    _bools=[[NSMutableArray alloc]init];
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questsPList" ofType:@"plist"]];
    
    
    NSArray *arrayValues=[[NSArray alloc] initWithArray:[dictRoot valueForKey:@"QuestsArray"]];
    //NSLog(@"%@",arrayValues);
    NSInteger value=0;
    
    while([arrayValues count]!= value){
        NSArray *items=[[NSArray alloc] initWithArray:[arrayValues objectAtIndex:value]];
        [_challege_name addObject:[items objectAtIndex:0]];
        [_challege addObject:[items objectAtIndex:1]];
       
        
        value++;
    }
    
    highscorelist= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    highscorelist = [highscorelist stringByAppendingPathComponent:@"highscore.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:highscorelist]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"highscore" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:highscorelist error:nil];
    }
    
    
   
    NSDictionary *dictpoints =[[NSMutableDictionary alloc] initWithContentsOfFile:highscorelist];
    
    NSLog(@"%@",dictpoints);

    for(int y=0;y<5;y++){
        NSString *key1 = [NSString stringWithFormat:@"%d",y];
        NSNumber *number =[dictpoints objectForKey:key1];
        long temp=[number longValue];
        [_pointsarray replaceObjectAtIndex:y withObject:[NSNumber numberWithLong:temp]];
    }
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"achievement .plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
 
    
    if (![fileManager fileExistsAtPath:destPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"achievement " ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:nil];
    }
    
    // Load the Property List.
    NSMutableDictionary  *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
    NSNumber *a;
    for(int i=1;i<40;i++){
        NSString *num = [NSString stringWithFormat:@"%d",i];
     
        a=[dict objectForKey:num];
        int temp=[a intValue];
        [_bools addObject:[NSNumber numberWithInt:temp ]];
    }

    [self maketable];
    
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // [self allplayerstopscore];
    
    //[self showLeaderboardAndAchievements:YES];
    heart1=(SKSpriteNode *)[self childNodeWithName:@"quick_heartLock"];
    [heart1 setTexture:[SKTexture textureWithImageNamed:@"imageresource/quickGame/quick_heartLock"]];
    
    heart2=(SKSpriteNode *)[self childNodeWithName:@"quick_heartLock1"];
    [heart1 setTexture:[SKTexture textureWithImageNamed:@"imageresource/quickGame/quick_heartLock"]];
    quicklifebox=(SKSpriteNode *)[self childNodeWithName:@"quick_lifeBox"];
    
    [_top5 addObjectsFromArray:[shared sharedInstance].gamecenter];
    [self showcoins];
     [self changeskin];
    [self shopcf];
    if([shared sharedInstance].flag==1){
    [self movetoshop];
    [shared sharedInstance].flag=2;
    }
    
    SKSpriteNode *bt=(SKSpriteNode *)[self childNodeWithName:@"achievements_QuestB"];
    SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_questW"];
    [bt setTexture: playerTexture];
    achtext=3;
    NSLog(@"move to view");
    [self demobinary];
    [self showLeaderboardAndAchievements:YES];
    [self getScrollbutton];
    [self makebutton];
    SKSpriteNode *max=(SKSpriteNode *)[self childNodeWithName:@"max"];
    maxshopButtonpos=CGRectGetMinY(max.frame);
      SKSpriteNode *min=(SKSpriteNode *)[self childNodeWithName:@"min"];
    minshopButtonpos=CGRectGetMaxY(min.frame);
   
    [self extrahearts];
    if([shared sharedInstance].movetoach==1){
        [shared sharedInstance].movetoach=0;
        [self movetoachievement];
    }
 
   
}
-(void)maketable{
    
    if(self.frame.size.height==1334){//iphone6
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)-5,CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.4)];
        
    }
    else if(self.frame.size.height==1104){ //iphone6+
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/13)+10,CGRectGetMaxY(self.frame)/5, self.frame.size.width/2-13, self.frame.size.height/2.62)];
    }
    else if (self.frame.size.height==1136){ //iphone5
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15-2),CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.6)];
    }
    
    else if (self.frame.size.height==960){ //iphone4
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15),CGRectGetMaxY(self.frame)/7, self.frame.size.width/2.8, self.frame.size.height/3.2)];
    }
    else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)-5,CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.4)];
        
    }
    _temptableView=[[UITableView alloc]init];
    
   _temptableView.frame=_tableView.frame;
}
-(void)takeScreenShot{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *gameOverScreenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageWriteToSavedPhotosAlbum(gameOverScreenImage, nil, nil, nil); //if you need to save
    
    //[arrow setTexture:[SKTexture textureWithImage:viewImage]];
    
}
-(void)arrowpostion:(int)end{
    text=(SKSpriteNode*)[self childNodeWithName:arrowstring];
    arrow=(SKSpriteNode*)[self childNodeWithName:textstring];
    if(end==0){
        textpos=text.position;
        arrowpos=arrow.position;
        text.position=arrowpos;
        arrow.position=textpos;
        
    }
    else{
        text.position=textpos;
        arrow.position=arrowpos;
        
    }
   
    
}
-(void)removescrollnode{
    [_scrollingNode disableScrollingOnView:third.scene.view];
    [_scrollingNode removeFromParent];
    
    //[rectNode removeFromParent];
    //[node1 removeFromParent];
    
    
}
-(void)showcoins{
    SKSpriteNode *showcoins=(SKSpriteNode *)[third childNodeWithName:@"coinnode"];
    [self getcoins];
    SKLabelNode *slabel=[[SKLabelNode alloc]init];
    [slabel setFontName:@"PoetsenOne-Regular"];
    slabel.zPosition=1;
    //slabel.position=CGPointMake(CGRectGetMidX(showcoins.frame), CGRectGetMinY(showcoins.frame));
    NSString *man = [NSString stringWithFormat:@"%li",coin];
    [slabel setText:man];
    [slabel setFontColor:[UIColor brownColor]];
    [showcoins removeAllChildren];
    [showcoins addChild:slabel];
}
-(void)demobinary{
   [self connection];
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"monkey"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"banana"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"heart1"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"heart2"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:8] forKey:@"heart1life"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:8] forKey:@"heart2life"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"backq"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"backi"];
    [tdict writeToFile:highscorelist atomically:YES];
    [tdict setObject:[NSNumber numberWithInt:1] forKey:@"backd"];
    [tdict writeToFile:highscorelist atomically:YES];
  
}
-(NSString *)screename{
    NSString *name;
    if(screen_identifier==0){
        name=[NSString stringWithFormat:@"mainmenu"];
    }
    else if (screen_identifier==1){
         name=[NSString stringWithFormat:@"shop"];
        
    }
    else if (screen_identifier==2){
        name=[NSString stringWithFormat:@"achievement"];
        
    }
    else if (screen_identifier==3){
        name=[NSString stringWithFormat:@"game play"];
        
    }
    else{
        name=[NSString stringWithFormat:@"coming soon"];
    }

    return name;
    
    
}
-(void)scroolnode:(int)count{
   
    
    _scrollingNode=[[JADSKScrollingNode alloc]init];
    _scrollingNode = [[JADSKScrollingNode alloc] initWithSize:(CGSize){100.0,100.0}];
    
     SKNode *list =[self childNodeWithName:@"shop_banner"];
    
  rectNode = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:(CGSize){kScrollingNodeWidth,kScrollingNodeHeight}];
    rectNode.position = CGPointMake(CGRectGetMidX(list.frame)-list.frame.size.height/40, CGRectGetMidY(list.frame)-list.frame.size.height/3.8);
    rectNode.zPosition=0;
    rectNode.name=@"rect";
    SKSpriteNode *maskNode = [rectNode copy];
    //maskNode.name=@"backg";
    
    SKCropNode* cropNode = [SKCropNode node];
    cropNode.maskNode = maskNode;
    cropNode.zPosition=0;
    [cropNode addChild:rectNode];
    
    
   // _scrollingNode.position = CGPointMake(kScrollingNodeXPosition, kScrollingNodeYPosition);
    
   
    [list removeAllChildren];
    [rectNode addChild:_scrollingNode];
    [list addChild:cropNode];
    
    SKLabelNode *topLabelNode = [[SKLabelNode alloc] init];
    topLabelNode.text = @"Top";
    topLabelNode.position = CGPointMake(0, 550);
    
    SKLabelNode *bottomLabelNode = [[SKLabelNode alloc] init];
    bottomLabelNode.text = @"Bottom";
    bottomLabelNode.position = CGPointMake(0, 0);
   
    
//        node1=[_nodesitems objectAtIndex:0];
//
//    SKSpriteNode *node2 = [_nodesitems objectAtIndex:1];
//    SKSpriteNode *node3 = [_nodesitems objectAtIndex:2];
//    SKSpriteNode *node4 = [_nodesitems objectAtIndex:3];
//    
//    node1.position = CGPointMake(0, 180);
//    node2.position = CGPointMake(0, 80);
//    node3.position = CGPointMake(0, 280);
//    node4.position = CGPointMake(0, 380);
    int a=80;
    for(int m=0;m<count;m++){
        node1=[_nodesitems objectAtIndex:m];
        node1.position=CGPointMake(0, a);
        [_scrollingNode addChild:node1];
        a+=100;
    
    }
    
    
    [_scrollingNode addChild:topLabelNode];
    [_scrollingNode addChild:bottomLabelNode];
    //[_scrollingNode addChild:node1];
    //[_scrollingNode addChild:node2];
    //[_scrollingNode addChild:node3];
    //[_scrollingNode addChild:node4];
    
    
   
}
-(SKSpriteNode *)makenode:(NSString *)node itemlabel:(NSString *)itemlabel coinlabel:(NSString*)coinlabel name:(NSString *)name heading:(NSString *)heading check:(NSString *)checkname{
    SKSpriteNode *text=(SKSpriteNode *)[self childNodeWithName:@"shop_costumeText"];
    [text setTexture:[SKTexture textureWithImageNamed:heading]];

    SKSpriteNode *back=[[SKSpriteNode alloc]initWithImageNamed:@"imageresource/shop/shop_itemBg"];
    back.zPosition=8;
    NSString *result=[name stringByAppendingString:@"b"];
    back.name=result;
    
   SKLabelNode *shopitemlabel=[[SKLabelNode alloc ]init];
    [shopitemlabel setFontName:@"PoetsenOne-Regular"];
    [shopitemlabel setFontSize:23.0];
    shopitemlabel.name=name;
    shopitemlabel.zPosition=0;
    shopitemlabel.position=CGPointMake(CGRectGetMidX(back.frame)+40, CGRectGetMidY(back.frame));
     [shopitemlabel setFontColor:[UIColor brownColor]];
    [shopitemlabel setText:itemlabel];
   
    [back addChild:shopitemlabel];
      SKSpriteNode *item=[[SKSpriteNode alloc]initWithImageNamed:node];
      item.name=name;
     item.position=CGPointMake(CGRectGetMinX(back.frame)+back.frame.size.height, CGRectGetMidY(back.frame));
    [back addChild:item];
    SKSpriteNode *check=[[SKSpriteNode alloc]initWithImageNamed:@"imageresource/shop/shop_checkSlot"];
    check.position=CGPointMake(CGRectGetMinX(back.frame)+check.frame.size.width/3, CGRectGetMidY(back.frame));
    check.name=checkname;
    [back addChild:check];
    
    SKLabelNode *coinsnum=[[SKLabelNode alloc]init];
    coinsnum.name=name;
    [coinsnum setFontName:@"PoetsenOne-Regular"];
    coinsnum.zPosition=0;
    [coinsnum setFontSize:20.0];
    coinsnum.position=CGPointMake(CGRectGetMidX(back.frame)+40, CGRectGetMinY(back.frame)+10);
    [coinsnum setFontColor:[UIColor brownColor]];
    [coinsnum setText:coinlabel];
    [back addChild:coinsnum];

    return back;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *levels;
    custom_cellTableViewCell *mycell;
    NSNumber *image;
    NSString *descriptions;
    
    if(table_for==0){
        levels= [_challege_name objectAtIndex:indexPath.row];
        descriptions= [_challege objectAtIndex:indexPath.row];
        image=[_bools objectAtIndex:indexPath.row];
    }
    else if(table_for==1){
        
        levels=[_top5 objectAtIndex:indexPath.row];
    }
    
    else {
        NSString *num = [NSString stringWithFormat:@"%li",[[_pointsarray objectAtIndex:indexPath.row] longValue]];
       
        levels=num;
    }
    if(table_for==0 || table_for==1){
        cell= [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
        }
    }
    
    else{
        mycell=[_tableView dequeueReusableCellWithIdentifier:@"mycell"];
        if(!mycell){
            [_tableView registerNib:[UINib nibWithNibName:@"custom cell" bundle:nil] forCellReuseIdentifier:@"mycell"];
            mycell=[_tableView dequeueReusableCellWithIdentifier:@"mycell"];
        }
    }
    
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    //leaderboard
    if(table_for==1){
        
        [cell.textLabel setText:levels];
        cell.imageView.image=nil;
        [cell.detailTextLabel setText:nil];
        
    }
    //achievements
    else if(table_for==0){
        [cell.textLabel setText:levels];
        [cell.detailTextLabel setText:descriptions];
        if([image isEqualToNumber:[NSNumber numberWithInt:0]]){
            
            cell.imageView.frame = CGRectMake( 10, 10, 50, 50 );
            cell.imageView.image = [UIImage imageNamed:@"imageresource/achevement/achievements_button.png"];
            
        }
        else{
            cell.imageView.image = [UIImage imageNamed:@"imageresource/achevement/achievements_checkmark.png"];
        }
    }
    //top5 scores
    else{
        [mycell.name setFont:[UIFont boldSystemFontOfSize:10]];
        [mycell.name setText:[shared sharedInstance].playername];
        [mycell.points setText:levels];
        mycell.myimage.image=[UIImage imageNamed:@"imageresource/achevement/achievements_button.png"];
    }
    
    if(table_for==0||table_for==1){
        return cell;
    }
    else{
        return mycell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    
    if(table_for==0){
        count=[_challege_name count];}
    else if(table_for==1){
        
        count= [_top5 count];
    }
    else{
        count=[_pointsarray count];
    }
    
    return count;
}
#pragma mark Touchbegin Delegates
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    mybool=YES;
    if(customswipe==NO){
        currentLocation={0,0};
        currentlc={0,0};
        customswipe=YES;
    
    }
    UITouch *touch = [touches anyObject];
    
    currentlc = [[touches anyObject] locationInNode:self];
    startTime = touch.timestamp;
    shopcurrent = [[touches anyObject] locationInNode:self];
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameMusic/SFX-4Match" ofType:@"mp3"]];
    buttonpressed = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    
    
    //currentlc = [[touches anyObject] locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:currentlc];
    NSLog(@"%@",touchedNode.name);
    if([touchedNode.name isEqualToString:@"shop_scrollButton1"]){
        
        shopbuttonscroll=1;
    }
    if([touchedNode.name isEqual:@"achievements_topB"]){
        [buttonpressed play];
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_topW"];
        [touchedNode setTexture: playerTexture];
        table_for=2;
        [_tableView reloadInputViews];
        [_tableView reloadData];
        if(achtext!=1){
        [self changetbuttonTexture];
        }
         achtext=1;
    }
    
    if([touchedNode.name isEqual:@"achievements_leaderB"]){
        [buttonpressed play];
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_leaderW"];
        [touchedNode setTexture: playerTexture];
        table_for=1;
        if (add==0) {
            [_top5 addObjectsFromArray:[shared sharedInstance].gamecenter];
        }
        add++;
        [_tableView reloadData];
        if(achtext!=2){
        [self changetbuttonTexture];
        }
          achtext=2;
        
    }
    if([touchedNode.name isEqual:@"achievements_QuestB"]){
        [buttonpressed play];
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_questW"];
        [touchedNode setTexture: playerTexture];
        table_for=0;
        
        [_tableView reloadData];
    
    
    if(screen_identifier==0){
        [_tableView removeFromSuperview];
    }
       
        if(achtext!=3){
           [self changetbuttonTexture];
        }
         achtext=3;
    }
    
    if([touchedNode.name isEqual:@"shop_fallingObjects"]){
        checkid=0;
        [self reintalize];
        shop=1;
        globale=[self makenode:@"imageresource/shop/shop_itemBanana2" itemlabel:@"Banana" coinlabel:@"8370 coins" name:@"banana" heading:@"imageresource/shop/shop_fallingObjectText" check:@"checkf"];
        [_nodesitems addObject:globale];
        globale=[self makenode:@"quick_goodCoin1" itemlabel:@"Coin" coinlabel:@"1000 coins" name:@"coins" heading:@"imageresource/shop/shop_fallingObjectText" check:@"checke"];
        [_nodesitems addObject:globale];
        [_scrollingNode disableScrollingOnView:self.view];
        [self removescrollnode];
        [self scroolnode:2];
        
        [_scrollingNode disableScrollingOnView:third.scene.view];
        [_scrollingNode scrolltoMiddle];
        [self checkinitialize];
        
    }
     if([touchedNode.name isEqual:@"shop_costume" ]){
         checkid=0;
        
         [self shopcf];
         
      shop=0;
     }
    
    
    if([touchedNode.name isEqual:@"shop_misc" ]){
        checkid=0;
        [self reintalize];
        NSArray *heartslabel=[[NSArray alloc]initWithObjects:@"1/3 Hearts",@"2/3 Hearts",@"3/3 Hearts",@"Whole Hearts", nil];
        NSArray *coinslabel=[[NSArray alloc]initWithObjects:@"1000 coins",@"2000 coins",@"1000 coins",@"2000 coins", nil];
        shop=2;
        [self removescrollnode];
        int y=0;
        for(int n=1;n<5;n++){
            NSMutableString* aString = [NSMutableString stringWithFormat:@"imageresource/shop/shop_itemHeart%d",n];
            NSMutableString* a = [NSMutableString stringWithFormat:@"hearts%d",n];
            NSMutableString *r=[NSMutableString stringWithFormat:@"check%d",n];
            globale=[self makenode:aString itemlabel:heartslabel[y] coinlabel:coinslabel[y] name:a heading:@"imageresource/shop/shop_miscText" check:r];
            [_nodesitems addObject:globale];
            y++;
        }
       
        [self scroolnode:4];

        [_scrollingNode enableScrollingOnView:third.scene.view];
        [_scrollingNode scrollToTop];
        [self checkinitialize];
    
    }
    if([touchedNode.name isEqual:@"shop_background2" ]){
        checkid=0;
        shop=3;
        
        [self reintalize];
        NSArray *heartslabel=[[NSArray alloc]initWithObjects:@"ICE",@"Desert",@"Quick",@"Orignal", nil];
        NSArray *coinslabel=[[NSArray alloc]initWithObjects:@"1000 coins",@"2000 coins",@"1000 coins",@"2000 coins", nil];
        [self removescrollnode];
        int y=0;
        for(int n=1;n<5;n++){
            NSMutableString* aString = [NSMutableString stringWithFormat:@"background/quick_background%d",n];
            NSMutableString* a = [NSMutableString stringWithFormat:@"back%d",n];
            NSMutableString *r=[NSMutableString stringWithFormat:@"checkb%d",n];
            globale=[self makenode:aString itemlabel:heartslabel[y] coinlabel:coinslabel[y] name:a heading:@"imageresource/shop/shop_backgroundText" check:r];
            [_nodesitems addObject:globale];
            y++;
        }
        
        [self scroolnode:4];
        
        [_scrollingNode enableScrollingOnView:third.scene.view];
        [_scrollingNode scrollToTop];
        [self checkinitialize];
        
    }
    
    if([touchedNode.name isEqual:@"shop_purchase"]){
        [self buythings];
    }
    
    
}
-(void)changetbuttonTexture{
    SKTexture *buttonTexture;
    if(achtext==1 ){
        abutton=(SKSpriteNode *)[two childNodeWithName:@"achievements_topB"];
       buttonTexture = [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_topB"];
    }
    else if (achtext==2 ){
        abutton=(SKSpriteNode *)[two childNodeWithName:@"achievements_leaderB"];
      
     buttonTexture = [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_leaderB"];
    }
    else if(achtext==3){
        abutton=(SKSpriteNode *)[two childNodeWithName:@"achievements_QuestB"];
     buttonTexture = [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_QuestB"];
    }
    else{
        
    }
    
    [abutton setTexture:buttonTexture];
}
-(void)check:(SKSpriteNode *)node string:(NSString*)name index:(int)index check:(NSString *)checkname{
    

    SKSpriteNode *n;
    
    if([node.name isEqualToString:name] || [node.name isEqualToString:checkname]){
      
    SKNode *my=[node parent];
        n=(SKSpriteNode *)[my childNodeWithName:checkname];
        
        
    }
    else
    {
      
        n=(SKSpriteNode *)[node childNodeWithName:checkname];
      
       
    }
    
   
    
    if([[_check objectAtIndex:index] isEqualToNumber:[NSNumber numberWithInt:0]]){
        
      [n setTexture:[SKTexture textureWithImageNamed:@"imageresource/shop/shop_checkMark"]];
       
        [_check replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
    }
    
    else{
      
          [n setTexture:[SKTexture textureWithImageNamed:@"imageresource/shop/shop_checkSlot"]];
       
      
        [_check replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
    }
    
    
    if(checkid!=0){
        if([temp.name isEqual:n.name]){
         
        }
        else{
        [temp setTexture:[SKTexture textureWithImageNamed:@"imageresource/shop/shop_checkSlot"]];
            [_check replaceObjectAtIndex:preindex withObject:[NSNumber numberWithInt:0]];
                temp=nil;
         
            
        }
       
    }
    
    
    checkid++;
    
    temp=n ;
    preindex=index;
    if(shop!=2){
    [self activate:index];
    }
    if(shop==3){
    [self activateback:index];
    }
    
}
-(NSString*)textureAtlasNamed:(NSString *)fileName{
    
    
    if(self.frame.size.height==1334){//iphone6
        fileName = [NSString stringWithFormat:@"%@-667", fileName];
        
    }
    else if(self.frame.size.height==1104){ //iphone6+
        
        fileName = [NSString stringWithFormat:@"%@-736@2x", fileName];
        
    }
    else if (self.frame.size.height==1136){ //iphone5
        fileName = [NSString stringWithFormat:@"%@-568", fileName];
        
    }
    else if (self.frame.size.height==960){ //iphone4
        fileName =fileName;
        
    }
    else{//iphone6
        fileName = [NSString stringWithFormat:@"%@-667", fileName];
        
    }
    
    
    
    
    return fileName;
}
-(void)changeskin{
    
    NSMutableDictionary *dit = [[NSMutableDictionary alloc] initWithContentsOfFile:highscorelist];
    int mo=0;
    NSNumber *num=[dit objectForKey:@"backactive"];
    NSString *temp,*temp2;
    if([num intValue]==0){
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_backgroundOriginal"];
        
    }
    
    else if ([num intValue]==1){
         temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_background"];
    }
    else if ([num intValue]==2){
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_backgroundDessert"];
    }
    else if ([num intValue]==3){
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_backgroundIce"];
    }
    else{
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_backgroundOriginal"];
    }
    [left setTexture:[SKTexture textureWithImageNamed:temp]];
    [shared sharedInstance].backtexture=temp;
    
    num=[dit valueForKey:@"costumeSelect"];
   
    if([num intValue]==0){
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_warrior2"];
        temp2=[self textureAtlasNamed:@"imageresource/quickGame/quick_lifeBox"];
        mo=0;
    }
    else{
      
        temp=[self textureAtlasNamed:@"imageresource/quickGame/quick_monkey2"];
        temp2=[self textureAtlasNamed:@"imageresource/quickGame/quick_lifeBoxMonkey"];
        mo=1;
    }
    [playericon setTexture:[ SKTexture textureWithImageNamed:temp]];
    [shared sharedInstance].lifeboxtext=temp2;
    [quicklifebox setTexture:[SKTexture textureWithImageNamed:temp2]];
    [shared sharedInstance].monkey=mo;
     


}
-(void)activateback:(int)index{
   
    NSNumber *check;
    NSArray *listback=[[NSArray alloc]initWithObjects:@"backactive",@"backq",@"backd",@"backi",nil];
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *active=[tdict objectForKey:@"backactive"];
    NSLog(@"index%d",index);
    NSLog(@"%dactive",[active intValue]);
    int myaindex=-1;
    if(index!=0){
       
       check=[tdict objectForKey:[listback objectAtIndex:index]];
       
      
    if([check intValue]==1){
        myaindex=index;
        
    }
        NSLog(@"myaindex%d",myaindex);
        
    }
    else{
        myaindex=0;
    }
    if([check intValue]==1 || myaindex==index){
    
    if(myaindex == [active intValue]){
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@" "
                                  message:@"Already Activated!"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"ok", nil];
        
        [alertView show];
        
    }
    
    else{
       
        
      bactiveindex=index;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@" "
                                  message:@"Do you want to Activate!"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"activate", nil];
        alertView.tag=101;
        
        [alertView show];
        
    
    }
    }
    
    
    
    NSLog(@"backactive index%d",bactiveindex);
    
    
    
}
-(void)connection{
    highscorelist= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    highscorelist = [highscorelist stringByAppendingPathComponent:@"highscore.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:highscorelist]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"highscore" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:highscorelist error:nil];
    }
    
    
    
    
    
}
-(void)firstonmenuscreen:(int)identifier{
    [self connection];
    NSMutableDictionary *first=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSArray *message1=[[NSArray alloc]initWithObjects:@"My name is Jason McCoy and thank you for your interest in my game. Please swipe Up, Down, Left, Right to access the menus on the screen!",@"Swipe up to navigate to the Home Screen.",@"Swipe down to navigate to the Home Screen.",@"Swipe Left to navigate to the Home Screen.", nil];
    NSArray *title=[[NSArray alloc]initWithObjects:@"Have Fun!",@"For your Information",@"For your Information",@"Coming Soon!",nil];
    NSString *key;
    int index=0;
    if(identifier==0){
        key=[NSString stringWithFormat:@"first"];
        index=0;
    }
    else if (identifier==1){
      key=[NSString stringWithFormat:@"shop"];
        index=1;
    }
    else if(identifier==2){
    key=[NSString stringWithFormat:@"achievement"];
        index=2;
        
    }
    else if(identifier==4){
      key=[NSString stringWithFormat:@"right"];
        index=3;
    }
    else{
        //nothing
        index=-1;
    }
     NSNumber *f=[first objectForKey:key];
    if(index!=-1){
    if([f intValue]==0){
        
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[title objectAtIndex:index]
                                                          message:[message1 objectAtIndex:index]
                                                         delegate:self
                                                cancelButtonTitle:@"Got it Thanks!"                                                otherButtonTitles:nil];
        if(index==0){
        message.tag=103;
        }
        [message show];
        if(key!=nil){
        [first setObject:[NSNumber numberWithInt:1]forKey:key];
        [first writeToFile:highscorelist atomically:YES];
        }
        
    }
    }
   
    
}
-(void)activate:(int)index{
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *temp,*select;
    NSString *key;
    NSString *selectobject;
    if(shop==0){
        
      key=[[NSString alloc]initWithFormat:@"monkey"];
        selectobject=[[NSString alloc]initWithFormat:@"costumeSelect"];
        
    }
    else if(shop==1){
        key=[[NSString alloc]initWithFormat:@"banana"];
        selectobject=[[NSString alloc]initWithFormat:@"falingobject"];
    }
    select=[tdict objectForKey:selectobject];
    temp=[tdict objectForKey:key];
    if( [temp intValue]==1){
        if([select intValue]==index){
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@" "
                                      message:@"Already Activated!"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"ok", nil];
            
            [alertView show];
        
        }
        else{
           
            //update selection
            
            selection=selectobject;
            myindex=index;
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@" "
                                      message:@"Do You want to Activate"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"activate", nil];
            
            alertView.tag=100;
            [alertView show];
            
        }
    
    }
    
   
   
    
    
    
}
#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self connection];
     NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    if(alertView.tag==100){
        if (buttonIndex == 0)
        {
            NSLog(@"cancel");
        }
        else
        {
            [tdict setObject:[NSNumber numberWithInt:myindex] forKey:selection];
            [tdict writeToFile:highscorelist atomically:YES];
            
            
        }
    }
    
    if(alertView.tag==101){
        if (buttonIndex == 0)
        {
            NSLog(@"cancel");
        }
        else
        {
            [tdict setObject:[NSNumber numberWithInt:bactiveindex] forKey:@"backactive"];
            [tdict writeToFile:highscorelist atomically:YES];
            
            
        }
        
    }
    
    if(alertView.tag==103){
        
        if(buttonIndex==0){
            
            
            UIAlertView *my= [[UIAlertView alloc]
                                      initWithTitle:@"Oh Yeah! Almost forgot!"
                                      message:@"To start off, I’ll give you 783 Catch Coins in exchange for you watching my sponsor’s HD mobile app trailer for 15 seconds. This is so I can make a little cash to help improve your experience. Whaddaya Say?"
                                      delegate:self
                                      cancelButtonTitle:@"Sure,why not!"
                                      otherButtonTitles:@"No,I can't.",nil];
            my.tag=104;
          
            [my show];
        }
        else{
            
        }
    }
    
    if(alertView.tag==104){
        if(buttonIndex==0){
            [self rewardedvideo];
        }
        
        else{
            NSLog(@"cancel");
        }
    }
    
    if(alertView.tag==105){
        if(buttonIndex==0){
            [self reviewmailpopUp];
            NSLog(@"mail");
        }
        else{
            NSLog(@"sure why not!");
            static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
            static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]];
        
            
        }
    }
    
    
    
    
    [self changeskin];
  
}
-(void)reintalize{
    _nodesitems=nil;
    _nodesitems=[[NSMutableArray alloc]init];
}
-(void)shopcf{
    [self reintalize];
    globale=[self makenode:@"imageresource/shop/shop_itemMonkey" itemlabel:@"Monkey" coinlabel:@"7830 coins" name:@"monkey" heading:@"imageresource/shop/shop_costumeText" check:@"checkc"];
    [_nodesitems addObject:globale];
    globale=[self makenode:@"quick_warrior2" itemlabel:@"Warrior" coinlabel:@"1000 coins" name:@"warrior" heading:@"imageresource/shop/shop_costumeText" check:@"checkd"];
    [_nodesitems addObject:globale];
    [self removescrollnode];
    [self scroolnode:2];
    [_scrollingNode disableScrollingOnView:third.scene.view];
    [_scrollingNode scrolltoMiddle];
}
-(void)getcoins{
  highscorelist= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    highscorelist = [highscorelist stringByAppendingPathComponent:@"highscore.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    
    
    
    NSMutableDictionary *dit = [[NSMutableDictionary alloc] initWithContentsOfFile:highscorelist];
    NSNumber *a =[dit objectForKey:@"coins"];
    
   
    
    coin=[a longLongValue];
    
    
    //NSLog(@"coinffffff%lu",[a longLongValue]);
    
}
-(void)buythings{
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *d=[tdict objectForKey:@"monkey"];
    NSNumber *e=[tdict objectForKey:@"banana"];
    if(shop==0){
        if([d intValue]!=1){
            [self buycp];}
        
    }
    
    else if(shop==1){
        if([e intValue]!=1){
        [self buycp];
        }
    }
    
    else if(shop==2){
        [self buyhearts];
        
    }
    
    else if(shop==3){
            [self buybackground];
        
    }
}
-(void)buybackground{
    int index=0,sum=0;
  
 
    NSString *title,*explain;
  
    NSArray *co=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:2000],[NSNumber numberWithInt:1000],nil];
    for (int y=0; y<5; y++) {
        sum=sum+[[_check objectAtIndex:y] intValue];
        if([[_check objectAtIndex:y] intValue]==1){
            index=y;
        }
    }
    
        if(sum>0){
            if([self coincheck:[[co objectAtIndex:index]longValue]]){
                if(index==4){
                    
                        title=[[NSString alloc]initWithFormat:@" "];
                        explain=[[NSString alloc]initWithFormat:@"Already Active"];
                    
                    
                    
                }
                //ice
               else if(index==3){
                  
                    title=[[NSString alloc]initWithFormat:@" "];
                    explain=[[NSString alloc]initWithFormat:@"ICE Background Purchased"];
                    [self updatelist:@"backi" add:0 heartnum:0];
                   [self detuctcoin:[[co objectAtIndex:index] longValue]];
                    
                   
                }
                //desert
                else if(index==2){
                    
                    title=[[NSString alloc]initWithFormat:@" "];
                    explain=[[NSString alloc]initWithFormat:@"Desert Background Purchased"];
                        [self updatelist:@"backd" add:0 heartnum:0];
                    [self detuctcoin:[[co objectAtIndex:index] longValue]];
                }
                //Quick
                else if(index==1){
                    
                    title=[[NSString alloc]initWithFormat:@""];
                    explain=[[NSString alloc]initWithFormat:@"Quick Background Purchased"];
                    [self updatelist:@"backq" add:0 heartnum:0];
                    [self detuctcoin:[[co objectAtIndex:index] longValue]];
                    
                }
                
                
                
            }
            
            
            else{
                title=[[NSString alloc]initWithFormat:@" "];
                explain=[[NSString alloc]initWithFormat:@"Not enough coins sorry!"];
            }
        }
        
        else{
            title=[[NSString alloc]initWithFormat:@"ALert!"];
            explain=[[NSString alloc]initWithFormat:@"Kindly select any item inorder to purchase"];
            
        }
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:explain
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    [alertView show];
    
    
    
    
}
-(void)detuctcoin:(long)coin{
    
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    
     NSNumber *temp= [tdict objectForKey:@"coins"];
    long t=(long)[temp longLongValue];
    t=t-coin;
    
    
    [tdict setObject:[NSNumber numberWithLong:t] forKey:@"coins"];
    [tdict writeToFile:highscorelist atomically:YES];
    
    
    [self showcoins];
    
    


}
-(BOOL)coincheck:(long)coincheck{
    BOOL man;
    if(coincheck<=coin){
        man=YES;
    }
    else{
        man=NO;
    }
    return man;
}
-(void)buyhearts{
  
    int sum=0,index=0;
    NSString *title,*explain;
   
    NSArray *co=[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:1000],[NSNumber numberWithInt:2000],[NSNumber numberWithInt:1000],nil];
    for (int y=0; y<5; y++) {
       sum=sum+[[_check objectAtIndex:y] intValue];
        if([[_check objectAtIndex:y] intValue]==1){
            index=y;
        }
        
    }
   
   
    if(sum>0){
         if([self coincheck:[[co objectAtIndex:index] longValue]]){
        if(index==0){
            int temp1=[self buywholeheart];
            if(temp1==1){
               
                explain=[[NSString alloc]initWithFormat:@"Heart One purchased"];
                title=[[NSString alloc]initWithFormat:@"Heart"];
                [self updatelist:@"heart1" add:0 heartnum:0];
                [self detuctcoin:[[co objectAtIndex:index] longValue]];
                
            }

                //update heart 1
            
            else if (temp1==2){
                
                explain=[[NSString alloc]initWithFormat:@"Heart two purchased"];
                title=[[NSString alloc]initWithFormat:@" "];
                [self updatelist:@"heart2" add:0 heartnum:0];
                [self detuctcoin:[[co objectAtIndex:index] longValue]];
                //update heart 2
            }
            else{
                explain=[[NSString alloc]initWithFormat:@"Already purchased both hearts"];
                title=[[NSString alloc]initWithFormat:@"Alert!"];
            }
        }
        else if(index>0){
        int temp=[self checkhearts];
        if(temp==1){
            explain=[[NSString alloc]initWithFormat:@"Buy whole heart first"];
            title=[[NSString alloc]initWithFormat:@" "];
        }
    
        else if(temp==2){
            explain=[[NSString alloc]initWithFormat:@"Buy whole heart two"];
            title=[[NSString alloc]initWithFormat:@" "];
        }
        
        else{
            //already buy whole heart
            //3/3heart
            if(index==1){
                if(heartli==0){
                    explain=[[NSString alloc]initWithFormat:@"item purchased"];
                    title=[[NSString alloc]initWithFormat:@" "];
                   
                    [self updatelist:@"heart1life" add:1 heartnum:heartnum];
                    [self detuctcoin:[[co objectAtIndex:index] longValue]];

                }
                else{
                    explain=[[NSString alloc]initWithFormat:@"you need other hearts"];
                    title=[[NSString alloc]initWithFormat:@"Alert "];
                    
                    
                }
                
            }
            //2/3 heart
            else if(index==2){
                if(heartli==1 ){
                    NSLog(@"item purchased");
                    explain=[[NSString alloc]initWithFormat:@"item purchased"];
                    title=[[NSString alloc]initWithFormat:@" "];
                    [self updatelist:@"heart1life" add:3 heartnum:heartnum];
                    [self detuctcoin:[[co objectAtIndex:index] longValue]];

                }
                else{
                    explain=[[NSString alloc]initWithFormat:@"you need other hearts"];
                    title=[[NSString alloc]initWithFormat:@"Alert "];
                }
                
            }
            // 1/3heart
            else if(index==3){
                if(heartli==4){
                    NSLog(@"item purchased");
                    explain=[[NSString alloc]initWithFormat:@"item purchased"];
                    title=[[NSString alloc]initWithFormat:@" "];
                    [self updatelist:@"heart1life" add:4 heartnum:heartnum];
                    [self detuctcoin:[[co objectAtIndex:index] longValue]];

                }
                else{
                    explain=[[NSString alloc]initWithFormat:@"you need other hearts"];
                    title=[[NSString alloc]initWithFormat:@"Alert "];
                }
                
            }
            
            }
            
        }
        
         }
         else{
             explain=[[NSString alloc]initWithFormat:@"“Not enough coins sorry!"];
             title=[[NSString alloc]initWithFormat:@"Alert"];
             
         }
        
    }
        
    else{
        title=[NSString stringWithFormat: @"ALert!"];
        explain=[NSString stringWithFormat:@"select any object inorder to buy"];
    }
    
   
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:explain
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    [alertView show];
    
}
-(void)heartwithindex:(int)index{
    
    //3/3heart
    if(index==1){
        if(heartli==0){
            NSLog(@"item purchased");
        }
        else{
            NSLog(@"You need other hearts");
            
            
        }
        
    }
    //2/3 heart
    else if(index==2){
        if(heartli==1 ){
            NSLog(@"item purchased");
        }
        else{
            NSLog(@"you need other hearts");
            
        }
        
    }
    // 1/3heart
    else if(index==3){
        if(heartli==4){
            NSLog(@"item purchased");
        }
        else{
            NSLog(@"you need other heart");
        }
        
    }
    
    
   
    
  
    
}
-(int)buywholeheart{
    int flag=0;
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *hearts=[tdict objectForKey:@"heart1"];
    NSNumber *heart2=[tdict objectForKey:@"heart2"];
    
    if([hearts intValue]==0){
        flag=1;
    }
    else if([heart2 intValue]==0){
        flag=2;
    }
    else{
        flag=0;
    }
    
    return flag;
    
}
-(int)checkhearts{
    int flag=0;
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *hearts=[tdict objectForKey:@"heart1"];
    NSNumber *heart2=[tdict objectForKey:@"heart2"];
    NSNumber *heartlife=[tdict objectForKey:@"heart1life"];
    NSNumber *heartlife2=[tdict objectForKey:@"heart2life"];
    NSLog(@"heartlife%d",[heartlife intValue]);
    if([hearts intValue]!=0){
        if ([heartlife intValue]<8) {
            heartli=[heartlife intValue];
            heartnum=1;
            flag=3;
        }
        else{
            if([heart2 intValue]!=0){
                if([heartlife2 intValue]<8){
                    
                    heartli=[heartlife2 intValue];
                    heartnum=2;
                    flag=3;
                }
            }
            else {
                heartnum=0;
                flag=2;
            }
        }
        
    }
    else {
        heartnum=0;
        flag=1;
    }
    
    
    
    return flag;
}
-(void)updatelist:(NSString *)key add:(int)add heartnum:(int)heartnum{
    [self connection];
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    int temp;
    NSNumber *a;
    if([key isEqualToString:@"heart1life"]){
        if(heartnum==1){
             a=[tdict objectForKey:@"heart1life"];
        }
        else{
            a=[tdict objectForKey:@"heart2life"];
            key=[NSString stringWithFormat:@"heart2life"];
        }
       
        temp=[a intValue];
        temp=temp+add;
       
        [tdict setObject:[NSNumber numberWithInt:temp]forKey:key];
        [tdict writeToFile:highscorelist atomically:YES];
        
        
        
    }
    else{
    [tdict setObject:[NSNumber numberWithInt:1] forKey:key];
        [tdict writeToFile:highscorelist atomically:YES];}
    
}
-(void)alertreview{
    [self connection];
    NSMutableDictionary *my=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *one=[my objectForKey:@"review"];
    
    if([one intValue]==0){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Do you love Catch Crisis?"
                                                          message:@"Please take the time out of your day to review it! I’m really listening"
                                                         delegate:self
                                                cancelButtonTitle:@"No thanks!"                                                otherButtonTitles:@"Sure, why not",nil];
        
        message.tag=105;
        [message show];
        
        [my setObject:[NSNumber numberWithInt:1] forKey:@"review"];
        [my writeToFile:highscorelist atomically:YES];
        
    }
    
    
    
  
    
}
-(void)buycp{
    NSString *title,*explain;
    long buycoin=0;
    NSArray *co=[[NSArray alloc]initWithObjects: [NSNumber numberWithLong:7830],[NSNumber numberWithLong:8370], nil];
    if(shop==0){
      buycoin =[[co objectAtIndex:0] longValue];
    }
    else{
       buycoin =[[co objectAtIndex:1] longValue];
    }
    if([[_check objectAtIndex:0] isEqualToNumber:[NSNumber numberWithInt:1]]){
        NSLog(@"alert dont have to buy this you already have it");
        
         explain=[[NSString alloc]initWithFormat:@"alert dont have to buy this you already have it"];
          title=[[NSString alloc]initWithFormat:@"alert"];
    }
    else if([[_check objectAtIndex:1] isEqualToNumber:[NSNumber numberWithInt:1]]){
        if (coin>=buycoin) {
        NSLog(@"buy this");
            
            explain=[[NSString alloc]initWithFormat:@"Item Purchased"];
            title=[[NSString alloc]initWithFormat:@" "];
            
            if(shop==0){
                [self updatelist:@"monkey" add:0 heartnum:0];
                [self detuctcoin:buycoin];
            }
            else{
               [self updatelist:@"banana" add:0 heartnum:0];
                [self detuctcoin:buycoin];
            }
            [self alertreview];
       
        }
        else{
            NSLog(@"don't have enough coins");
            explain=[[NSString alloc]initWithFormat:@"“Not enough coins sorry!"];
            title=[[NSString alloc]initWithFormat:@" "];
        }
        
    }
    
    else{
        NSLog(@"kindly select any object in order to buy");
        explain=[[NSString alloc]initWithFormat:@"kindly select any object in order to buy"];
        title=[[NSString alloc]initWithFormat:@"Alert!"];
       
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:explain
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    [alertView show];
}
-(void)reviewmailpopUp{
    NSLog(@"pop up");
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = @"1.0";
    NSString *build = @"100";
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
    mailComposer.mailComposeDelegate =self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects: @"support@catchcrisis.com",nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"MailMe V%@ (build %@) Support",version,build]];
    NSString *supportText = [NSString stringWithFormat:@"Device: %@\niOS Version:%@\n\n",model,iOSVersion];
    supportText = [supportText stringByAppendingString: @"Please describe your problem or question."];
    [mailComposer setMessageBody:supportText isHTML:NO];
     //[mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self.view.window.rootViewController presentViewController:mailComposer animated:YES completion:nil];
    
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mail Alert!"
                                                          message:@"Your mobile is not able to send email  please configure email first"
                                                         delegate:self
                                                cancelButtonTitle:@"ok"                                                otherButtonTitles:nil];
        
        [message show];
    }
    
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    int f=0;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
           
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            f=1;
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

     [controller dismissViewControllerAnimated:YES completion:nil];
    if(f==1){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Mail"
                                                          message:@"Your message sent successfully"
                                                         delegate:self
                                                cancelButtonTitle:@"ok"                                                otherButtonTitles:nil];
        
        [message show];
    }
}
-(void)dragaction:(int)p_n firstnode:(SKNode*)first srcondnode:(SKNode *) second move:(int)x_y defaultpos:(CGPoint)defultpos{
    
    if(screen_identifier==0){
        
        [_tableView removeFromSuperview];
        
    }
    SKAction *afirst;
    SKAction *asecond;
    float temp,temp2;
    if(x_y==0){
        if (p_n==0) {
        temp=CGRectGetMaxY(self.frame);
            temp2=temp+(temp/2)+1;
        }
        else{
            temp=CGRectGetMidY(self.frame);
            temp2=-temp;
            
        }
        
        
        afirst=[SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) duration:0.5];
        [first runAction:afirst];
        
        asecond=[SKAction moveToY:temp2 duration:0.5];
        [second runAction:asecond completion:^{
            second.position=defultpos;
            if(table==1){
                _tableView.frame=_temptableView.frame;
                 [two.scene.view  addSubview:_tableView];
            table=0;
            }
            if(screen_identifier==0){
               [_tableView removeFromSuperview];
            }
       
        }];
        
      
    }
    else{
        if(p_n==0){
            temp=CGRectGetMaxX(self.frame);
            temp2=temp+(temp/2)+1;
        }
        else{
            temp=CGRectGetMidX(self.frame);
            temp2=-temp;
        }
        
      afirst=[SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) duration:0.5];
        [first runAction:afirst];
        
        asecond=[SKAction moveToX:temp2 duration:0.5];
        
        [second runAction:asecond completion:^{
            second.position=defultpos;
            [self.view setUserInteractionEnabled:YES];
            
        }
         ];
        
    }

   
    
}
#pragma mark TouchEnded
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(mybool==NO){
    [self arrowpostion:1];
    }
        locked=0;
        outerlock=0;
    shopbuttonscroll=0;
    shopcurrent={0,0};
    shopmoveloc={0,0};
    
    
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        // Determine distance from the starting point
        CGFloat dx = location.x - currentlc.x;
        CGFloat dy = location.y - currentlc.y;
        CGFloat magnitude = sqrt(dx*dx+dy*dy);
        
        // Determine time difference from start of the gesture
        CGFloat dt = touch.timestamp - startTime;
        
        // Determine gesture speed in points/sec
    
        CGFloat speed = magnitude/ dt;
  
        if (speed >=2500) {
            
            if(screen_identifier==0){
                [_tableView removeFromSuperview];
            }
            // Calculate normalized direction of the swipe
            dx = dx / magnitude;
            dy = dy / magnitude;
            NSLog(@"Swipe detected with speed = %g and direction (%g, %g) %d",speed, dx, dy,fmove);
            
            if(fmove==0 && screen_identifier!=4){
                right.position=rightdefault;
                left.position=leftdefault;
               
                if(currentlc.y>currentLocation.y){
                    
                    if(dy<0.00000 ){
                        //[self repeatanim:2];
                        //screen_identifier=1;
                        if(screen_identifier==0){
                            [self dragaction:0 firstnode:third srcondnode:my move:0 defaultpos:mypos];
                            screen_identifier=1;
                        }
                        
                        if(screen_identifier==2){
                            screen_identifier=0;
                           [self dragaction:0 firstnode:my srcondnode:two move:0 defaultpos:twodefault];
                            
                           
                        }
                        
                        
                        
                    }}
                if(currentlc.y<currentLocation.y){
                    
                    if(dy>0.00000){
                        if(screen_identifier==0){
                            NSLog(@"table view123");
                            table=1;
                            [self dragaction:1 firstnode:two srcondnode:my move:0 defaultpos:mypos];
                            
                        screen_identifier=2;
                            
                        }
                        
                        if(screen_identifier==1){
                            
                            [self dragaction:1 firstnode:my srcondnode:third move:0 defaultpos:thriddefault];
                            [_tableView removeFromSuperview];
                            screen_identifier=0;
                        }
                        
                        
                        
                    }}
                
              
            }
            
            
            
            else if (fmove==1){
                if(dx>0){

                    
                    if(screen_identifier==0){
                      [self dragaction:1 firstnode:right srcondnode:my move:1 defaultpos:mypos];
                        screen_identifier=4;}
                    
                }
                else{
                    
                    if(screen_identifier==0){
                        SKAction *moveright=[SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) duration:0.5];
                        [left runAction:moveright];
                        float temp=CGRectGetMaxX(self.frame);
                        SKAction *o=[SKAction moveToX:temp+(temp/2)+1 duration:0.5];
                        
                        [my runAction:o completion:^{
                            my.position=mypos;
                            achievements *nextScene = [[achievements alloc] initWithSize:self.size];
                            SKTransition *doors = [SKTransition fadeWithDuration:0.01];
                            [self.view presentScene:nextScene transition:doors];
                            
                            
                        }
                         ];
                        screen_identifier=3;
                    }
                    
                    if(screen_identifier==4){
                        [self dragaction:0 firstnode:my srcondnode:right move:1 defaultpos:rightdefault];
                        screen_identifier=0;

                    }
                    
                }
            }
            else{
//                twodefault=two.position;
//                thriddefault=third.position;
//                leftdefault=left.position;
//                rightdefault=right.position;
//                mypos=my.position;
                
            }
            
        }
        else{
            if(customswipe){
          
            if(currentlc.y-currentLocation.y>=self.frame.size.height/2.5 && firstmove==0){
          
                
                if(screen_identifier==0){
                    
                   
                    [self dragaction:0 firstnode:third srcondnode:my move:0 defaultpos:mypos];
                    screen_identifier=1;
                    currentnode=third;
                }
                else{
                    if(screen_identifier==2){
                        
                        [self animatescreen];
                    }
                }
                
                
                
            }
            else if(currentLocation.y-currentlc.y>=self.frame.size.height/2.5 && firstmove==0){
                
                    if(screen_identifier==0){
                      
                        table=1;
                        [self dragaction:1 firstnode:two srcondnode:my move:0 defaultpos:mypos];
                       
                        screen_identifier=2;
                        currentnode=two;
                        
                    }
                    else{
                        if(screen_identifier==1){
                            [self animatescreen];
                        }
                    }
                
            }
            else if(currentlc.x-currentLocation.x>=self.frame.size.width/2.5 && firstmove==1){
                
                    if(screen_identifier==0){
                        SKAction *moveright=[SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) duration:0.5];
                        [left runAction:moveright];
                        float temp=CGRectGetMaxX(self.frame);
                        SKAction *o=[SKAction moveToX:temp+(temp/2)+1 duration:0.5];
                        
                        [my runAction:o completion:^{
                            my.position=mypos;
                            achievements *nextScene = [[achievements alloc] initWithSize:self.size];
                            SKTransition *doors = [SKTransition fadeWithDuration:0.01];
                            [self.view presentScene:nextScene transition:doors];
                            
                            
                        }
                         ];
                        screen_identifier=3;
                        currentnode=left;
                    }
                    else{
                        //check via simulator
                        if(screen_identifier==4){
                            [self animatescreen];
                        }
                    }
                
            }
            else if(currentLocation.x-currentlc.x>=self.frame.size.width/2.5 && firstmove==1){
                
                    if(screen_identifier==0){
                        
                        [self dragaction:1 firstnode:right srcondnode:my move:1 defaultpos:mypos];
                        screen_identifier=4;
                    }
                    else{
                        if(screen_identifier==3){
                            [self animatescreen];}
                    }
                
                
            }
            else{
                [self mainMenurepeat];
            }
            }
            else{
               two.position=twodefault;
                third.position=thriddefault;
              left.position=  leftdefault;
               right.position= rightdefault;
                my.position=mypos;

            }
        }
   
    [Flurry logEvent:[self screename]];
    [self firstonmenuscreen:screen_identifier];
    
   CGPoint toend = [[touches anyObject] locationInNode:self];
    
    SKSpriteNode *touchedNode= (SKSpriteNode *)[self nodeAtPoint:toend];
    
    //costumes
    if([touchedNode.name isEqualToString:@"warrior"] || [touchedNode.name isEqualToString:@"warriorb"] || [touchedNode.name isEqualToString:@"checkd"]){
        
        [self check:touchedNode string:@"warrior" index:0 check:@"checkd"];
    }
    
    if([touchedNode.name isEqualToString:@"monkey"] || [touchedNode.name isEqualToString:@"monkeyb"] || [touchedNode.name isEqualToString:@"checkc"]){
        
        [self check:touchedNode string:@"monkey" index:1 check:@"checkc"];
    }
    //fallingobjects
    
    if([touchedNode.name isEqualToString:@"coins"] || [touchedNode.name isEqualToString:@"coinsb"] || [touchedNode.name isEqualToString:@"checke"]){
        
        [self check:touchedNode string:@"coins" index:0 check:@"checke"];
    }
    if([touchedNode.name isEqualToString:@"banana"] || [touchedNode.name isEqualToString:@"bananab"] || [touchedNode.name isEqualToString:@"check4"]){
        
        [self check:touchedNode string:@"banana" index:1 check:@"checkf"];
    }
    
    
    //hearts
    if([touchedNode.name isEqualToString:@"hearts4"] || [touchedNode.name isEqualToString:@"hearts4b"] || [touchedNode.name isEqualToString:@"check4"]){
        
        [self check:touchedNode string:@"hearts4" index:0 check:@"check4"];
    }
    
    if([touchedNode.name isEqualToString:@"hearts3"] || [touchedNode.name isEqualToString:@"hearts3b"] || [touchedNode.name isEqualToString:@"check3"]){
        
        [self check:touchedNode string:@"hearts3" index:1 check:@"check3"];
    }
    
    if([touchedNode.name isEqualToString:@"hearts2"] || [touchedNode.name isEqualToString:@"hearts2b"] || [touchedNode.name isEqualToString:@"check2"]){
        
        [self check:touchedNode string:@"hearts2" index:2 check:@"check2"];
    }
    if([touchedNode.name isEqualToString:@"hearts1"] || [touchedNode.name isEqualToString:@"hearts1b"] || [touchedNode.name isEqualToString:@"check1"]){
        
        [self check:touchedNode string:@"hearts1" index:3 check:@"check1"];
    }
    
    
    //backgrounds
    if([touchedNode.name isEqualToString:@"back4"] || [touchedNode.name isEqualToString:@"back4b"] || [touchedNode.name isEqualToString:@"checkb4"]){
        
        [self check:touchedNode string:@"back4" index:0 check:@"checkb4"];
    }
    
    if([touchedNode.name isEqualToString:@"back3"] || [touchedNode.name isEqualToString:@"back3b"] || [touchedNode.name isEqualToString:@"checkb3"]){
        
        [self check:touchedNode string:@"back3" index:1 check:@"checkb3"];
    }
    
    if([touchedNode.name isEqualToString:@"back2"] || [touchedNode.name isEqualToString:@"back2b"] || [touchedNode.name isEqualToString:@"checkb2"]){
        
        [self check:touchedNode string:@"back2" index:2 check:@"checkb2"];
    }
    if([touchedNode.name isEqualToString:@"back1"] || [touchedNode.name isEqualToString:@"back1b"] || [touchedNode.name isEqualToString:@"checkb1"]){
        
        [self check:touchedNode string:@"back1" index:3 check:@"checkb1"];
    }
   
        
}
-(void)mainMenurepeat{
    if(screen_identifier==0){
        
        if(currentlc.y>currentLocation.y){
            
            [self repeatanim:1];}
        if(currentlc.y< currentLocation.y){
            [self repeatanim:0];
        }
        
        if(currentlc.x>currentLocation.x){
            [self.view setUserInteractionEnabled:NO];
            [self repeatanim:4];
        }
        if(currentlc.x<currentLocation.x){
            [self.view setUserInteractionEnabled:NO];
            [self repeatanim:7];
        }
        
    }
    
    else if(screen_identifier==1){
        [self repeatanim:2];
    }
    
    else if(screen_identifier==2){
        [self repeatanim:3];
        
    }
    else if(screen_identifier==3){
        [self repeatanim:5];
        
    }
    else if(screen_identifier==4){
        [self repeatanim:6];
        
    }

}
-(void)repeatanim:(int) b{
    
    if(b==0){
       
        
        [self dragaction:0 firstnode:my srcondnode:two move:0 defaultpos:twodefault ];
        
        
    }
    else if(b==1){
        
        [self dragaction:1 firstnode:my srcondnode:third move:0 defaultpos:thriddefault];
        
    }
    
    else if(b==2){
        
        
        [self dragaction:0 firstnode:third srcondnode:my move:0 defaultpos:mypos];
        
    }
    
    else if(b==3){
        table=1;
        [self dragaction:1 firstnode:two srcondnode:my move:0 defaultpos:mypos];
        //_tableView.frame=_temptableView.frame;
        
        [UIView animateWithDuration:0.6 animations:^{
            [_tableView setFrame:_temptableView.frame];
        } completion:^(BOOL finished) {
            _tableView.frame=_temptableView.frame;
        }];
        
    }
    else if(b==4){
        
        
        [self dragaction:1 firstnode:my srcondnode:left move:1 defaultpos:leftdefault];
        
    }
    
    else if(b==5){
        
        [self dragaction:0 firstnode:left srcondnode:my move:1 defaultpos:mypos];
    }
    
    else if(b==6){
       
        [self dragaction:1 firstnode:right srcondnode:my move:1 defaultpos:mypos];
    }
    
    
    else if(b==7){
        [self dragaction:0 firstnode:my srcondnode:right move:1 defaultpos:rightdefault];
    
    }
    
    
}
-(void)animatescreen{
    if(screen_identifier==1 ){
       
        [self dragaction:1 firstnode:my srcondnode:third move:0 defaultpos:thriddefault];
        screen_identifier=0;
        currentnode=my;
    }
    
    
    else if(screen_identifier==2){
        screen_identifier=0;
        
        [self dragaction:0 firstnode:my srcondnode:two move:0 defaultpos:twodefault];
        currentnode=my;
       
    }
    
    else if(screen_identifier==3){
        
        [self dragaction:1 firstnode:my srcondnode:left move:1 defaultpos:leftdefault];
        screen_identifier=0;
        currentnode=my;
    }
    
    else if(screen_identifier==4){
       
        [self dragaction:0 firstnode:my srcondnode:right move:1 defaultpos:rightdefault];
        screen_identifier=0;
        currentnode=my;
    }
    
}
#pragma mark TouchMoved
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"screen identifier %d",screen_identifier);
    currentLocation =[[touches anyObject] locationInNode:self];
    UITouch *touch = [touches anyObject];
   shopmoveloc =[touch  locationInNode:self];
    CGPoint lastPosition = [touch previousLocationInNode:self];
        //NSArray *a=[[self gameWorldNode] nodesAtPoint:location];
    /* for(SKNode *node in a)
     {//right
     NSLog(@"%@ku,n",[node name]);
     
     }*/
    if(outerlock==0){
        instantlocation=[[touches anyObject]locationInNode:self];
        
       
    if(((currentlc.y>instantlocation.y) || (currentlc.y<instantlocation.y)) && ((currentlc.y-instantlocation.y>10)|| (instantlocation.y-currentlc.y>10)) ){
        NSLog(@"move vertical");
        fmove=0;
        i=1;
        locked=0;
        firstmove=0;
        
    }
  
  
    else if((currentlc.x>instantlocation.x) || (currentlc.x<instantlocation.x)){
    
        NSLog(@"move horizontal");
       
        fmove=1;
        i=2;
        locked=1;
        firstmove=1;
    
    }
    outerlock=1;
    
}
    if(shopbuttonscroll==0){
    if(screen_identifier==0){
        [self extrahearts];
        if(locked==0){
            if(i==1){
                if(currentlc.y>instantlocation.y){
                    NSLog(@"down");
                    textstring=[NSString stringWithFormat:@"menu_shop"];
                    arrowstring=[NSString stringWithFormat:@"menu_button4"];
                    
                    
                    if(currentlc.y>currentLocation.y){
                    [my setPosition:CGPointMake(CGRectGetMidX(my.frame),CGRectGetMidY(self.frame)+(currentlc.y-currentLocation.y) )];
                    //second.position=CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-((man.frame.size.height)-(currentLocation.y-currentlc.y)));
                    
                    [third setPosition:CGPointMake(CGRectGetMidX(third.frame), (CGRectGetMidY(self.frame)-(third.frame.size.height))+(currentlc.y-currentLocation.y))];
                    }
                    else{
                        customswipe=NO;
                    }
                    
                }
                if(currentlc.y<instantlocation.y){
                    NSLog(@"up");
                    textstring=[NSString stringWithFormat:@"menu_achievements"];
                    arrowstring=[NSString stringWithFormat:@"menu_button2"];
                    if(currentLocation.y>currentlc.y){
                    [my setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-(currentLocation.y-currentlc.y) )];
                    
                    
                    
                    [two setPosition:CGPointMake(CGRectGetMidX(two.frame),(CGRectGetMidY(self.frame)+(two.frame.size.height))-(currentLocation.y-currentlc.y))];
                    }
                    else{
                        customswipe=NO;
                    }
                }
            }
        }
        if(locked==1){
            if(i==2){
                // from left to right
                
            
                if(currentlc.x<instantlocation.x){
                    NSLog(@"left");
                    textstring=[NSString stringWithFormat:@"menu_storyMode"];
                    arrowstring=[NSString stringWithFormat:@"menu_button3"];

                    if(currentlc.x<currentLocation.x){
                    [my setPosition:CGPointMake(CGRectGetMidX(self.frame)-(currentLocation.x-currentlc.x),CGRectGetMidY(my.frame) )];
                    
                    [right setPosition:CGPointMake((CGRectGetMidX(self.frame)+(right.frame.size.width))-(currentLocation.x-currentlc.x),CGRectGetMidY(right.frame))];
                    }
                
                else{
                    customswipe=NO;
                }
                
                }
                }
                
                //from right to left
                
                
                if(currentlc.x>instantlocation.x){
                    NSLog(@"right");
                    textstring=[NSString stringWithFormat:@"menu_quickPlay"];
                    arrowstring=[NSString stringWithFormat:@"menu_button1"];
                    if(currentlc.x>currentLocation.x){
                    [my setPosition:CGPointMake(CGRectGetMidX(self.frame)+(currentlc.x-currentLocation.x),CGRectGetMidY(my.frame) )];
                    
                    [left setPosition:CGPointMake((CGRectGetMidX(self.frame)-(left.frame.size.width))+(currentlc.x-currentLocation.x),CGRectGetMidY(left.frame))];
                    }
                    else{
                        customswipe=NO;
                    }
                    
                    
                    
                }
                
            
        }
    }
    
        if(screen_identifier==1){
            if(instantlocation.y>currentlc.y){
                if(fmove==0){
                    
                    if(currentLocation.y>currentlc.y){
                        [third setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-(currentLocation.y-currentlc.y) )];
                        
                        
                        
                        [my setPosition:CGPointMake(CGRectGetMidX(my.frame),(CGRectGetMidY(self.frame)+(my.frame.size.height))-(currentLocation.y-currentlc.y))];
                    }
                    
                    
                }
    }
    }
    
    if(screen_identifier==2){
        if(fmove==0){
        if(currentlc.y>instantlocation.y){
            
            if(currentLocation.y<currentlc.y){
            [two setPosition:CGPointMake(CGRectGetMidX(two.frame),CGRectGetMidY(self.frame)+(currentlc.y-currentLocation.y) )];
            //second.position=CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-((man.frame.size.height)-(currentLocation.y-currentlc.y)));
                [_tableView setFrame:CGRectMake(CGRectGetMidX(_tableView.frame)/4,CGRectGetMidY(_tableView.frame)/2-(currentlc.y-currentLocation.y)/4,_tableView.frame.size.width ,_tableView.frame.size.height)];
            
            [my setPosition:CGPointMake(CGRectGetMidX(my.frame), (CGRectGetMidY(self.frame)-(my.frame.size.height))+(currentlc.y-currentLocation.y))];
            }
        }
        }
        
        
    }
    
    if(screen_identifier==3){
        if(fmove==1){
        if(instantlocation.x>currentlc.x){
            
            [left setPosition:CGPointMake(CGRectGetMidX(self.frame)-(currentLocation.x-currentlc.x),CGRectGetMidY(my.frame) )];
            
            [my setPosition:CGPointMake((CGRectGetMidX(self.frame)+(my.frame.size.width))-(currentLocation.x-currentlc.x),CGRectGetMidY(my.frame))];
            
            
        }
        }
    }
    
    if(screen_identifier==4){
        if(fmove==1){
        if(currentlc.x>instantlocation.x){
            if(currentLocation.x<currentlc.x){
            [right setPosition:CGPointMake(CGRectGetMidX(self.frame)+(currentlc.x-currentLocation.x),CGRectGetMidY(right.frame) )];
            
            [my setPosition:CGPointMake((CGRectGetMidX(self.frame)-(my.frame.size.width))+(currentlc.x-currentLocation.x),CGRectGetMidY(my.frame))];
            }
        }
        }
    }
    
    }
    if(shopbuttonscroll==1){
        if(shop==2 || shop==3){
            if(shopcurrent.y>shopmoveloc.y){
                
                if(scrollbutton.position.y>minshopButtonpos){
                    
                    [scrollbutton setPosition:CGPointMake(scrollbutton.position.x,scrollbutton.position.y+(shopmoveloc.y - lastPosition.y))];
                    dragvalue+=2;
                    
                   
                    [_scrollingNode scrolltoCustom:dragvalue];
                    
                }
                
            }
            
            if(shopcurrent.y<shopmoveloc.y){
                
                
                if(scrollbutton.position.y<maxshopButtonpos){
                    [scrollbutton setPosition:CGPointMake(scrollbutton.position.x,scrollbutton.position.y+(shopmoveloc.y-lastPosition.y))];
                    dragvalue-=2.2;
                    [_scrollingNode scrolltoCustom:dragvalue];
                    
                }
                
                
            }
            
            if(dragvalue<-325){
             
                dragvalue=-325;
            }
            if(dragvalue>-135){
                
                dragvalue=-135;
            }
//            NSLog(@"button%g",scrollbutton.position.y);
            if(scrollbutton.position.y>98){
                [_scrollingNode scrolltoCustom:-325];
                dragvalue=-325;
                
            }
            if(scrollbutton.position.y<-90){
                [_scrollingNode scrolltoCustom:-121];
                dragvalue=-135;
            }
        }
    }
    if(mybool){
    [self arrowpostion:0];
        mybool=NO;
    }
    
}

-(void)willMoveFromView:(SKView *)view{
    my.position=mypos; 
    two.position=twodefault;
    third.position=thriddefault;
    right.position=rightdefault;
    left.position=leftdefault;
    screen_identifier=0;
    firstmove=0;
     i=0,locked=0,outerlock=0,animatelock=0;
    currentlc={0.0,0.0};
   currentLocation={0.0,0.0};
    [bplay stop];
    [_scrollingNode disableScrollingOnView:view];
}
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    
    gmarray=[[NSMutableArray alloc]init];
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
                    for(int i=temp.length;i<14;i++){
                        [temp appendString:@" "];
                    }
                    
                    [temp appendString:temp2];
                    [gmarray insertObject:temp atIndex:old];
                    // NSLog(@"ab%@",my);
                    old++;
                    
                }
                NSLog(@"%@12323",gmarray);
                [[shared sharedInstance].gamecenter addObjectsFromArray:gmarray];
                NSLog(@"%@gamecenter",[shared sharedInstance].gamecenter);
                
                
            }
        }];
    }
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)makebutton{
         scrollbutton=(SKSpriteNode *)[self childNodeWithName:@"shop_scrollButton1"];
}
-(void)getScrollbutton{
    
    //scrollbutton.position=CGPointMake(scrollbutton.position.x,[shared sharedInstance].shopbutton+200);
    
}
-(void)moveSliderWithValue:(int)value{
    NSLog(@"in method");
    NSLog(@"delegateValue %d",value);
}
-(void)extrahearts{
    [self connection];
    NSMutableDictionary *tdict=[[NSMutableDictionary alloc]initWithContentsOfFile:highscorelist];
    NSNumber *hearts=[tdict objectForKey:@"heart1"];
    NSNumber *hlife=[tdict objectForKey:@"heart1life"];
     NSNumber *falling=[tdict objectForKey:@"falingobject"];
    
    if([hearts intValue]==1){
        
        
        [self getlife:[hlife intValue] var:0];
        
            hearts=[tdict objectForKey:@"heart2"];
            
            if([hearts intValue]==1){
                hlife=[tdict objectForKey:@"heart2life"];
                [self getlife:[hlife intValue] var:1];
            }
            
            
        }
    else{
        [shared sharedInstance].heart1life=0;
        [shared sharedInstance].heart1tex=@"imageresource/quickGame/quick_heartLock";
        [shared sharedInstance].heart2life=0;
        [shared sharedInstance].heart2tex=@"imageresource/quickGame/quick_heartLock";
    }
    SKSpriteNode *node=(SKSpriteNode *)[self childNodeWithName:@"quick_scoreBox"];
    if ([falling intValue]==1) {
        [node setTexture:[SKTexture textureWithImageNamed:[self textureAtlasNamed:@"quick_scoreBoxmonkey"]]];
    }
}

-(void)getlife:(int)heartlife var:(int)var{
    NSLog(@"heartlife %d",heartlife);
    int temp=0;
    NSString *texture;
    if(heartlife>=0){
        
        if(heartlife==1){
            temp=1;
            texture=[NSString stringWithFormat:@"heart_life_3"];
        }
        else if (heartlife==4){
            temp=2;
            texture=[NSString stringWithFormat:@"heart_life_2"];
        }
        else if (heartlife==8){
            temp=3;
            texture=[NSString stringWithFormat:@"imageresource/quickGame/quick_heart"];
            
        }
        else{
            temp=0;
            texture=[NSString stringWithFormat:@"emptyheart"];
        }
    }
    
    if(var==0){
       
        [shared sharedInstance].heart1life=temp;
        [shared sharedInstance].heart1tex=texture;
        [heart1 setTexture:[SKTexture textureWithImageNamed:[shared sharedInstance].heart1tex]];
    }
    else{
        [shared sharedInstance].heart2life=temp;
        [shared sharedInstance].heart2tex=texture;
          [heart2 setTexture:[SKTexture textureWithImageNamed:[shared sharedInstance].heart2tex]];
    }
    
    
}
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    [self connection];
    NSMutableDictionary *dit = [[NSMutableDictionary alloc] initWithContentsOfFile:highscorelist];
    NSNumber *temp= [dit objectForKey:@"coins"];
    long t=(long)[temp longLongValue];
    t=t+738;
    
    [dit setObject:[NSNumber numberWithLong:t] forKey:@"coins"];
    [dit writeToFile: highscorelist atomically:YES];
    
}
- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Rwarded Video!"
                              message:@"did not displayed due to some error"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"ok", nil];
    
    [alertView show];
    
    
}

@end
