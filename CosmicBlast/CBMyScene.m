//
//  CBMyScene.m
//  CosmicBlast
//
//  Created by Teddy Kitchen on 7/23/14.
//  Copyright (c) 2014 Teddy Kitchen. All rights reserved.
//


@import CoreMotion;
#import "CBMyScene.h"
#import "CBEnemy.h"
#import "CBPlayer.h"
#import "CBEnemyFactory.h"
#import "CBButtonBar.h"


static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;




//Adds two vectors represented as points
static inline CGPoint cbVectorAdd(CGPoint a, CGPoint b ) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

//vector subtraction
static inline CGPoint cbVectorSub(CGPoint a, CGPoint b ) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

//Vector multiplication
static inline CGPoint cbVectorMult(CGPoint a, float b ) {
    return CGPointMake(a.x * b, a.y * b);
}


//Vector Length
static inline float cbVectorLength(CGPoint a){
    return sqrtf(a.x*a.x + a.y * a.y);
    

}

//Vector normalization (makes length = 1)
static inline CGPoint cbVectorNormalize(CGPoint a){
    float length = cbVectorLength(a);
    return CGPointMake(a.x / length, a.y/length);
}




@implementation CBMyScene


CMMotionManager *_motionManager;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        self.currentWorld = [CBWorld worldWithImageNamed:@"Background" position:CGPointZero];
        self.currentWorld.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild: self.currentWorld];
        
        
        self.player = [CBPlayer playerWithImageNamed:@"player"];
        self.player.position = CGPointMake(0, 0);
        [self.currentWorld addChild: self.player];
        
        self.factories = [[NSMutableArray alloc] init];
        
        
        _motionManager = [[CMMotionManager alloc] init];
        [self startMonitoringAcceleration];
        
        
        //set up button bar
        self.buttonBar = [CBButtonBar buttonBarWithFrame:self.frame];
        [self addChild:self.buttonBar];
        
        //Change this depending on levels
        [self placeFactoryAtPosition:CGPointMake(0, 0)];
        
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        
        
        
    }
    return self;
    
}

-(void)startMonitoringAcceleration{
    
    
    if(_motionManager.accelerometerAvailable){
        [_motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
    else{
        NSLog(@"motionManager.accelerometerAvailable is false");
    }
}


- (void)stopMonitoringAcceleration{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}


-(void)updatePositionFromMotionManager{
    
    CMAccelerometerData* data = _motionManager.accelerometerData;
    if(fabs(data.acceleration.x) > 0.2){
        NSLog(@"x acceleration value = %f", data.acceleration.x);
    }
    if(fabs(data.acceleration.y) > 0.2){
        NSLog(@"y acceleration value = %f", data.acceleration.y);
    }
    
    int speed = 2;
    
    [self.currentWorld moveCameraWithAccelerationXValue:data.acceleration.x yValue:data.acceleration.y speed:speed];
    [self.player movePlayerWithAccelerationXvalue:data.acceleration.x yValue:data.acceleration.y speed:speed];
    
    
    
}




//Fix hardcoding.  need to figur out world configuration
-(void)placeFactoryAtPosition:(CGPoint)position{
    CBEnemyFactory * factory = [CBEnemyFactory enemyFactoryWithColor:[SKColor blackColor] size:CGSizeMake(30,30)];
    
    [factory setPosition:position];
    [self.currentWorld addChild:factory];
    [self.factories addObject:factory];
    
    
    
}


//This belongs in another class
-(void)addMonster {
    //Create Sprite
    for (CBEnemyFactory *factory in self.factories) {
        
    
        CBWalker * monster = [factory createWalker];
    
    
        //Set up monster physics body (may want to make a class to do this later)
        monster.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monster.size];
        monster.physicsBody.dynamic = YES;
        monster.physicsBody.categoryBitMask = monsterCategory;
        monster.physicsBody.contactTestBitMask = projectileCategory;
        monster.physicsBody.collisionBitMask = 0;
        [self.currentWorld addChild:monster];
    
        int minDuration = 2.0;
        int maxDuration = 4.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
        //Create the actions
        
        int randx = arc4random_uniform(self.currentWorld.size.width)-self.currentWorld.size.width/2;
        int randy = arc4random_uniform(self.currentWorld.size.height)-self.currentWorld.size.height/2;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(randx,randy) duration:actualDuration];
    
        SKAction * actionMoveDone = [SKAction removeFromParent];
    
        [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    }
    
}

-(void)updateWithTimeSinceLastUpdate: (CFTimeInterval) timeSinceLast{
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        
        //uncomment to enable monsters
        [self addMonster];
    }
    [self updatePositionFromMotionManager];
    
    
}

-(void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
        
        
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&(secondBody.categoryBitMask & monsterCategory) != 0){
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
    
}





-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    //  This is going to need to be changed.  Will need to split behavior of different items up somehow
    //
    
    //chose a touch to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.currentWorld];
    
    //set up initial location
    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
    projectile.position = self.player.position;
    
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = monsterCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    
    
    //configure offset
    CGPoint offset = cbVectorSub(location,projectile.position);
    
    //discount invalid clicks
    //if (offset.x <= 0) return;
    
    //Add the projectile
    [self.currentWorld addChild:projectile];
    
    //Get shooting direction
    CGPoint direction = cbVectorNormalize(offset);
    
    //Create shot vector
    CGPoint shotVector = cbVectorMult(direction, 1000);  //THIS SEEMS A LITTLE STUPID
    
    //Add shot vector to current position
    CGPoint realDest = cbVectorAdd(shotVector, projectile.position);
    
    
    //Create actions
    float velocity = 480.0; 
    float realMoveDuration = self.size.width / velocity;
    
    SKAction * actionMove = [SKAction moveTo:realDest duration: realMoveDuration];
    
    SKAction * actionMoveDone = [SKAction removeFromParent];
    
    
    
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}



//belongs in another class
-(void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    NSLog(@"hit");
    [projectile removeFromParent];
    [monster removeFromParent];
    
}

//up button
- (SKSpriteNode *)upButtonNode{
    SKSpriteNode * upNode = [SKSpriteNode spriteNodeWithImageNamed:@"up.png"];
    upNode.position = CGPointMake(0,200);
    upNode.name = @"upButtonNode";
    upNode.zPosition = 1.0;
    return upNode;
    
}






@end
