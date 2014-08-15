//
//  WZRock.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZRock.h"

@implementation WZRock

- (instancetype)initWithPosition:(CGPoint)position
{
    SKTexture *rockTexture = [SKTexture textureWithImageNamed:@"rock.png"];
    return [super initWithTexture:rockTexture position:position];
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeRock;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeSpaceship | WZGameCharactorColliderTypeBullet;
}

- (void)collidedWidth:(SKPhysicsBody *)bodyB
{

}

@end
