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
    _scene.scaleMode = SKSceneScaleModeFill;
    
    // Present the scene.
    [skView presentScene:_scene];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:skView.frame];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(skView.frame.size.width, skView.frame.size.height * 1.5);
    scrollView.hidden = YES;
    [skView addSubview:scrollView];
    [skView addGestureRecognizer:scrollView.panGestureRecognizer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint position = _scene.spriteToScroll.position;
    position.y = scrollView.contentOffset.y;
    position.x = scrollView.contentOffset.x;
    _scene.spriteToScroll.position = position;
}

@end
