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
#import "WZGameOverNode.h"
#import "WZEnemyShip.h"
#import "WZEnemyShipAI.h"
#import <CoreMotion/CoreMotion.h>

static const CGSize worldTileSize = (CGSize){.width = 192, .height = 120};
static const CGSize worldSize = (CGSize){.width = 1920, .height = 1200};

@interface WZGameScene () <SKPhysicsContactDelegate>

@property BOOL hasCreatedContent;
@property (nonatomic, strong) SKNode *world;
@property (nonatomic, strong) NSMutableArray *layers;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic, strong) NSMutableArray *activeRocks;
@property (nonatomic, strong) NSMutableSet *inactiveRocks;
@property (nonatomic, strong) NSMutableArray *activeShips;
@property (nonatomic, strong) WZSpawnAI *ai;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property double score;
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
            CGPoint position = CGPointMake((x * 192), worldSize.height - y*worldTileSize.height);
            NSLog(@"position: %.2f - %.2f", position.x, position.y);
            tileNode.position = position;
            tileNode.blendMode = SKBlendModeReplace;
            [(NSMutableArray *)backgroundTiles addObject:tileNode];
        }
    }
    [WZSpaceship loadSharedAssets];
    [WZRock loadSharedAssets];
    [WZEnemyShip loadSharedAssets];
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _layers = [[NSMutableArray alloc] initWithCapacity:WZGameWorldLayerCount];
        _world = [[SKNode alloc] init];
        [self addChild:_world];
        [self configureWorldLayer];
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        _ai = [[WZSpawnAI alloc] initWithCharactor:self target:nil];
        _ai.enemyShipsAllowed = 1;
        _activeRocks = [[NSMutableArray alloc] init];
        _inactiveRocks = [[NSMutableSet alloc] init];
        _activeShips = [[NSMutableArray alloc] init];
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
    
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    self.scoreLabel.fontColor = [SKColor whiteColor];
    self.scoreLabel.fontSize = 37.0;
    self.scoreLabel.position = CGPointMake(20,self.size.height - 60);
    self.scoreLabel.text = @"0";
    self.scoreLabel.name = @"score";
    [self addNode:self.scoreLabel toWorldLayer:WZGameWorldLayerStatusLabel];
    
    [self addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
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
    [self addGameOverNode];
    [self.spaceship removeFromParent];
}

- (void)addGameOverNode
{
    WZGameOverNode *gameOver = [[WZGameOverNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(400, 200)];
    gameOver.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    gameOver.totalScore = [self.scoreLabel.text integerValue];
    [self addNode:gameOver toWorldLayer:WZGameWorldLayerStatusLabel];
}

- (void)generateRockAtPosition:(CGPoint)position withSpeed:(NSTimeInterval)movingSpeed
{
    WZRock *rock = [self dequeueRock];
    if (!rock) {
        rock = [[WZRock alloc] initWithPosition:position];
    }
    SKAction *rotateRock = [SKAction rotateByAngle:M_PI*2 duration:2];
    SKAction *repeatRotation = [SKAction repeatActionForever:rotateRock];
    [rock runAction:[SKAction group:@[repeatRotation, [SKAction moveToY:-100 duration:movingSpeed]]]];
    [self addChild:rock];
}

- (void)generateEnemyShipAtPosition:(CGPoint)position
{
    WZEnemyShip *enemyShip = [[WZEnemyShip alloc] initWithEnemyShipType:WZEnemyShipTypeBasic atPosition:position];
    enemyShip.ai = [[WZEnemyShipAI alloc] initWithCharactor:enemyShip target:self.spaceship];
    [enemyShip runAction:[SKAction moveToY:self.frame.size.height - 50 duration:0.5]];
    [self.activeShips addObject:enemyShip];
    [self addNode:enemyShip toWorldLayer:WZGameWorldLayerCharactors];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.gameStarted) {
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
        for (WZEnemyShip *enemyShip in self.activeShips) {
            [enemyShip updateSinceLast:timeSinceLast];
        }

    }
}

- (void)didSimulatePhysics
{
    if (self.gameStarted) {
        [self enqueueRock];
    }
}

- (void)enqueueRock
{
    for (WZRock *rock in self.activeRocks) {
        if (rock.position.y <= -100) {
            [self.inactiveRocks addObject:rock];
            [rock removeFromParent];
        }
    }
    [self.activeRocks removeObjectsInArray:[self.inactiveRocks allObjects]];
}

- (WZRock *)dequeueRock
{
    WZRock *rock = [self.inactiveRocks anyObject];
    if (rock) {
        [self.inactiveRocks removeObject:rock];
    }
    return rock;
}

- (void)addNode:(SKNode *)node toWorldLayer:(WZGameWorldLayer)layer
{
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)addScoreToPlayer:(long)earnedScore
{
    self.score += earnedScore;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
}

- (void)enemyShipDestroyed:(WZEnemyShip *)enemyShip
{
    [self.activeShips removeObject:enemyShip];
    self.ai.totalEnemies = MAX(0, self.ai.totalEnemies-1);
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *node = contact.bodyA.node;
    if ([node isKindOfClass:[WZRock class]]) {
        [(WZRock *)node collidedWith:contact.bodyB];
        return;
    }
    
    if ([node isKindOfClass:[WZEnemyShip class]]) {
        [(WZEnemyShip *)node collidedWith:contact.bodyB];
        return;
    }
    
    if ([node isKindOfClass:[WZSpaceship class]]) {
        [(WZSpaceship *)node collidedWith:contact.bodyB];
        return;
    }
    
    
    node = contact.bodyB.node;
    if ([node isKindOfClass:[WZGameCharactor class]]) {
        [(WZGameCharactor *)node collidedWith:contact.bodyA];
    }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"score"]) {
        double newScore = [change[NSKeyValueChangeNewKey] doubleValue];
        if (newScore > 2000) {
            
        }
    }
}

static NSArray *backgroundTiles = nil;
- (NSArray *)backgroundTiles
{
    return backgroundTiles;
}

@end
