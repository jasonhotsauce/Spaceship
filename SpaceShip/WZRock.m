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

@implementation WZRock

- (instancetype)initWithPosition:(CGPoint)position
{
    SKTexture *rockTexture = [SKTexture textureWithImageNamed:@"rock.png"];
    self = [super initWithTexture:rockTexture position:position];
    return self;
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeRock;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeSpaceship | WZGameCharactorColliderTypeBullet;
}

- (void)collidedWidth:(SKPhysicsBody *)bodyB
{
    SKNode *node = bodyB.node;
    if (bodyB.categoryBitMask & WZGameCharactorColliderTypeBullet) {
        [self explode];
        [node removeFromParent];
    }
    if ([node isKindOfClass:[WZSpaceship class]]) {
        [(WZSpaceship *)node collidedWidth:node.physicsBody];
        [self explode];
    }
}

- (void)explode
{
    //Apply rock explosion.
}

@end
