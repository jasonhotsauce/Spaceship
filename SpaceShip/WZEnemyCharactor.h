//
//  WZEnemyCharactor.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/17/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"

@interface WZEnemyCharactor : WZGameCharactor

@property (nonatomic) NSInteger enemyScore;

- (void)destroyed;

@end
