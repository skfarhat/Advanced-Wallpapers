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
#import "BaseClassViewController.h" 

@interface MainViewController : BaseClassViewController  {
    
    NSOpenPanel* openDlg;
    
    NSArray<NSString*> *rotationStrings;
}

@property (strong) IBOutlet NSButton *randomCheckbox;
@property (strong) IBOutlet NSComboBox *rotationComboBox;
@property (strong) IBOutlet NSTextField *hoursTextField;

@property (strong) IBOutlet NSTextField *daysTextField;
@property (strong) IBOutlet NSTextField *minTextField;
@property (strong) IBOutlet NSTextField *secTextField;

@end
