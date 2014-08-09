//
//  WZMainMenuScence.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZMainMenuScence.h"
#import "WZGameScence.h"

static NSString *const WZMainMenuStartButtonName = @"startButton";
@interface WZMainMenuScence ()

@property (nonatomic, assign) BOOL hasCreatedContent;
@end

@implementation WZMainMenuScence

- (void)didMoveToView:(SKView *)view
{
    if (!self.hasCreatedContent) {
        [self configureScence];
        self.hasCreatedContent = YES;
    }
}

- (void)configureScence
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self titleNode]];
    [self addChild:[self startButton]];
}

- (SKLabelNode *)titleNode
{
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text = @"Spaceship Shooting";
    labelNode.fontSize = 24;
    labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 44);
    return labelNode;
}

- (SKLabelNode *)startButton
{
    SKLabelNode *startButton = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    startButton.name = WZMainMenuStartButtonName;
    startButton.text = @"Play";
    startButton.fontSize = 24;
    startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 44);
    SKAction *actions = [SKAction sequence:@[
                                                [SKAction moveToY:CGRectGetMinY(self.frame) + 64 duration:0.3],
                                                [SKAction moveToY:CGRectGetMinY(self.frame) + 44 duration:0.3]]];
    [startButton runAction:[SKAction repeatActionForever:actions]];
    return startButton;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    SKNode *tappedNode = [self nodeAtPoint:[touch locationInNode:self]];
    if ([tappedNode.name isEqualToString:WZMainMenuStartButtonName]) {
        [self transistToGameScence];
    }
}

- (void)transistToGameScence
{
    WZGameScence *gameScence = [[WZGameScence alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:gameScence transition:transition];
}
@end
