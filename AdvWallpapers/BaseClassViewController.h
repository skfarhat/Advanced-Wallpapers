//
//  BaseClassViewController.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 18/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Slideshow.h"

@interface BaseClassViewController : NSViewController <NSPathControlDelegate> 
{
    NSInteger index;
    
    const NSArray<NSString*> *IMAGE_EXTENSIONS;
}

@property (nonatomic, strong) Slideshow *slideshow;
@property (nonatomic, strong) NSArray *filenames;

// UI
@property (nonatomic, strong) IBOutlet NSPathControl *pathControl;
@property (nonatomic, strong) IBOutlet NSImageView *imageView;

@end
