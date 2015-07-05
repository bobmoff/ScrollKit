//
//  IIOSXAppDelegate.m
//  ScrollKitOSX
//
//  Created by Jonathan Saggau on 1/26/14.
//

#import "IIOSXAppDelegate.h"
#import "ScrollKitOSX-Swift.h"
#import <SpriteKit/SpriteKit.h>

const CGFloat multiplier = 1.5;

@interface ENHFLippedView : NSView
@end

@implementation ENHFLippedView

-(BOOL)isFlipped
{
    return YES;
}

@end

@interface IIOSXAppDelegate () <NSWindowDelegate>

@property(nonatomic, weak)IBOutlet NSScrollView *scrollView;
@property(nonatomic, readonly)IIMyScene *scene;

@end

@implementation IIOSXAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CGSize windowSize = (CGSize)[self.window.contentView frame].size;
    IIMyScene *scene = [IIMyScene sceneWithSize:windowSize];

    //Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeResizeFill;

    SKView *skView = self.skView;
    NSScrollView *scrollView = self.scrollView;

    [skView presentScene:scene];

    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    [self.scrollView setDrawsBackground:NO];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:YES];

    [self.scrollView setBorderType:NSNoBorder];
    [self.scrollView setAutohidesScrollers:YES];

    ENHFLippedView *clearDocumentView = [[ENHFLippedView alloc] initWithFrame:NSRectFromCGRect(CGRectZero)];
    [clearDocumentView setWantsLayer:YES];

    [clearDocumentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setDocumentView:clearDocumentView];

    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(skView, scrollView, clearDocumentView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[skView]|" options:0 metrics:nil views:viewsDict];
    [self.window.contentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[skView]|" options:0 metrics:nil views:viewsDict];
    [self.window.contentView addConstraints:constraints];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:clearDocumentView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:scrollView
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:multiplier
                                                                   constant:0.0];
    [self.window.contentView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:clearDocumentView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:scrollView
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:multiplier
                                               constant:0.0];
    [self.window.contentView addConstraint:constraint];

    CGRect frame = [self.window.contentView frame];
    CGSize contentSize = frame.size;
    contentSize.height *= multiplier;
    contentSize.width *= multiplier;
    [scene setContentSize:contentSize];

    //~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleOSX10.9.CoreReference.docset/
    //Contents/Resources/Documents/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/SynchroScroll.html
    // Make sure the watched view is sending bounds changed
    // notifications (which is probably does anyway, but calling
    // this again won't hurt).
    [scrollView setPostsBoundsChangedNotifications:YES];

    // a register for those notifications on the synchronized content view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewDidScroll:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:scrollView.contentView];
}

-(void)windowDidResize:(NSNotification *)notification
{
    CGRect frame = [self.window.contentView frame];
    CGSize contentSize = frame.size;
    contentSize.height *= multiplier;
    contentSize.width *= multiplier;
    [self.scene setContentSize:contentSize];
    [self _scrollViewDidScroll:self.scrollView];
}

-(void)_scrollViewDidScroll:(id)changedContentView
{
	NSPoint contentOffset = [self.scrollView documentVisibleRect].origin;
	NSSize contentSize = [[self.scrollView contentView] bounds].size;
	CGFloat scrollAreaHeight = self.scene.contentSize.height - contentSize.height;
	CGFloat yCocoa = contentOffset.y;
	
	// Convert from Cocoa coordinates to SpriteKit coordinates
	// Cocoa has 0,0 in the top-left corner
	// SpriteKit has 0,0 in the bottom-left corner
	CGFloat ySpriteKit = scrollAreaHeight - yCocoa;
	CGPoint contentOffsetSpriteKit = CGPointMake(contentOffset.x, ySpriteKit);
	[self.scene setContentOffset:contentOffsetSpriteKit];
}

-(void)scrollViewDidScroll:(NSNotification *)notification
{
    // get the changed content view from the notification
    NSClipView *changedContentView=[notification object];
    [self _scrollViewDidScroll:changedContentView];
}

-(IIMyScene *)scene
{
    return (id) self.skView.scene;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSViewBoundsDidChangeNotification
                                                  object:self.scrollView];
}

@end
