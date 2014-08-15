//
//  WZGameCharactors.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSInteger, WZGameCharactorColliderType) {
    WZGameCharactorColliderTypeSpaceship = 1 << 0,
    WZGameCharactorColliderTypeRock = 1 << 1,
    WZGameCharactorColliderTypeBullet = 1 << 2,
    WZGameCharactorColliderTypeEnemyShip = 1 << 3
};

extern const CGFloat WZGameCharactorCollisionRadius;

@interface WZGameCharactor : SKSpriteNode

- (instancetype)initWithTexture:(SKTexture *)texture position:(CGPoint)position;
- (void)configureGameCharactor;
- (void)configurePhysicsBody;
- (void)fire;
+ (void)loadSharedAssets;
- (void)collidedWidth:(SKPhysicsBody *)body;
@end
