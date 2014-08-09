//
//  WZSpaceShip.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"

extern NSString *const WZSpaceshipNodeName;
@interface WZSpaceship : WZGameCharactor

@property (nonatomic, assign) NSInteger health;
@property (nonatomic, assign) CGFloat movingSpeed;

- (instancetype)initWithPosition:(CGPoint)position;
@end
