//
//  WZRock.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"

@interface WZRock : WZGameCharactor

- (instancetype)initWithPosition:(CGPoint)position;
- (void)collidedWidth:(SKPhysicsBody *)bodyB;

@end
