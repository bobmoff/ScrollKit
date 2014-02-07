//
//  IIMyScene.m
//  ScrollKit
//
//  Created by Fille Åström on 20/11/13.
//  Copyright (c) 2013 IMGNRY. All rights reserved.
//

#import "IIMyScene.h"

typedef NS_ENUM(NSInteger, IIMySceneZPosition)
{
    kIIMySceneZPositionScrolling = 0,
    kIIMySceneZPositionVerticalAndHorizontalScrolling,
    kIIMySceneZPositionStatic,
};

@interface IIMyScene ()
//kIIMySceneZPositionScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;

//kIIMySceneZPositionStatic
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;

//kIIMySceneZPositionVerticalAndHorizontalScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForHorizontalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForVerticalScrolling;
@end

@implementation IIMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        [self setAnchorPoint:(CGPoint){0,1}];
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [spriteToScroll setZPosition:kIIMySceneZPositionScrolling];
        [self addChild:spriteToScroll];

        //Overlay sprite to make anchor point 0,0 (lower left, default for SK)
        SKSpriteNode *spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteToScroll addChild:spriteForScrollingGeometry];

        SKSpriteNode *scrollingGeometryAnchorMarker = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:(CGSize){20,20}];
        [spriteForScrollingGeometry addChild:scrollingGeometryAnchorMarker];

        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteForStaticGeometry setZPosition:kIIMySceneZPositionStatic];
        [self addChild:spriteForStaticGeometry];

        SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToHostHorizontalAndVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling setPosition:(CGPoint){0, -size.height}];
        [spriteToHostHorizontalAndVerticalScrolling setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
        [self addChild:spriteToHostHorizontalAndVerticalScrolling];

        CGSize upAndDownSize = size;
        upAndDownSize.width = 30;
        SKSpriteNode *spriteForVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:upAndDownSize];
        [spriteForVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForVerticalScrolling];

        CGSize leftToRightSize = size;
        leftToRightSize.height = 30;
        SKSpriteNode *spriteForHorizontalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:leftToRightSize];
        [spriteForHorizontalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForHorizontalScrolling];

        //Test sprites for constrained Scrolling
        SKLabelNode *horizontallyScrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        [horizontallyScrollingLabel setText:@"Left and right and not up and down, just left and right because I am so cool and I am an axis label!"];
        [horizontallyScrollingLabel setFontSize:14.0];
        [horizontallyScrollingLabel setFontColor:[SKColor lightGrayColor]];
        [horizontallyScrollingLabel setPosition:(CGPoint){.x = 10.0, .y = 30.0}];
        [horizontallyScrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
        [spriteForHorizontalScrolling addChild:horizontallyScrollingLabel];

        SKLabelNode *verticallyScrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        [verticallyScrollingLabel setText:@"V:50"];
        [verticallyScrollingLabel setFontSize:14.0];
        [verticallyScrollingLabel setFontColor:[SKColor lightGrayColor]];
        [verticallyScrollingLabel setPosition:(CGPoint){.x = 10.0, .y = 50.0}];
        [verticallyScrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
        [verticallyScrollingLabel setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
        [spriteForVerticalScrolling addChild:verticallyScrollingLabel];

        //Test sprites for scrolling and zooming
        SKSpriteNode *greenTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
                                                                     size:(CGSize){.width = size.width,
                                                                         .height = size.height*.25}];
        [greenTestSprite setName:@"greenTestSprite"];
        [greenTestSprite setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry addChild:greenTestSprite];

        SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
                                                                    size:(CGSize){.width = size.width*.25,
                                                                        .height = size.height*.25}];
        [blueTestSprite setName:@"blueTestSprite"];
        [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
        [blueTestSprite setPosition:(CGPoint){.x = size.width * .25, .y = size.height *.65}];
        [spriteForScrollingGeometry addChild:blueTestSprite];

        //Test sprites for stationary sprites
        SKLabelNode *stationaryLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
        [stationaryLabel setText:@"I'm not gonna move, nope, nope."];
        [stationaryLabel setFontSize:14.0];
        [stationaryLabel setFontColor:[SKColor darkGrayColor]];
        [stationaryLabel setPosition:(CGPoint){.x = 10.0, .y = 60.0}];
        [stationaryLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
        [spriteForStaticGeometry addChild:stationaryLabel];

        //Set properties
        _contentSize = size;
        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        _spriteForStaticGeometry = spriteForStaticGeometry;
        _spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling;
        _spriteForVerticalScrolling = spriteForVerticalScrolling;
        _spriteForHorizontalScrolling = spriteForHorizontalScrolling;
        _contentOffset = (CGPoint){0,0};
    }
    return self;
}

-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];

    CGPoint lowerLeft = (CGPoint){0, -size.height};

    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];

    [self.spriteToHostHorizontalAndVerticalScrolling setSize:size];
    [self.spriteToHostHorizontalAndVerticalScrolling setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];

        CGSize verticalSpriteSize = [self.spriteForVerticalScrolling size];
        verticalSpriteSize.height = contentSize.height;
        [self.spriteForVerticalScrolling setSize:verticalSpriteSize];

        CGSize horizontalSpriteSize = [self.spriteForHorizontalScrolling size];
        horizontalSpriteSize.width = contentSize.width;
        [self.spriteForHorizontalScrolling setSize:horizontalSpriteSize];

        [self setContentOffset:self.contentOffset];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];

    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];

    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];

    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.y = scrollingLowerLeft.y;
    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
}

-(void)setContentScale:(CGFloat)scale;
{
    [self.spriteToScroll setScale:scale];
}

@end
