//
//  IIMyScene.m
//  ScrollKit
//
//  Created by Fille Åström on 20/11/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

#import "IIMyScene.h"

@implementation IIMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        _spriteToScroll = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:size];
        _spriteToScroll.anchorPoint = CGPointMake(0, 0);
        [self addChild:_spriteToScroll];
    }
    return self;
}

@end
