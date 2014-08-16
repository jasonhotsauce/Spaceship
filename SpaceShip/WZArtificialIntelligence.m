//
//  WZArtificialIntelligence.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/15/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZArtificialIntelligence.h"

@implementation WZArtificialIntelligence

- (instancetype)initWithCharactor:(SKNode *)charactor target:(WZGameCharactor *)target
{
    if (self = [super init]) {
        _charactor = charactor;
        _target = target;
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    // subclass should override this.
}

@end
