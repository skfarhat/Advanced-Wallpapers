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

-(id)initWithStatusItem:(NSStatusItem*) item {

    CGFloat itemWidth = [item length];

    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);

    
    self = [super initWithFrame:itemRect];
    if (self)
    {
        statusItem = item;
        statusItem.view = self;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
 
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    
    // Drawing code here.
}

#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [NSApp sendAction:self.action to:self.target from:self];
}


- (void)setHighlighted:(BOOL)newFlag
{
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}


@end
