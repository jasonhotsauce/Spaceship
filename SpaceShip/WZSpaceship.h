//
//  WZSpaceShip.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"
#import <CoreMotion/CoreMotion.h>

extern NSString *const WZSpaceshipNodeName;
@interface WZSpaceship : WZGameCharactor

@property (nonatomic, assign) CGFloat movingSpeed;

- (instancetype)initWithPosition:(CGPoint)position;
- (BOOL)shouldFireBullet:(NSTimeInterval)currentTimeInterval;
+ (void)loadSharedAssets;
- (void)updatePositionWithAcceleration:(CMAcceleration)acceleration timeSinceLastUpdate:(NSTimeInterval)delta;
@end
