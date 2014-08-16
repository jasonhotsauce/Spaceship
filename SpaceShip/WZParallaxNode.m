//
//  WZParallaxNode.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/11/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZParallaxNode.h"

@interface WZParallaxNode ()

@property (nonatomic, assign) CGFloat parallaxSpeedOffset;
@end

@implementation WZParallaxNode

- (instancetype)initWithSprites:(NSArray *)sprites speedOffset:(CGFloat)offset
{
    if (self = [super init]) {
        _parallaxSpeedOffset = offset;
        CGFloat zOffset = 1.0f / sprites.count;
        CGFloat selfZPosition = self.zPosition;
        NSInteger index = 0;
        for (SKNode *node in sprites) {
            node.zPosition = selfZPosition + (zOffset + zOffset*index);
            [self addChild:node];
            index++;
        }
    }
    return self;
}

- (void)updateParallax
{
    SKScene *scence = self.scene;
    SKNode *parent = self.parent;
    
    CGPoint pointInScence = [scence convertPoint:self.position fromNode:parent];
    CGFloat offsetY = -1.0 + 2.0 * pointInScence.y / scence.size.height;
    CGFloat delta = self.parallaxSpeedOffset / self.children.count;
    NSInteger index = 0;
    for (SKNode *node in self.children) {
        node.position = CGPointMake(node.position.x, offsetY * delta * index);
        index++;
    }
}

@end
