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
@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;
@end

@implementation IIMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        [self setAnchorPoint:(CGPoint){0,1}];
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [self addChild:spriteToScroll];

        //Overlay sprite to make anchor point 0,0 (lower left, default for SK)
        SKSpriteNode *spriteForGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteToScroll addChild:spriteForGeometry];

        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [self addChild:spriteForStaticGeometry];
        _spriteForStaticGeometry = spriteForStaticGeometry;

        SKLabelNode *stationaryLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        [stationaryLabel setText:@"I'm not gonna move, nope, nope."];
        [stationaryLabel setFontSize:14.0];
        [stationaryLabel setFontColor:[SKColor darkGrayColor]];
        [stationaryLabel setPosition:(CGPoint){.x = 10.0, .y = 30.0}];
        [stationaryLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
        [spriteForStaticGeometry addChild:stationaryLabel];

        SKSpriteNode *greenTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
                                                                 size:(CGSize){.width = size.width,
                                                                               .height = size.height*.25}];
        [greenTestSprite setName:@"greenTestSprite"];
        [greenTestSprite setAnchorPoint:(CGPoint){0,0}];
        [spriteForGeometry addChild:greenTestSprite];

        SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                                    size:(CGSize){.width = size.width*.25,
                                                                        .height = size.height*.25}];
        [blueTestSprite setName:@"blueTestSprite"];
        [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
        [blueTestSprite setPosition:(CGPoint){.x = size.width * .25, .y = size.height *.65}];
        [spriteForGeometry addChild:blueTestSprite];
        _contentSize = size;

        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForGeometry;

        [self setContentOffset:(CGPoint){0,0}];
    }
    return self;
}

-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];
    [self.spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];
        [self setContentOffset:self.contentOffset];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];
}

-(void)setContentScale:(CGFloat)scale;
{
    [self.spriteToScroll setScale:scale];
}

@end
