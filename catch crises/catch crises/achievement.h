//
//  achievement.h
//  catch crises
//
//  Created by Jason M McCoy on 10/04/2015.
//  Copyright (c) 2015 VLADU BOGDAN DANIEL PFA. All rights reserved.
/*this program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.*/

#import "LHScene.h"

@interface achievement : LHScene<UITableViewDataSource, UITableViewDelegate >
+(id)scene;
@property (retain, nonatomic) IBOutlet UITableView *tablev;
@property (strong, nonatomic) NSMutableArray *challege_n;
@property (strong, nonatomic) NSMutableArray *challege_;
@property (strong, nonatomic) NSMutableArray *bools_;
@property (strong, nonatomic) NSArray *top5_;

@end
