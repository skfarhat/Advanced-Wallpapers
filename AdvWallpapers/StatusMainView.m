//
//  StatusMainView.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 17/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "StatusMainView.h"

@implementation StatusMainView
@synthesize keyDelegate;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(BOOL)acceptsFirstResponder{
    return YES; 
}

-(void)keyDown:(NSEvent *)theEvent{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [keyDelegate keyDown:theEvent]; 
}
@end
