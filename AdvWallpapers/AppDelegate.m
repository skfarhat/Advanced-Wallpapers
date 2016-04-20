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
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    
    // TODO: check if needded, if yes move to Appl delegate
    //        [[self window] setTitleVisibility:NSWindowTitleHidden];
    //        [[self window] setTitlebarAppearsTransparent:YES];
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:STORY_NAME bundle:nil];
    
    
    // window controller
    statusWindowController = (NSWindowController*) [storyboard instantiateControllerWithIdentifier:STATUS_CONTROLLER];
    
    // view controller
    statusController = (StatusViewController*) [statusWindowController contentViewController];
    [statusController setSlideshow:slideshow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewController:) name:NOTIFICATION_SHOW_MAIN_CONTROLLER object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)showMainViewController:(NSNotification*) notification {
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:STORY_NAME bundle:nil];
    
    windowController= [storyboard instantiateControllerWithIdentifier:MAIN_CONTROLLER];
    NSWindow *window = [windowController window];
    
    [window makeKeyAndOrderFront:nil];
    [window setIsVisible:YES];
    
    // set the slideshow on the MainViewControlller
    [windowController showWindow:windowController.self];
}

-(void)setMainViewController:(MainViewController *)mainViewController1 {
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    mainViewController = mainViewController1;
    [self.mainViewController setSlideshow:slideshow];
}

@end
