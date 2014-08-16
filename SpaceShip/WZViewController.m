//
//  WZViewController.m
//  SpaceShip
//
//  Created by Wenbin Zhang on 8/6/14.
//  Copyright (c) 2014 Wenbin Zhang. All rights reserved.
//

#import "WZViewController.h"
#import "WZMainMenuScene.h"

@implementation WZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [WZMainMenuScene loadSharedAssetsWithCompletion:^{
        NSLog(@"Loaded share assets");
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.bounds)*scale, CGRectGetHeight(self.view.bounds)*scale);
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [WZMainMenuScene sceneWithSize:viewSize];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
