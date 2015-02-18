//
//  IIMyScene.h
//  ScrollKit
//
//

#import <SpriteKit/SpriteKit.h>

//Anchor point is {0,1} <-- Don't change that or scrolling will get messed-up
//If you want to use some other anchor point, add a subnode with a more appropriate
//anchor point and offset it appropriately; see the spriteForScrollingGeometry and
//spriteForStaticGeometry private properties in initWithSize: for how to do this.

@interface IIMyScene : SKScene

@property (nonatomic) CGSize contentSize;
@property(nonatomic) CGPoint contentOffset;

-(void)setContentScale:(CGFloat)scale;
-(void)setContentOffset:(CGPoint)contentOffset;

@end
