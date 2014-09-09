//
//  WZEnemyShip.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/14/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZEnemyShip.h"
#import "WZEnemyShipAI.h"
#import "WZGameScene.h"
#import "WZSpaceship.h"
#import "WZGameUtility.h"

@interface WZEnemyShip ()

@property (nonatomic) CGFloat movingSpeed;
@property (nonatomic, readwrite) WZEnemyShipType type;

@end

@implementation WZEnemyShip

+ (void)loadSharedAssets
{
    explosionEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"]];
    bulletEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"enemy_bullet" ofType:@"sks"]];
    
    bullet = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(20, 20)];
    bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
    bullet.physicsBody.categoryBitMask = WZGameCharactorColliderTypeBullet;
    bullet.physicsBody.collisionBitMask = WZGameCharactorColliderTypeSpaceship;
    bullet.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeSpaceship;
    bullet.name = @"enemy_bullet";
}

+ (SKTexture *)getTextureForType:(WZEnemyShipType)type
{
    switch (type) {
        case WZEnemyShipTypeBasic:
            return [SKTexture textureWithImageNamed:@"enemyship.png"];
            
        default:
            break;
    }
    return nil;
}

+ (UIColor *)colorForType:(WZEnemyShipType)type
{
    switch (type) {
        case WZEnemyShipTypeBasic:
            return [UIColor greenColor];
            
        case WZEnemyShipTypeFighter:
            return [UIColor orangeColor];
            
        default:
            break;
    }
    return nil;
}

- (instancetype)initWithEnemyShipType:(WZEnemyShipType)type atPosition:(CGPoint)position
{
//    SKTexture *texture = [WZEnemyShip getTextureForType:type];
//    _type = type;
//    self = [super initWithTexture:texture position:position];
//    return self;
    _type = type;
    self = [super initWithColor:[WZEnemyShip colorForType:type] size:CGSizeMake(50, 50)];
    self.position = position;
    [self configureGameCharactor];
    [self configurePhysicsBody];
    return self;
}

- (void)configurePhysicsBody
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = WZGameCharactorColliderTypeEnemyShip;
    self.physicsBody.collisionBitMask = WZGameCharactorColliderTypeBullet | WZGameCharactorColliderTypeSpaceship;
    self.physicsBody.contactTestBitMask = WZGameCharactorColliderTypeSpaceship | WZGameCharactorColliderTypeBullet;
}

- (void)configureGameCharactor
{
    self.movingSpeed = self.type * 500;
    self.enemyScore = self.type * 50;
}

- (void)updateSinceLast:(NSTimeInterval)timeSinceLast
{
    [self.ai updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)collidedWith:(SKPhysicsBody *)body
{
    SKNode *node = body.node;
    if (body.categoryBitMask & WZGameCharactorColliderTypeBullet) {
        [self destroyed];
    } else if (body.categoryBitMask & WZGameCharactorColliderTypeSpaceship) {
        [(WZSpaceship *)node collidedWith:self.physicsBody];
        [self performExplosion];
        [self removeFromParent];
    }
}

- (void)destroyed
{
    [(WZGameScene *)self.scene enemyShipDestroyed:self];

    [super destroyed];
}

- (void)moveTowards:(CGPoint)position withTimeInterval:(NSTimeInterval)timeInterval
{
    CGPoint curPosition = self.position;
    CGFloat dx = position.x - curPosition.x;
    CGFloat dy = position.y - curPosition.y;
    CGFloat dt = self.movingSpeed * timeInterval;
    
    CGFloat ang = M_PI_2 + [WZGameUtility radiusBetweenPoint:curPosition toPoint:position];
    self.zRotation = ang;
    
    CGFloat distRemaining = hypotf(dx, dy);
    if (distRemaining < dt) {
        self.position = position;
    } else {
        self.position = CGPointMake(curPosition.x + sinf(ang)*dt,
                                    curPosition.y - cosf(ang)*dt);
    }
}

- (void)fireToPosition:(CGPoint)targetPosition
{
    SKSpriteNode *bullet = [[self bullet] copy];
    SKEmitterNode *bulletEmitter = [[self bulletEmitter] copy];
    bulletEmitter.emissionAngle = self.zRotation+M_PI_2;
    bulletEmitter.targetNode = [self.scene childNodeWithName:@"world"];
    CGPoint position = CGPointMake(self.position.x, self.position.y - self.size.height/2);
    bullet.position = position;
    [bullet runAction:[SKAction sequence:@[[SKAction moveTo:targetPosition duration:1.5], [SKAction runBlock:^{
        [bullet removeFromParent];
    }]]]];
    [bullet addChild:bulletEmitter];
    [(WZGameScene *)self.scene addNode:bullet toWorldLayer:WZGameWorldLayerCharactors];
}

static SKEmitterNode *explosionEmitter = nil;
- (SKEmitterNode *)explosionEmitter
{
    return explosionEmitter;
}

static SKEmitterNode *bulletEmitter = nil;
- (SKEmitterNode *)bulletEmitter
{
    return bulletEmitter;
}

static SKSpriteNode *bullet = nil;
- (SKSpriteNode *)bullet
{
    return bullet;
}
@end
