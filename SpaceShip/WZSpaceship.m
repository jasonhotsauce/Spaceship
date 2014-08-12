//
//  WZSpaceShip.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZSpaceship.h"
NSString *const WZSpaceshipNodeName = @"spaceship";
static const CGFloat kMinMovingSpeed = 5.0;

@implementation WZSpaceship

- (instancetype)initWithPosition:(CGPoint)position
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"Spaceship.png"];
    
    return [super initWithTexture:texture position:position];
}

- (void)configureGameCharactor
{
    self.health = 100;
    self.movingSpeed = kMinMovingSpeed;
    fireEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spaceship_fire" ofType:@"sks"]];
    SKEmitterNode *fire = [[self fireEmitter] copy];
    fire.position = CGPointMake(0, -80);
    fire.targetNode = self;
    [self addChild:fire];
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:WZGameCharactorCollisionRadius];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeSpaceship;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
    self.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
}

static SKEmitterNode *fireEmitter = nil;
- (SKEmitterNode *)fireEmitter
{
    return fireEmitter;
}
@end
