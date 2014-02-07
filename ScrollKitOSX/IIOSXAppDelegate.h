//
//  IIOSXAppDelegate.h
//  ScrollKitOSX
//


#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface IIOSXAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@end
