//
//  AppDelegate.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize statusController;
@synthesize slideshow;
@synthesize mainViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    statusController = [[StatusWindowController alloc] initWithWindowNibName:@"StatusWindowController"];
    [statusController setSlideshow:slideshow]; 
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainVC" bundle:nil];
    NSLog(@"%@", mainViewController);
//    _window = [[[NSApplication sharedApplication] windows] firstObject];
//    NSLog(@"%@", _window);
//    [_window setContentViewController:mainViewController];
    // TODO: pass slideshow to MainViewController
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)setMainViewController:(MainViewController *)mainViewController1 {
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    mainViewController = mainViewController1;
    [self.mainViewController setSlideshow:slideshow];
}

@end
