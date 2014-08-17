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

+ (void)loadSharedAssets
{
    explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"]];
}

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
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeRock;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeSpaceship | WZGameCharactorColliderTypeBullet;
}

- (void)collidedWith:(SKPhysicsBody *)bodyB
{
    SKNode *node = bodyB.node;
    if (bodyB.categoryBitMask & WZGameCharactorColliderTypeBullet) {
        [self destroyed];
        [node removeFromParent];
    }
    if ([node isKindOfClass:[WZSpaceship class]]) {
        [(WZSpaceship *)node collidedWith:node.physicsBody];
        [self performExplosion];
    }
}

- (void)destroyed
{
    //Apply rock explosion.
    [(WZGameScene *)self.scene addScoreToPlayer:self.enemyScore];
    [self performExplosion];
}

- (void)performExplosion
{
    SKEmitterNode *explosionNode = [[self explosion] copy];
    explosionNode.position = self.position;
    explosionNode.targetNode = self.parent;
    __weak typeof(explosionNode) weakNode = explosionNode;
    [explosionNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5], [SKAction runBlock:^{
        [weakNode removeFromParent];
    }]]]];
    [(WZGameScene *)self.scene addNode:explosionNode toWorldLayer:WZGameWorldLayerCharactors];
    [self removeFromParent];
}

static SKEmitterNode *explosion = nil;
- (SKEmitterNode *)explosion
{
    return explosion;
}
@end
