//
//  AppDelegate.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusViewController.h"
#import "MainViewController.h"
#import "StatusView.h"
#import "Slideshow.h"
#include "AdvWallpapers.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) Slideshow *slideshow;

@property (strong, nonatomic) NSWindowController *windowController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) NSWindowController *statusWindowController;
@property (strong, nonatomic) StatusViewController *statusController;

@property (weak) NSWindow* window;

@end

