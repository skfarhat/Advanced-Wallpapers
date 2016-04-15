//
//  StatusWindowController.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 13/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusView.h"
#import "Slideshow.h"

@interface StatusWindowController : NSWindowController {
    StatusView *statusView;
    NSStatusItem *statusItem;
    BOOL alreadyOpen;
    
    // index to data
    NSInteger index;
    
    // data
    NSArray<NSString*> *filenames;
}

@property(nonatomic, strong) Slideshow *slideshow;
@property (weak) IBOutlet NSImageView *imageView;

-(void)openPanel;


@end
