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
        /* Setup your scene here */
        
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:size];
        spriteToScroll.anchorPoint = self.anchorPoint;
        [self addChild:spriteToScroll];

        SKSpriteNode *greenTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
                                                                 size:(CGSize){.width = size.width,
                                                                               .height = size.height*.65}];
        _contentSize = size;
        [greenTestSprite setAnchorPoint:self.anchorPoint];
        [spriteToScroll addChild:greenTestSprite];
        _spriteToScroll = spriteToScroll;
    }
    return self;
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [_spriteToScroll setSize:contentSize];
        CGSize mySize = self.size;
        CGPoint backgroundPosition = (CGPoint){.x = mySize.width - contentSize.width + _contentOffset.x,
                                               .y = mySize.height - contentSize.height - _contentOffset.y};
        [self.spriteToScroll setPosition:backgroundPosition];
    }
}

#if TARGET_OS_IPHONE
#define NSSTRINGFROMPOINT NSStringFromCGPoint
#else
#define NSSTRINGFROMPOINT NSStringFromPoint
#endif
-(void)setContentOffset:(CGPoint)contentOffset
{
    if (!CGPointEqualToPoint(contentOffset, _contentOffset))
    {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSSTRINGFROMPOINT(contentOffset));
        CGPoint oldContentOffset = _contentOffset;
        _contentOffset = contentOffset;
        CGPoint position = [self.spriteToScroll position];
        position.y += contentOffset.y - oldContentOffset.y;
        position.x -= contentOffset.x - oldContentOffset.x;
        [self.spriteToScroll setPosition:position];
    }
}

@end
