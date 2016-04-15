//
//  AppDelegate.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusWindowController.h"
#import "MainViewController.h"
#import "StatusView.h"
#import "Slideshow.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

// Status Stuff
@property (strong, nonatomic) StatusWindowController *statusController;

@property (strong, nonatomic) Slideshow *slideshow;

@property (strong, nonatomic) MainViewController *mainViewController;
@property (weak) NSWindow* window;
@property (strong, nonatomic) NSWindowController *windowController; 
@end

