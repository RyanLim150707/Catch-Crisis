//
//  LHNodePhysicsProtocol.h
//  LevelHelper2-SpriteKit
//
//  Created by Bogdan Vladu on 14/06/14.
//  Copyright (c) 2014 VLADU BOGDAN DANIEL PFA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LHConfig.h"

#if LH_USE_BOX2D
#ifdef __cplusplus
class b2Body;
#endif
#endif //LH_USE_BOX2D

typedef enum
{
	LH_STATIC_BODY = 0,
	LH_KINEMATIC_BODY,//not available in chipmunk - wil used dynamic instead
	LH_DYNAMIC_BODY,
    LH_NO_PHYSICS
    
} LH_PHYSICS_TYPE;


@protocol LHNodePhysicsProtocol <NSObject>

@required

/**
 Returns the type of the physics body.
 @return A LH_PHYSICS_TYPE enum value; 0 = static, 1 = Kinematic (not available in Chipmunk), 2 = Dynamic, 3 = No Physics
 */
-(int)physicsType;

/**
 Set the physics body type; 
 Note: On Box2d setting a body to No Physics type will not actually delete the body but will make it inactive. It will no longer participate in physics simulation, but it will still exist in order to make it dynamic/static later on.
 Node: On Chipmunk setting a body to No Physics will make it static and sensor. Setting it back to static/dynamic will set the initial sensor state.

 If you really want to delete the body use the appropriate method to do so. After deleting the body you will no longer be able to set it back again until you recreate the Cocos2d node.
 
 @param type A LH_PHYSICS_TYPE enum value. 0 = static, 1 = Kinematic (not available in Chipmunk), 2 = Dynamic, 3 = No Physics
 */
-(void)setPhysicsType:(int)type;

/**
 Removed the physics body from the node. The SpriteKit node will still be alive. If you want to remove the node also call "removeFromParent" instead.
 Note that you won't be able to recreate the body after removal without recreating the entire SpriteKit node. If you need the physics body at a later time you may want
 to change the physics type to No Physics.
*/
-(void)removeBody;

#if LH_USE_BOX2D
#ifdef __cplusplus

/**
 Returns the Box2d body created on this sprite or NULL if sprite has no physics.
 */
-(b2Body*)box2dBody;

/**
 Manually set a Box2d body created via code. Do not delete the body, or if you do delete it, call [node setBox2dBody:NULL];
 */
-(void)setBox2dBody:(b2Body*)b;

#endif
#endif //LH_USE_BOX2D


-(void)updatePosition:(CGPoint)pos;
-(void)updateZRotation:(float)rotation;

@end


@interface LHNodePhysicsProtocolImp : NSObject

+ (instancetype)physicsProtocolImpWithDictionary:(NSDictionary*)dict node:(SKNode*)nd scale:(CGPoint)scale;
- (instancetype)initPhysicsProtocolImpWithDictionary:(NSDictionary*)dict node:(SKNode*)nd scale:(CGPoint)scale;
- (instancetype)initPhysicsProtocolWithNode:(SKNode*)nd;

-(SKNode*)node;

-(int)bodyType;
-(void)setBodyType:(int)type;

-(void)removeBody;

#if LH_USE_BOX2D

#ifdef __cplusplus
-(b2Body*)body;
-(void)setBody:(b2Body*)b;
-(CGAffineTransform)nodeTransform;
-(CGAffineTransform)absoluteTransform;
-(void)updateTransform;
-(float)rotation;
-(void)updateScale;

+(b2Body*)LHGetBox2dBody:(SKNode*)_node_;

#endif

#endif //LH_USE_BOX2D

- (void)update:(NSTimeInterval)currentTime delta:(float)dt;
@end

#if LH_USE_BOX2D

#define LH_GET_BOX2D_BODY(A) [LHNodePhysicsProtocolImp LHGetBox2dBody:A];

#endif


#define LH_BOX2D_PHYSICS_PROTOCOL_METHODS_IMPLEMENTATION  \
-(b2Body*)box2dBody\
{\
    return [_physicsProtocolImp body];\
}\
-(void)setBox2dBody:(b2Body*)b\
{\
    [_physicsProtocolImp setBody:b];\
}\
-(void)setPosition:(CGPoint)position\
{\
    [super setPosition:position];\
    if([_physicsProtocolImp body]){\
        [_physicsProtocolImp updateTransform];\
    }\
    for(SKNode* child in [self children]){\
        [child setPosition:[child position]];\
    }\
}\
-(void)setZRotation:(CGFloat)rotation\
{\
    [super setZRotation:rotation];\
    if([_physicsProtocolImp body]){\
        [_physicsProtocolImp updateTransform];\
    }\
    for(SKNode* child in [self children]){\
        [child setZRotation:[child zRotation]];\
    }\
}\
-(void)setScale:(CGFloat)scale{\
    [super setScale:scale];\
    if([_physicsProtocolImp body]){\
        [_physicsProtocolImp updateScale];\
    }\
    for(SKNode* child in [self children]){\
        [child setXScale:[child xScale]];\
    }\
}\
-(void)setXScale:(CGFloat)scaleX{\
    [super setXScale:scaleX];\
    if([_physicsProtocolImp body]){\
        [_physicsProtocolImp updateScale];\
    }\
    for(SKNode* child in [self children]){\
        [child setXScale:[child xScale]];\
    }\
}\
-(void)setYScale:(CGFloat)scaleY{\
    [super setYScale:scaleY];\
    if([_physicsProtocolImp body]){\
        [_physicsProtocolImp updateScale];\
    }\
    for(SKNode* child in [self children]){\
        [child setYScale:[child yScale]];\
    }\
}


#define LH_COMMON_PHYSICS_PROTOCOL_METHODS_IMPLEMENTATION  \
-(int)physicsType{\
    return [_physicsProtocolImp bodyType];\
}\
-(void)setPhysicsType:(int)type{\
    [_physicsProtocolImp setBodyType:type];\
}\
-(void)removeBody{\
    [_physicsProtocolImp removeBody];\
}\
-(void)updatePosition:(CGPoint)position\
{\
    [super setPosition:position];\
}\
-(void)updateZRotation:(float)rotation\
{\
    [super setZRotation:rotation];\
}

