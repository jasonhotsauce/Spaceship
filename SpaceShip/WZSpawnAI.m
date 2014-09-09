//
//  WZSpawnAI.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/15/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZSpawnAI.h"
#import "WZGameScene.h"
#import "WZRock.h"
#import "WZGameUtility.h"

static const NSTimeInterval WZMinRockGenerationGap = 2;
static const NSTimeInterval WZMinShipGenerationGap = 4;
static const NSTimeInterval WZMaxRockPresentedTime = 3;

@interface WZSpawnAI ()

@property (nonatomic) NSTimeInterval timeUntilNextRockGeneration;
@property (nonatomic) NSTimeInterval timeUntilNextShipGeneration;
@end

@implementation WZSpawnAI

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    // generate rock.
    self.timeUntilNextRockGeneration += interval;
    self.timeUntilNextShipGeneration += interval;
    [self rollDiceToGenerateEnemies];
}

- (void)rollDiceToGenerateEnemies
{
    NSInteger ran = 1 + arc4random() % 6;
    if (ran % 2) {
        [self generateRocks];
    } else {
        [self generateEnemyShips];
    }
}

- (void)generateRocks
{
    if ([self.charactor isKindOfClass:[WZGameScene class]] && self.timeUntilNextRockGeneration >= WZMinRockGenerationGap) {
        
        CGPoint rockPosition = CGPointMake([WZGameUtility generateRandomNumberFrom:0 to:ceilf(self.charactor.frame.size.width)], self.charactor.frame.size.height);
        [(WZGameScene *)self.charactor generateRockAtPosition:rockPosition withSpeed:WZMaxRockPresentedTime];
        self.timeUntilNextRockGeneration = 0;
    }
}

- (void)generateEnemyShips
{
    if (self.totalEnemies < self.enemyShipsAllowed && self.timeUntilNextShipGeneration >= WZMinShipGenerationGap) {
        CGPoint enemyShipPosition = CGPointMake([WZGameUtility generateRandomNumberFrom:0 to:ceilf(self.charactor.frame.size.width)], self.charactor.frame.size.height - 50.0);
        [(WZGameScene *)self.charactor generateEnemyShipAtPosition:enemyShipPosition];
        self.totalEnemies++;
        self.timeUntilNextShipGeneration = 0;
    }
}
@end
