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
#import "KeyDelegate.h"
#import "StatusMainView.h"

@interface StatusViewController : NSViewController <KeyDelegate, NSPathControlDelegate> {
    
    const NSArray *IMAGE_EXTENSIONS;
    StatusView *statusView; 
    NSStatusItem *statusItem;
    BOOL alreadyOpen;
    
    // index to data
    NSInteger index;
    
    // data
    NSArray<NSString*> *filenames;
    
    BOOL commandDown; 
}
@property (strong) IBOutlet StatusMainView *statusMainView;

@property(nonatomic, strong) Slideshow *slideshow;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSPathControl *pathControl;

-(void)openPanel;

@end
