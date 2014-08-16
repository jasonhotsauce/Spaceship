//
//  WZGameScence.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameScene.h"
#import "WZSpaceship.h"
#import "WZRock.h"
#import "WZSpawnAI.h"
#import <CoreMotion/CoreMotion.h>

static const CGPoint worldBackgroundCenter = (CGPoint){.x = 960, .y = 600};
static const CGSize worldTileSize = (CGSize){.width = 192, .height = 120};
static const CGSize worldSize = (CGSize){.width = 1920, .height = 1200};

@interface WZGameScene () <SKPhysicsContactDelegate>

@property BOOL hasCreatedContent;
@property (nonatomic, strong) SKNode *world;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic, strong) WZSpaceship *spaceship;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic, strong) NSMutableArray *activeRocks;
@property (nonatomic, strong) NSMutableArray *inactiveRocks;
@property (nonatomic, strong) WZSpawnAI *ai;
@end

@implementation WZGameScene

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
        _ai = [[WZSpawnAI alloc] initWithCharactor:nil target:nil];
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

- (void)generateRockAtPosition:(CGPoint)position
{
    WZRock *rock = [self.inactiveRocks lastObject];
    if (!rock) {
        rock = [[WZRock alloc] initWithPosition:position];
    }
    rock runAction:[]
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
    [self.ai updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)didSimulatePhysics
{

}

- (void)addNode:(SKNode *)node toWorldLayer:(WZGameWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[WZRock class]]) {
        [(WZRock *)node collidedWidth:contact.bodyB];
    }
    
    node = contact.bodyB.node;
    if ([node isKindOfClass:[WZGameCharactor class]]) {
        [(WZGameCharactor *)node collidedWidth:contact.bodyA];
    }
    
    
}

static NSArray *backgroundTiles = nil;
- (NSArray *)backgroundTiles
{
    return backgroundTiles;
}

@end
