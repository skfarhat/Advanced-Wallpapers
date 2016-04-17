//
//  StatusView.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 13/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusView : NSView
{
    BOOL _isHighlighted;
    NSImage *_image;
}

@property (nonatomic, strong) NSImage *image;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic, strong) NSStatusItem *statusItem;



@end
