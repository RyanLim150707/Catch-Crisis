//
//  shared.m
//  catch crises
//
//  Created by Jason M McCoy on 06/05/2015.
//  Copyright (c) 2015 VLADU BOGDAN DANIEL PFA. All rights reserved.
/*this program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.*/

#import "shared.h"

@implementation shared
@synthesize gamecenter;
@synthesize score;
@synthesize flag;
@synthesize playername;
@synthesize backtexture,heart2life,heart1life,heart1tex,heart2tex,lifeboxtext,endtexture;
static shared* sharedInstance;

+ (shared*)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[shared alloc] init];
        
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        gamecenter = [[NSMutableArray alloc] init];
        
    }
    return self;
}


@end
