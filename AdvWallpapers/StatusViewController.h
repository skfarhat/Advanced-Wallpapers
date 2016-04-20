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
#import "BaseClassViewController.h"


@interface StatusViewController : BaseClassViewController <KeyDelegate> {
    
    StatusView *statusView; 
    NSStatusItem *statusItem;
    BOOL alreadyOpen;

    BOOL commandDown; 
}

@property (strong) IBOutlet StatusMainView *statusMainView;

@property (strong) IBOutlet NSButton *randomCheckbox;
@property (strong) IBOutlet NSComboBox *rotationComboBox;
@property (strong) IBOutlet NSTextField *daysTextField;
@property (strong) IBOutlet NSTextField *hoursTextField;
@property (strong) IBOutlet NSTextField *minTextField;
@property (strong) IBOutlet NSTextField *secTextField;


-(void)openPanel;

@end
