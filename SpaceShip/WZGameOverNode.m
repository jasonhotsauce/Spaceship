//
//  WZGameOverNode.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/17/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZGameOverNode.h"

@interface WZGameOverNode ()

@property (nonatomic, strong) SKLabelNode *summaryNode;
@property (nonatomic, strong) SKLabelNode *restartButton;
@property (nonatomic, strong) SKLabelNode *sharedToFacebook;

@end

@implementation WZGameOverNode

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size]) {
        _summaryNode = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        _summaryNode.fontColor = [SKColor blueColor];
        _summaryNode.fontSize = 37.0;
        _summaryNode.text = @"0";
        _summaryNode.position = CGPointMake(0, 20);
        [self addChild:_summaryNode];
        
        _restartButton = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        _restartButton.fontSize = 20.0;
        _restartButton.fontColor = [SKColor blueColor];
        _restartButton.text = @"Restart";
        _restartButton.position = CGPointMake(-100, -50);
        [self addChild:_restartButton];
    }
    return self;
}

- (void)setTotalScore:(NSInteger)totalScore
{
    _totalScore = totalScore;
    self.summaryNode.text = [NSString stringWithFormat:@"%ld", (long)totalScore];
}

@end
