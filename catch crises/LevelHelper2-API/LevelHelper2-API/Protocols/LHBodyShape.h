//
//  LHBodyShape.h
//  LevelHelper2-API
//
//  Created by Bogdan Vladu on 19/01/15.
//  Copyright (c) 2015 VLADU BOGDAN DANIEL PFA. All rights reserved.
/*this program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.*/

#import <Foundation/Foundation.h>

#import "LHConfig.h"
#import <SpriteKit/SpriteKit.h>

#if LH_USE_BOX2D

#ifdef __cplusplus
class b2Body;
class b2Vec2;
class b2Fixture;
#endif

@class LHScene;

@interface LHBodyShape : NSObject

+(id)createRectangleWithDictionary:(NSDictionary*)dict body:(b2Body*)body node:(SKNode*)node scene:(LHScene*)scene size:(CGSize)size;
+(id)createCircleWithDictionary:(NSDictionary*)dict body:(b2Body*)body node:(SKNode*)node scene:(LHScene*)scene size:(CGSize)size;

+(id)createWithDictionary:(NSDictionary*)dict
              shapePoints:(NSArray*)shapePoints
                     body:(b2Body*)body
                     node:(SKNode*)node
                    scene:(LHScene*)scene
                    scale:(CGPoint)scale;

+(id)createChainWithDictionary:(NSDictionary*)dict
                   shapePoints:(NSArray*)shapePoints
                         close:(BOOL)close
                          body:(b2Body*)body
                          node:(SKNode*)node
                         scene:(LHScene*)scene
                         scale:(CGPoint)scale;

+(id)createWithDictionary:(NSDictionary*)dict
                triangles:(NSArray*)triangles
                     body:(b2Body*)body
                     node:(SKNode*)node
                    scene:(LHScene*)scene
                    scale:(CGPoint)scale;

+(id)createWithName:(NSString*)name pointA:(CGPoint)ptA pointB:(CGPoint)ptB node:(SKNode*)node scene:(LHScene*)scene;

+(id)createWithDictionary:(NSDictionary*)dict body:(b2Body*)body node:(SKNode*)node scene:(LHScene*)scene scale:(CGPoint)scale;

-(NSString*)shapeName;
-(void)setShapeName:(NSString*)nm;

-(int)shapeID;
-(void)setShapeID:(int)val;

+(LHBodyShape*)shapeForB2Fixture:(b2Fixture*)fix;

@end


#endif //LH_USE_BOX2D
