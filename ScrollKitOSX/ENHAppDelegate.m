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

const CGFloat multiplier = 1.5;

@interface ENHAppDelegate () <NSWindowDelegate>

@property(nonatomic, weak)IBOutlet NSScrollView *scrollView;
@property(nonatomic, readonly)IIMyScene *scene;

@end

@implementation ENHAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    IIMyScene *scene = [IIMyScene sceneWithSize:CGSizeMake(1024, 768)];

    //Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeResizeFill;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;

    [self.scrollView setDrawsBackground:NO];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:YES];

    [self.scrollView setBorderType:NSNoBorder];
    [self.scrollView setAutohidesScrollers:YES];

    NSView *clearDocumentView = [[NSView alloc] initWithFrame:(NSRect){0,0,0,0}];
    [clearDocumentView setWantsLayer:YES];

    [clearDocumentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setDocumentView:clearDocumentView];

    SKView *skView = self.skView;
    NSScrollView *scrollView = self.scrollView;

    CGRect frame = [self.window.contentView frame];
    CGSize contentSize = frame.size;
    contentSize.height *= multiplier;
    [scene setContentSize:contentSize];
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(skView, scrollView, clearDocumentView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[skView(==clearDocumentView)]" options:0 metrics:nil views:viewsDict];
    [self.window.contentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[skView(==clearDocumentView)]" options:0 metrics:nil views:viewsDict];
    [self.window.contentView addConstraints:constraints];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:clearDocumentView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:scrollView
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:multiplier
                                                                   constant:-15.0];
    [self.window.contentView addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:clearDocumentView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:scrollView
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0
                                               constant:-15.0];
    [self.window.contentView addConstraint:constraint];

    //~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleOSX10.9.CoreReference.docset/
    //Contents/Resources/Documents/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/SynchroScroll.html
    // Make sure the watched view is sending bounds changed
    // notifications (which is probably does anyway, but calling
    // this again won't hurt).
    [self.scrollView setPostsBoundsChangedNotifications:YES];

    // a register for those notifications on the synchronized content view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollViewDidScroll:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:self.scrollView.contentView];
}

-(void)windowDidResize:(NSNotification *)notification
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), notification);
    CGRect frame = [self.window.contentView frame];
    CGSize contentSize = frame.size;
    contentSize.height *= multiplier;
    [self.scene setContentSize:contentSize];
}

- (void)scrollViewDidScroll:(NSNotification *)notification
{
    // get the changed content view from the notification
    NSClipView *changedContentView=[notification object];

    // get the origin of the NSClipView of the scroll view that
    // we're watching
    NSPoint changedBoundsOrigin = [changedContentView documentVisibleRect].origin;
    [self.scene setContentOffset:changedBoundsOrigin];
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
