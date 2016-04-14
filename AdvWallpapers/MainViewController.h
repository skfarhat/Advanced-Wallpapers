//
//  MainViewController.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Slideshow.h"
#import "StatusView.h"
#import "StatusWindowController.h"

@interface MainViewController : NSViewController {
    
    // open dialog
    NSOpenPanel* openDlg;

    
    Slideshow *slideshow;
    
    NSString *wallpapersPath;
    
    NSArray<NSString*> *filenames;
    
    /** file index, points to the currently selected image within filenames */
    NSInteger index;
    
    NSArray<NSString*> *rotationStrings;
    
//    NSWindowController *windowController;
    
    StatusView *statusView; 
 
    
}
- (IBAction)togglePanel:(id)sender;


@property (strong) IBOutlet NSButton *randomCheckbox;
@property (strong) IBOutlet NSComboBox *rotationComboBox;
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NSClipView *clipView;
@property (strong) IBOutlet NSScrollView *scrollText;

@property (strong) IBOutlet NSTextField *hoursTextField;
@property (strong) IBOutlet NSTextField *debugLabel;
@property (strong) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet NSTextField *daysTextField;
@property (strong) IBOutlet NSTextField *minTextField;
@property (strong) IBOutlet NSTextField *secTextField;
@property (strong) IBOutlet NSTextField *pathLabel;

// Status Stuff
@property (strong, nonatomic) StatusWindowController *statusController;
@property (strong, nonatomic) NSView *statusView;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end
