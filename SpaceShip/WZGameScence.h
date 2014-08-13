//
//  WZGameScence.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, WZGameWorldLayer) {
    WZGameWorldLayerBackground = 0,
    WZGameWorldLayerCharactors,
    WZGameWorldLayerStatusLabel,
    WZGameWorldLayerCount
};

@interface WZGameScence : SKScene
+ (void)loadSharedAssets;
@end
