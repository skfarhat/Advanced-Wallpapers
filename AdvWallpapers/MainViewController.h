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

@interface MainViewController : NSViewController {
    
    NSOpenPanel* openDlg;
    
    NSArray<NSString*> *filenames;
    NSInteger index;
    
    NSArray<NSString*> *rotationStrings;
}

@property (strong) IBOutlet NSButton *randomCheckbox;
@property (strong) IBOutlet NSComboBox *rotationComboBox;
@property (strong) IBOutlet NSTextField *hoursTextField;
@property (strong) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet NSTextField *daysTextField;
@property (strong) IBOutlet NSTextField *minTextField;
@property (strong) IBOutlet NSTextField *secTextField;
@property (strong) IBOutlet NSTextField *pathLabel;

@property (strong, nonatomic) Slideshow *slideshow;
@end
