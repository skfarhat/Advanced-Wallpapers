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
#define ARROW_WIDTH 12
#define ARROW_HEIGHT 8


@interface StatusWindowController ()

@end

@implementation StatusWindowController


-(id) initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        
        NSImage *img = [NSImage imageNamed:@"instagram"];
        
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        [statusItem setHighlightMode:YES];
        [statusItem setImage:img];
        [statusItem setAction:@selector(togglePanel:)];
        
        statusView = [[StatusView alloc] initWithStatusItem:statusItem];
        statusView.action = @selector(togglePanel:);
        [statusView setTarget:self]; 
        [statusView setNeedsDisplay:YES];
        
        // hide the title bar
        [[self window] setTitleVisibility:NSWindowTitleHidden];
        [[self window] setTitlebarAppearsTransparent:YES];
        alreadyOpen = false; 

    }
    return self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark -
- (void)openPanel
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // some config
    NSTimeInterval openDuration = OPEN_DURATION;
    
    // the status rect
    NSRect statusviewrect = statusView.frame;
//    NSLog(@"%f,%f %f,%f", statusviewrect.origin.x, statusviewrect.origin.y,
//          statusviewrect.size.width, statusviewrect.size.height);

    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
//    NSLog(@"%f,%f %f,%f", statusRect.origin.x, statusRect.origin.y,
//          statusRect.size.width, statusRect.size.height);
    
    // the panel of this window
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
    
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [panel performSelector:@selector(makeFirstResponder:) withObject:nil afterDelay:openDuration];
}

- (void)closePanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
}

- (IBAction)togglePanel:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: check if panel open or close
    if (alreadyOpen)
    {
        [self closePanel];
    }
    else
    {
        [self openPanel];
    }
    alreadyOpen = !alreadyOpen;
    
}

#pragma mark -


- (NSRect)statusRectForWindow:(NSWindow *)window {
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
//    StatusItemView *statusItemView = nil;
//    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
//    {
//        statusItemView = [self.delegate statusItemViewForPanelController:self];
//    }
//    
    if (statusView)
    {
        statusRect = statusView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
//    //    else
//    //    {
//    //        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
//    //        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
//    //        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
//    //    }
    return statusRect;
}

@end
