//
//  CBMyScene.h
//  CosmicBlast
//

//  Copyright (c) 2014 Teddy Kitchen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CBButtonBar.h"
#import"CBWorld.h"
#import"CBPlayer.h"
#import"CBHealthBar.h"

@interface CBMyScene : SKScene

@property (nonatomic) CBPlayer * player;
@property (nonatomic) CBWorld * currentWorld;
@property (nonatomic) NSMutableArray * factories;
@property (nonatomic) CBButtonBar * buttonBar;
@property(nonatomic)CBHealthBar * healthBar;


@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;





@end
