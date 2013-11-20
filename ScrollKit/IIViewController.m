//
//  IIViewController.m
//  ScrollKit
//
//  Created by Fille Åström on 20/11/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

#import "IIViewController.h"
#import "IIMyScene.h"

@implementation IIViewController {
    IIMyScene *_scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [IIMyScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:_scene];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:skView.frame];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(skView.frame.size.width, skView.frame.size.height * 2);
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.alpha = 0.5;
    [skView addSubview:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint position = _scene.spriteToScroll.position;
    position.y = scrollView.contentOffset.y;
    _scene.spriteToScroll.position = position;
}

@end
