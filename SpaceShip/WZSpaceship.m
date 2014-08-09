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

- (void)configureGameStatus
{
    self.health = 100;
    self.movingSpeed = kMinMovingSpeed;
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:WZGameCharactorCollisionRadius];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeSpaceship;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
    self.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
}
@end
