//
//  WZEnemyCharactor.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/17/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZEnemyCharactor.h"
#import "WZGameScene.h"

@implementation WZEnemyCharactor

+ (void)loadSharedAssets
{
    explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"]];
}

- (void)destroyed
{
    //Apply rock explosion.
    [(WZGameScene *)self.scene addScoreToPlayer:self.enemyScore];
    [self performExplosion];
    [self removeFromParent];
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
}

static SKEmitterNode *explosion = nil;
- (SKEmitterNode *)explosion
{
    return explosion;
}
@end
