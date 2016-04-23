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

-(void)openPanel;

@end
