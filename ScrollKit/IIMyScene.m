//
//  IIMyScene.m
//  ScrollKit
//
//  Created by Fille Åström on 20/11/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

#import "IIMyScene.h"

@interface IIMyScene ()
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
@end

@implementation IIMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        spriteToScroll.anchorPoint = self.anchorPoint;
        [self addChild:spriteToScroll];

        SKSpriteNode *greenTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
                                                                 size:(CGSize){.width = size.width,
                                                                               .height = size.height*.25}];
        [greenTestSprite setName:@"greenTestSprite"];
        [greenTestSprite setAnchorPoint:(CGPoint){0,0}];
        [spriteToScroll addChild:greenTestSprite];

        SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                                    size:(CGSize){.width = size.width*.25,
                                                                        .height = size.height*.25}];
        [blueTestSprite setName:@"blueTestSprite"];
        [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
        [blueTestSprite setPosition:(CGPoint){.x = size.width * .25, .y = size.height *.65}];
        [spriteToScroll addChild:blueTestSprite];
        _contentSize = size;

        _spriteToScroll = spriteToScroll;
        [self setContentOffset:(CGPoint){0,0}];
    }
    return self;
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self setContentOffset:self.contentOffset];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    contentOffset.y += (self.size.height - self.contentSize.height);
    [self.spriteToScroll setPosition:contentOffset];
}

@end
