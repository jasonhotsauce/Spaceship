//
//  WZGameScence.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameScence.h"
#import "WZSpaceship.h"
#import <CoreMotion/CoreMotion.h>

static const CGPoint worldBackgroundCenter = (CGPoint){.x = 960, .y = 600};
static const CGSize worldTileSize = (CGSize){.width = 192, .height = 120};
static const CGSize worldSize = (CGSize){.width = 1920, .height = 1200};

@interface WZGameScence ()

@property BOOL hasCreatedContent;
@property (nonatomic, strong) SKNode *world;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) WZSpaceship *spaceship;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@end

@implementation WZGameScence

+ (void)loadSharedAssets
{
    SKTextureAtlas *tileAtlas = [SKTextureAtlas atlasNamed:@"galaxy"];
    backgroundTiles = [[NSMutableArray alloc] initWithCapacity:100];
    for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
            int tileNumber = (y * 10) + (x+1);
            NSLog(@"tileNumber: %d", tileNumber);
            SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithTexture:[tileAtlas textureNamed:[NSString stringWithFormat:@"galaxy_%d.png", tileNumber]]];
            CGPoint position = CGPointMake((x * 192) - worldBackgroundCenter.x, (worldSize.height - y*worldTileSize.height) - worldBackgroundCenter.y);
            tileNode.position = position;
            tileNode.blendMode = SKBlendModeReplace;
            [(NSMutableArray *)backgroundTiles addObject:tileNode];
        }
    }
    [WZSpaceship loadSharedAssets];
}

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

- (CMMotionManager *)motionManager
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
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
    [self.spaceship runAction:[SKAction moveToY:100 duration:0.5] completion:^{
        [weakSelf startGame];
    }];
    [self addNode:self.spaceship toWorldLayer:WZGameWorldLayerCharactors];
    
    for (SKSpriteNode *worldTile in backgroundTiles) {
        [self addNode:worldTile toWorldLayer:WZGameWorldLayerBackground];
    }
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
    self.gameStarted = YES;
    // enable motion manager
    self.motionManager.accelerometerUpdateInterval = 0.02f;
    [self.motionManager startAccelerometerUpdates];
}

- (void)endGame
{
    [self.motionManager stopAccelerometerUpdates];
    self.gameStarted = NO;
}

- (void)update:(NSTimeInterval)currentTime
{
    NSTimeInterval timeSinceLast = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0/60.0;
    }
    if ([self.spaceship shouldFireBullet:(NSTimeInterval)currentTime]) {
        [self.spaceship fire];
    }
    [self.spaceship updatePositionWithAcceleration:self.motionManager.accelerometerData.acceleration timeSinceLastUpdate:timeSinceLast];
}

- (void)addNode:(SKNode *)node toWorldLayer:(WZGameWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

static NSArray *backgroundTiles = nil;
- (NSArray *)backgroundTiles
{
    return backgroundTiles;
}

@end
