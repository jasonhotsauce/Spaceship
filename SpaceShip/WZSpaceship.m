//
//  WZSpaceShip.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZSpaceship.h"
#import "WZGameScene.h"

NSString *const WZSpaceshipNodeName = @"spaceship";
static const CGFloat kMinMovingSpeed = 100;
static const CGFloat WZMotionSensitivity = 6.0;
static const CGFloat WZMotionDecelerateSpeed = 0.4f;

@interface WZSpaceship ()
{
    CGPoint currentVelocity;
}

@property (nonatomic) NSTimeInterval fireTimeInterval;

@end

@implementation WZSpaceship

+ (void)loadSharedAssets
{
    fireEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spaceship_fire" ofType:@"sks"]];
    bulletEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spaceship_bullet" ofType:@"sks"]];
    explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"]];
    
    bulletNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(10.0, 24.0)];
    bulletNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    bulletNode.physicsBody.categoryBitMask = WZGameCharactorColliderTypeBullet;
    bulletNode.physicsBody.collisionBitMask = WZGameCharactorColliderTypeEnemyShip | WZGameCharactorColliderTypeRock;
    bulletNode.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip | WZGameCharactorColliderTypeSpaceship;
}

- (instancetype)initWithPosition:(CGPoint)position
{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"Spaceship.png"];
    
    return [super initWithTexture:texture position:position];
}

- (void)configureGameCharactor
{
//    self.health = 100;
    self.movingSpeed = kMinMovingSpeed;
    currentVelocity = CGPointZero;
    SKEmitterNode *fire = [[self fireEmitter] copy];
    fire.position = CGPointMake(0, -80);
    fire.targetNode = self.scene;
    [self addChild:fire];
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:WZGameCharactorCollisionRadius];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeSpaceship;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
    self.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeRock | WZGameCharactorColliderTypeEnemyShip;
}

- (BOOL)shouldFireBullet:(NSTimeInterval)currentTimeInterval
{
    BOOL shouldFire = NO;
    if (currentTimeInterval - self.fireTimeInterval >= 0.5 && !self.dying) {
        shouldFire = YES;
        self.fireTimeInterval = currentTimeInterval;
    }
    return shouldFire;
}

- (void)fire
{
    SKSpriteNode *bullet = [[self bulletNode] copy];
    SKEmitterNode *bulletEmitter = [[self bulletEmitter] copy];
    bulletEmitter.targetNode = [self.scene childNodeWithName:@"world"];
    CGPoint position = CGPointMake(self.position.x, self.position.y + self.size.height/2);
    bullet.position = position;
    [bullet runAction:[SKAction sequence:@[[SKAction moveToY:self.scene.size.height + 50 duration:1.5], [SKAction runBlock:^{
        [bullet removeFromParent];
    }]]]];
    [bullet addChild:bulletEmitter];
    [(WZGameScene *)self.scene addNode:bullet toWorldLayer:WZGameWorldLayerCharactors];
}

- (void)updatePositionWithAcceleration:(CMAcceleration)acceleration timeSinceLastUpdate:(NSTimeInterval)delta
{
    currentVelocity.x = currentVelocity.x * WZMotionDecelerateSpeed + acceleration.x * WZMotionSensitivity;
    if (currentVelocity.x > self.movingSpeed) {
        currentVelocity.x = self.movingSpeed;
    } else if (currentVelocity.x < -self.movingSpeed) {
        currentVelocity.x = -self.movingSpeed;
    }
    
    currentVelocity.y = currentVelocity.y * WZMotionDecelerateSpeed + acceleration.y * WZMotionSensitivity;
    if (currentVelocity.y > self.movingSpeed) {
        currentVelocity.y = self.movingSpeed;
    } else if (currentVelocity.y < -self.movingSpeed) {
        currentVelocity.y = -self.movingSpeed;
    }
    CGPoint newPosition = self.position;
    newPosition.x += currentVelocity.x;
    newPosition.y += currentVelocity.y;
    if (newPosition.x < self.size.width/2) {
        newPosition.x = self.size.width/2;
        currentVelocity.x = 0;
    } else if (newPosition.x > self.scene.size.width - self.size.width/2) {
        newPosition.x = self.scene.size.width - self.size.width/2;
        currentVelocity.x = 0;
    }
    
    if (newPosition.y < self.size.height/2) {
        newPosition.y = self.size.height/2;
        currentVelocity.y = 0;
    } else if (newPosition.y > self.scene.size.height - self.size.height/2) {
        newPosition.y = self.scene.size.height - self.size.height/2;
        currentVelocity.y = 0;
    }
    self.position = newPosition;
}

- (void)collidedWith:(SKPhysicsBody *)body
{
    if (body.categoryBitMask & (WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeEnemyShip | WZGameCharactorColliderTypeRock)) {
        [self performDeath];
    }
}

- (void)performDeath
{
    self.dying = YES;
    SKEmitterNode *explosionNode = [[self explosion] copy];
    explosionNode.position = self.position;
    explosionNode.targetNode = self.parent;
    [(WZGameScene *)self.scene addNode:explosionNode toWorldLayer:WZGameWorldLayerCharactors];
    __weak typeof(explosionNode) weakNode = explosionNode;
    [explosionNode runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5], [SKAction runBlock:^{
        [weakNode removeFromParent];
        [(WZGameScene *)self.scene endGame];
    }]]]];
}

static SKEmitterNode *fireEmitter = nil;
- (SKEmitterNode *)fireEmitter
{
    return fireEmitter;
}

static SKSpriteNode *bulletNode = nil;
- (SKSpriteNode *)bulletNode
{
    return bulletNode;
}

static SKEmitterNode *bulletEmitter = nil;
- (SKEmitterNode *)bulletEmitter
{
    return bulletEmitter;
}

static SKEmitterNode *explosion = nil;
- (SKEmitterNode *)explosion
{
    return explosion;
}
@end