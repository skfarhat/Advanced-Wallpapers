//
//  BaseClassViewController.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 18/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "BaseClassViewController.h"

@interface BaseClassViewController ()

@end

@implementation BaseClassViewController
@synthesize filenames;
@synthesize slideshow;

// UI
@synthesize imageView;
@synthesize pathControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    IMAGE_EXTENSIONS = @[@"jpg", @"JPG", @"jpeg", @"JPEG", @"png", @"PNG", @"BMP", @"bmp",
                         @"tiff", @"TIFF"];
}

-(void)refresh {
    NSLog(@"%s", __PRETTY_FUNCTION__); 
    if (!slideshow) return;
    
    // get all files from the selected directory path, then filter it leaving
    // only jpg and png files
    filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:slideshow.path error:nil];
    filenames = [filenames filteredArrayUsingPredicate:
                 [NSPredicate predicateWithFormat:@"(pathExtension IN %@)", @[@"jpg", @"png", @"JPG"]]];
    [self updateImageView];
}

-(void) updateImageView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (filenames == NULL || [filenames count] < 1)
        return;
    
    /* update ImageView */
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", slideshow.path, filenames[index]];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPath];
    NSLog(@"%@", img); 
    [imageView setImage:img];
}

-(void)setSlideshow:(Slideshow *)slideshow1{
    NSLog(@"%s", __PRETTY_FUNCTION__); 
    slideshow = slideshow1;
    [self refresh];
    
}

#pragma mark -
#pragma mark IBActions

- (IBAction)nextImagePressed:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (++index == [filenames count])
        index = 0;
    
    [self refresh];
}

-(IBAction) :(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (--index < 0)
        index = [filenames count] - 1;
    
    [self refresh];
}

- (IBAction)pathControlClicked:(id)sender {
    NSURL *url = [pathControl objectValue];
    [slideshow setPath:url.path];
    [slideshow save];
    [self refresh];
}

-(BOOL)pathControl:(NSPathControl *)pathControl acceptDrop:(id<NSDraggingInfo>)info{
    return YES;
}


@end
