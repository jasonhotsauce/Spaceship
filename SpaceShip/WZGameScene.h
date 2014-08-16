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

@interface WZGameScene : SKScene
+ (void)loadSharedAssets;
- (void)generateRockAtPosition:(CGPoint)position withSpeed:(NSTimeInterval)movingSpeed;
- (void)addNode:(SKNode *)node toWorldLayer:(WZGameWorldLayer)layer;

@end
