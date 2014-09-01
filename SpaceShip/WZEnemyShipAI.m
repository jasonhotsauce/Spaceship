//
//  WZEnemyShipAI.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/19/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZEnemyShipAI.h"
#import "WZSpaceship.h"
#import "WZEnemyShip.h"

@interface WZEnemyShipAI()

@property (nonatomic) NSTimeInterval timeUntilNextFire;

@end

@implementation WZEnemyShipAI

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    WZEnemyShip *enemyShip = (WZEnemyShip *)self.charactor;
    
    if (enemyShip.dying) {
        self.target = nil;
        return;
    }
    
    if (!self.target) {
        return;
    }
    
    WZSpaceship *spaceShip = (WZSpaceship *)self.target;
    
    if (spaceShip.dying) {
        self.target = nil;
        return;
    }
    
    CGPoint spaceShipPosition = spaceShip.position;
    [enemyShip moveTowards:spaceShipPosition withTimeInterval:interval];
    
    if (self.timeUntilNextFire > 0.5 ) {
        [enemyShip fireToPosition:spaceShipPosition];
        self.timeUntilNextFire = 0;
    } else {
        self.timeUntilNextFire += interval;
    }
}

@end
