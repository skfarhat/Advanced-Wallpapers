//
//  StatusView.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 13/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView

@synthesize image;
@synthesize action;
@synthesize target;
@synthesize statusItem;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Set up dark mode for icon
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"AppleInterfaceStyle"]  isEqual: @"Dark"])
    {
        self.image = [NSImage imageNamed:@"StatusHighlighted"];
    }
    else
    {
        if (self.isHighlighted)
            self.image = [NSImage imageNamed:@"instagram-small"];
        else
            self.image = [NSImage imageNamed:@"instagram-small"];
    }
    
    [statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.isHighlighted];
    
    NSImage *icon = self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    
    [icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}


- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

-(NSRect)globalRect
{
    NSRect frame = [self frame];
    return [self.window convertRectToScreen:frame];
}
-(void)setStatusItem:(NSStatusItem *)statusItem1{
    NSLog(@"%s", __PRETTY_FUNCTION__); 
    statusItem = statusItem1;
    statusItem.view = self;
}

@end
