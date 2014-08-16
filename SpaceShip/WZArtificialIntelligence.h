//
//  WZArtificialIntelligence.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/15/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class WZGameCharactor;
@interface WZArtificialIntelligence : NSObject

@property (nonatomic, weak) SKNode *charactor;
@property (nonatomic, weak) WZGameCharactor *target;

- (instancetype)initWithCharactor:(SKNode *)charactor target:(WZGameCharactor *)target;
- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)interval;

@end
