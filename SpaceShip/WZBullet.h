//
//  WZBullet.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/15/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"

@interface WZBullet : WZGameCharactor

@property (nonatomic, weak)WZGameCharactor *host;
@property (nonatomic) CGFloat movingSpeed;

@end
