//
//  WZParallaxNode.h
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/11/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WZParallaxNode : SKSpriteNode

@property (nonatomic, readonly) CGFloat parallaxSpeedOffset;

- (instancetype)initWithSprites:(NSArray *)sprites speedOffset:(CGFloat)offset;
- (void)updateParallax;
@end
