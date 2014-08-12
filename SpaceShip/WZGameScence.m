//
//  WZGameScence.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameScence.h"
#import "WZSpaceship.h"

@interface WZGameScence ()

@property BOOL hasCreatedContent;
@property (nonatomic, strong) SKNode *world;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) WZSpaceship *spaceship;
@end

@implementation WZGameScence

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _layers = [[NSMutableArray alloc] initWithCapacity:WZGameWorldLayerCount];
        _world = [[SKNode alloc] init];
        [self addChild:_world];
        [self configureWorldLayer];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.hasCreatedContent) {
        [self configureScence];
        self.hasCreatedContent = YES;
    }
}

- (void)configureScence
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.spaceship = [[WZSpaceship alloc] initWithPosition:CGPointMake(self.size.width/2, -10)];
    __weak typeof(self) weakSelf = self;
//    [self.spaceship runAction:[SKAction moveToY:100 duration:0.5] completion:^{
//        [weakSelf startGame];
//    }];
    [self.spaceship runAction:[SKAction sequence:@[[SKAction moveToY:500 duration:1], [SKAction moveToX:100 duration:2], [SKAction rotateByAngle:45 duration:0.3]]]];
    [self addNode:self.spaceship toWorldLayer:WZGameWorldLayerCharactors];
}

- (void)configureWorldLayer
{
    for (NSInteger i = 0; i < WZGameWorldLayerCount; i++) {
        SKNode *layerNode = [[SKNode alloc] init];
        layerNode.zPosition = i - WZGameWorldLayerCount;
        [self.world addChild:layerNode];
        [self.layers addObject:layerNode];
    }
}

- (void)startGame
{

}

- (void)addNode:(SKNode *)node toWorldLayer:(WZGameWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

@end
