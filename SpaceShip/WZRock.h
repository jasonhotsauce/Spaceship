//
//  WZRock.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZEnemyCharactor.h"

@interface WZRock : WZEnemyCharactor

- (instancetype)initWithPosition:(CGPoint)position;
- (void)collidedWith:(SKPhysicsBody *)bodyB;

@end
