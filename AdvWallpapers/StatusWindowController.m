//
//  StatusWindowController.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 13/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "StatusWindowController.h"



#define OPEN_DURATION .15
#define CLOSE_DURATION .1
#define STATUS_ITEM_VIEW_WIDTH 24.0
#define SEARCH_INSET 17

#define POPUP_HEIGHT 122
#define PANEL_WIDTH 280
#define MENU_ANIMATION_DURATION .1

@interface StatusWindowController ()

@end

@implementation StatusWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__); 
}


- (void)openPanel
{
    // textfield
    NSRect textRect = NSMakeRect(0.0, 0.0, 30, 20);
    NSTextField *textfield = [[NSTextField alloc] initWithFrame:textRect];
    [textfield setStringValue:@"SS"];
    
    //    NSLog(@"%@", windowController.contentViewController);
    
    NSTimeInterval openDuration = OPEN_DURATION;
#define ARROW_WIDTH 12
#define ARROW_HEIGHT 8
    
    
//    NSLog(@"the statusview is %@", statusItem.view);
//    NSLog(@"%f", statusItem.view.frame.size.width);
    NSWindow *panel = [self window];
    
    
    // TODO: get the status rect
    
    NSRect statusRect = [self statusRectForWindow:panel];
    
    
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    /* new panel */
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect panelRect = [panel frame];
    panelRect.size.width = 270.0f;
    panelRect.size.height = 310.0f;
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    //    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    //    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [panel performSelector:@selector(makeFirstResponder:) withObject:nil afterDelay:openDuration];
}


- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
//    else
//    {
//        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
//        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
//        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
//    }
    return statusRect;
}

@end