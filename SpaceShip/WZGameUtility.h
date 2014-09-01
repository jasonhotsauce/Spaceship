//
//  WZGameUtility.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZGameUtility : NSObject

+ (NSInteger)generateRandomNumberFrom:(NSInteger)numberA to:(NSInteger)numberB;
+ (CGFloat)radiusBetweenPoint:(CGPoint)pointA toPoint:(CGPoint)pointB;
@end
