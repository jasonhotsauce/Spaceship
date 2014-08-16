//
//  WZGameUtility.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameUtility.h"

@implementation WZGameUtility

+ (NSInteger)generateRandomNumberFrom:(NSInteger)numberA to:(NSInteger)numberB
{
    return numberA + arc4random() % numberB;
}

@end
