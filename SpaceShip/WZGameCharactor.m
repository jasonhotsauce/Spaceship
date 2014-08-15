//
//  WZGameCharactors.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/8/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameCharactor.h"

const CGFloat WZGameCharactorCollisionRadius = 40;

@implementation WZGameCharactor

+ (void)loadSharedAssets
{
    // subclass override this.
}

- (instancetype)initWithTexture:(SKTexture *)texture position:(CGPoint)position
{
    if (self = [super initWithTexture:texture]) {
        self.position = position;
        [self configureGameCharactor];
        [self configurePhysicsBody];
    }
    return self;
}

- (void)configureGameCharactor
{
    // subclass should override this
}

- (void)configurePhysicsBody
{
    //subclass should override this
}

- (void)fire
{
    //subclass will override this. 
}

@end
