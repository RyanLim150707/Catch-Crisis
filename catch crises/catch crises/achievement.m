//
//  achievement.m
//  catch crises
//
//  Created by Jason M McCoy on 10/04/2015.
//  Copyright (c) 2015 VLADU BOGDAN DANIEL PFA. All rights reserved.
/*this program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.*/

#import "achievement.h"
#import "pause_game.h"
#import "custom cellTableViewCell.h"
#import "achievements.h"
#import "LHSceneSubclass.h"
@implementation achievement
#define kMinDistance    15
#define kMinDuration    0.01
#define kMinSpeed       50
#define kMaxSpeed       500
CGPoint  acurrentlc,acurrentLocation;
UISwipeGestureRecognizer* swipeupgesture;
long actualPlayerLevel_=1;
static int table_=0;
int olock_=0,fmove_=0;

NSTimeInterval startTime;

+(id)scene
{
    
    return [[achievement alloc] initWithContentOfFile:@"publishresource/achievements.lhplist"];
    
    
}

-(id)initWithContentOfFile:(NSString *)levelPlistFile{
    
    if(self = [super initWithContentOfFile:levelPlistFile])
    {
        /*INIT YOUR CONTENT HERE*/
        
#if LH_USE_BOX2D
        NSLog(@"USES BOX2D");
#else
        NSLog(@"USES CHIPMUNK");
#endif
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    
    
  
    _challege_=[[NSMutableArray alloc]init];
    _challege_n=[[NSMutableArray alloc]init];
    _bools_=[[NSMutableArray alloc]init];
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questsPList" ofType:@"plist"]];
    
    
    NSArray *arrayValues=[[NSArray alloc] initWithArray:[dictRoot valueForKey:@"QuestsArray"]];
    //NSLog(@"%@",arrayValues);
    NSInteger value=0;
    NSLog(@"%@",arrayValues);
    while([arrayValues count]!= value){
        NSArray *items=[[NSArray alloc] initWithArray:[arrayValues objectAtIndex:value]];
        [_challege_n addObject:[items objectAtIndex:0]];
        [_challege_ addObject:[items objectAtIndex:1]];
        [_bools_ addObject:[items objectAtIndex:2]];
       
        value++;
    }
    NSDictionary *top5 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"top5" ofType:@"plist"]];
    
   _top5_=[[NSArray alloc] initWithArray:[top5 valueForKey:@"top5"]];
   // swipeupgesture.delegate=self;
    
    
    //[self setDelegate:(id)[NSNumber numberWithInt:UISwipeGestureRecognizerDirectionUp]];
    
    
   // swipeupgesture= [[UISwipeGestureRecognizer alloc] initWithTarget: self /action:@selector( handleSwipeUp:)];
        //[swipeupgesture setDirection: UISwipeGestureRecognizerDirectionUp];
    
   // [self.view addGestureRecognizer:swipeupgesture];
   
    if(self.frame.size.height==1334){//iphone6
        _tablev = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)-5,CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.4)];
        
    }
   else if(self.frame.size.height==1104){ //iphone6+
         _tablev = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/13)+10,CGRectGetMaxY(self.frame)/5, self.frame.size.width/2-13, self.frame.size.height/2.62)];
        }
  else if (self.frame.size.height==1136){ //iphone5
       _tablev = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)-3,CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.6)];
   }
    
 else if (self.frame.size.height==960){ //iphone4
      _tablev = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)+2,CGRectGetMaxY(self.frame)/7, self.frame.size.width/2.7, self.frame.size.height/3.1)];
  }
 else{
     _tablev = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+(self.frame.size.width/15)-5,CGRectGetMaxY(self.frame)/7+3, self.frame.size.width/2.7, self.frame.size.height/3.4)];
     
 
 }

    
    _tablev.dataSource = self;
    _tablev.delegate = self;
    
    [self.view.self addSubview:_tablev];
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    NSString *levels;
    custom_cellTableViewCell *mycell;
    NSNumber *image;
    NSString *descriptions;
    
    if(table_==0){
     levels= [_challege_n objectAtIndex:indexPath.row];
    descriptions= [_challege_ objectAtIndex:indexPath.row];
   image=[_bools_ objectAtIndex:indexPath.row];
    }
    else if(table_==1){
        levels=[_top5_ objectAtIndex:indexPath.row];
    }
    
    else {
        
    }
    if(table_==0 || table_ ==1){
        cell= [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
    }
    }
    
    else{
        mycell=[_tablev dequeueReusableCellWithIdentifier:@"mycell"];
        if(!mycell){
            [_tablev registerNib:[UINib nibWithNibName:@"custom cell" bundle:nil] forCellReuseIdentifier:@"mycell"];
        mycell=[_tablev dequeueReusableCellWithIdentifier:@"mycell"];
       }
    }
    
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    if(table_==1){
   
    [cell.textLabel setText:levels];
        cell.imageView.image=nil;
        [cell.detailTextLabel setText:nil];
        
    }

    else if(table_==0){
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
    
    else{
        [mycell.name setText:@"name"];
        [mycell.points setText:@"points"];
        mycell.myimage.image=[UIImage imageNamed:@"imageresource/achevement/achievements_button.png"];
    }
    
    if(table_==0||table_==1){
    return cell;
    }
    else{
        return mycell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if(table_==0){
        count=[_challege_n count];}
    else if(table_==1){
      count= [_top5_ count];
    }
    else{
        count=[_top5_ count];
    }
    
    return count;
}

-(void)handleSwipeUp:( UISwipeGestureRecognizer *) recognizer{
   SKView * skView = (SKView *)self.view;
    
    SKScene *scene;
    scene = [LHSceneSubclass scene] ;
    [_tablev removeFromSuperview];

    // Present the scene.
   /* [skView presentScene:scene];*/
    
    [skView presentScene:scene];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
     CGPoint currentLocation = [[touches anyObject] locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
    if([touchedNode.name isEqual:@"achievements_topB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_topW"];
        [touchedNode setTexture: playerTexture];
        
      
       
    }
    
    if([touchedNode.name isEqual:@"achievements_leaderB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_leaderW"];
        [touchedNode setTexture: playerTexture];
        
    }
    if([touchedNode.name isEqual:@"achievements_QuestB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_QuestW"];
        [touchedNode setTexture: playerTexture];
      
    }
     acurrentlc = [[touches anyObject] locationInNode:self];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint  currentLocation = [[touches anyObject] locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:currentLocation];
    if([touchedNode.name isEqual:@"achievements_topB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_topB"];
        [touchedNode setTexture: playerTexture];
      
        table_=2;
        [_tablev reloadData];
    }
    
    if([touchedNode.name isEqual:@"achievements_leaderB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_leaderB"];
        [touchedNode setTexture: playerTexture];
        NSLog(@"touched");
        table_=1;
        [_tablev reloadData];
    }
    if([touchedNode.name isEqual:@"achievements_QuestB"]){
        SKTexture *playerTexture= [SKTexture textureWithImageNamed:@"imageresource/achevement/achievements_QuestB"];
        [touchedNode setTexture: playerTexture];
        NSLog(@"touched");
        table_=0;
        [_tablev reloadData];
        
    }
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    // Determine distance from the starting point
    CGFloat dx = location.x - acurrentlc.x;
    CGFloat dy = location.y - acurrentlc.y;
    CGFloat magnitude = sqrt(dx*dx+dy*dy);
    
    // Determine time difference from start of the gesture
    CGFloat dt = touch.timestamp - startTime;
    
    // Determine gesture speed in points/sec
    NSLog(@"1");
    CGFloat speed = magnitude / dt;
    if (speed <1000 || speed>1000) {
        // Calculate normalized direction of the swipe
        dx = dx / magnitude;
        dy = dy / magnitude;
        
        NSLog(@"Swipe detected with speed = %g and direction (%g, %g)",speed, dx, dy);
        if(dy<0 && fmove_==0){
            NSLog(@"2");
           
           
        }
        else if(dy>0 && fmove_==1){
            NSLog(@"3");
            
            UIGraphicsBeginImageContext(self.view.window.bounds.size);
            [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData * data = UIImagePNGRepresentation(image);
            NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myImage.png"];
            [data writeToFile:imagePath atomically:YES];
            SKView *spriteView = (SKView*)self.view;
            
            SKScene * scene;
            
            scene = [LHSceneSubclass scene] ;
            [_tablev removeFromSuperview];

            // Present the scene.
            [spriteView presentScene:scene transition:nil];
           

            
        }
       
        
    }
    
    olock_=0;
    fmove_=0;
  
}

-(void)willMoveFromView:(SKView *)view{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
        
        
        acurrentLocation =[[touches anyObject] locationInNode:self];
        
        
        if(olock_==0){
            
            if((acurrentlc.y>acurrentLocation.y) ){
               
                fmove_=0;
                
            }
          if((acurrentLocation.y>acurrentlc.y)){
                
                
                fmove_=1;
            }
            olock_=1;
            
        }

}


@end
