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
@synthesize statusWindowController;
@synthesize windowController;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    
    // TODO: check if needded, if yes move to Appl delegate
    //        [[self window] setTitleVisibility:NSWindowTitleHidden];
    //        [[self window] setTitlebarAppearsTransparent:YES];
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    // window controller
    statusWindowController = (NSWindowController*) [storyboard instantiateControllerWithIdentifier:@"StatusWindowController"];

    // view controller
    statusController = (StatusViewController*) [statusWindowController contentViewController];
    [statusController setSlideshow:slideshow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewController:) name:@"showMainViewController" object:nil];
}

-(void)showMainViewController:(NSNotification*) notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    Slideshow *slideshow = (Slideshow*) [notification userInfo];

    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    windowController= [storyboard instantiateControllerWithIdentifier:@"MainWindowController"];
    NSWindow *window = [windowController window];
    
    [window makeKeyAndOrderFront:nil];
    [window setIsVisible:YES];

    // set the slideshow on the MainViewControlller
//    MainViewController *mainViewController =  (MainViewController*) windowController.contentViewController;
    [windowController showWindow:windowController.self];
    
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
