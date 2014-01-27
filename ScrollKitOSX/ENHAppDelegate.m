//
//  ENHAppDelegate.m
//  ScrollKitOSX
//
//  Created by Jonathan Saggau on 1/26/14.
//  Copyright (c) 2014 IMGNRY. All rights reserved.
//

#import "ENHAppDelegate.h"
#import "IIMyScene.h"
#import <SpriteKit/SpriteKit.h>

@interface ENHAppDelegate ()

@property(nonatomic, weak)IBOutlet NSScrollView *scrollView;
@property(nonatomic, readonly)IIMyScene *scene;

@end

@implementation ENHAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [IIMyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeFill;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;

    [self.scrollView setDrawsBackground:NO];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:YES];

    // configure the scroller to have no visible border
    [self.scrollView setBorderType:NSNoBorder];

    // set the autoresizing mask so that the scroll view will
    // resize with the window
    [self.scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];

    NSSize sizeForContent = CGSizeMake(self.skView.frame.size.width, self.skView.frame.size.height * 1.5);
    NSRect frame = NSMakeRect(0, 0, sizeForContent.width, sizeForContent.height);
    NSView *clearDocumentView = [[NSView alloc] initWithFrame:frame];
    [clearDocumentView setWantsLayer:YES];
    [clearDocumentView setAlphaValue:0.2];

    [self.scrollView setDocumentView:clearDocumentView];

    // Make sure the watched view is sending bounds changed
    // notifications (which is probably does anyway, but calling
    // this again won't hurt).
    [self.scrollView setPostsBoundsChangedNotifications:YES];

    // a register for those notifications on the synchronized content view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewContentBoundsDidChange:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:self.scrollView.contentView];
}

- (void)scrollViewContentBoundsDidChange:(NSNotification *)notification
{
    // get the changed content view from the notification
    NSClipView *changedContentView=[notification object];

    // get the origin of the NSClipView of the scroll view that
    // we're watching
    NSPoint changedBoundsOrigin = [changedContentView documentVisibleRect].origin;
    NSLog(@"scroll view changed = %@", NSStringFromPoint(changedBoundsOrigin));
    CGPoint position = self.scene.spriteToScroll.position;
    position.y = changedBoundsOrigin.y;
    self.scene.spriteToScroll.position = position;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewBoundsDidChangeNotification object:self.scrollView];
}

@end
