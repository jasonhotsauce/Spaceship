//
//  WZEnemyShip.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZEnemyCharactor.h"

typedef NS_ENUM(NSInteger, WZEnemyShipType) {
    WZEnemyShipTypeBasic = 1,
    WZEnemyShipTypeFighter
};

@class WZEnemyShipAI;

@interface WZEnemyShip : WZEnemyCharactor
@property (nonatomic, strong) WZEnemyShipAI *ai;
@property (nonatomic, readonly) WZEnemyShipType type;

- (instancetype)initWithEnemyShipType:(WZEnemyShipType)type atPosition:(CGPoint)position;
- (void)updateSinceLast:(NSTimeInterval)timeSinceLast;
- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval;
- (void)fireToPosition:(CGPoint)targetPosition;

@end
