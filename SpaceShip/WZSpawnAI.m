//
//  WZSpawnAI.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/15/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZSpawnAI.h"
#import "WZGameScene.h"
#import "WZRock.h"
#import "WZGameUtility.h"

static const NSTimeInterval WZMinRockGenerationGap = 1;

@implementation WZSpawnAI

- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval
{
    // generate rock.
    if ([self.charactor isKindOfClass:[WZGameScene class]] && interval >= WZMinRockGenerationGap) {
        
        CGPoint rockPosition = CGPointMake([WZGameUtility generateRandomNumberFrom:0 to:ceilf(self.charactor.frame.size.width)], self.charactor.frame.size.height);
        [(WZGameScene *)self.charactor generateRockAtPosition:rockPosition];
    }
}
@end
