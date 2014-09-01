//
//  WZRock.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZRock.h"
#import "WZBullet.h"
#import "WZSpaceship.h"
#import "WZSpawnAI.h"
#import "WZGameScene.h"

@implementation WZRock

- (instancetype)initWithPosition:(CGPoint)position
{
    SKTexture *rockTexture = [SKTexture textureWithImageNamed:@"rock.png"];
    self = [super initWithTexture:rockTexture position:position];
    if (self) {
        self.enemyScore = 5;
    }
    return self;
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.width/2];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeRock;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeSpaceship | WZGameCharactorColliderTypeBullet;
}

- (void)collidedWith:(SKPhysicsBody *)bodyB
{
    SKNode *node = bodyB.node;
    if (bodyB.categoryBitMask & WZGameCharactorColliderTypeBullet) {
        [self destroyed];
        [node removeFromParent];
    } else if (bodyB.categoryBitMask & WZGameCharactorColliderTypeSpaceship) {
        [(WZSpaceship *)node collidedWith:self.physicsBody];
        [self performExplosion];
        [self removeFromParent];
    }
}

@end
