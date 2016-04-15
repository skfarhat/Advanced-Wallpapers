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

@synthesize windowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (!slideshow) {
        slideshow = [[Slideshow alloc] init];
    }
    statusController = [[StatusWindowController alloc] initWithWindowNibName:@"StatusWindowController"];
    [statusController setSlideshow:slideshow]; 
    
    mainViewController = [[MainViewController alloc] initWithNibName:@"MainVC" bundle:nil];
    NSLog(@"%@", mainViewController);
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainViewController) name:@"showMainViewController" object:nil];
}

-(void)showMainViewController {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
//    mainViewController = (MainViewController*)
//    [storyboard instantiateControllerWithIdentifier:@"MainViewController"];
    
    windowController = [storyboard instantiateControllerWithIdentifier:@"MainWindowController"];
    NSWindow *window = [windowController window];
    NSViewController *controller = [windowController contentViewController];;
    NSLog(@"%@", controller);
    
    [window makeKeyAndOrderFront:nil];
    [window setIsVisible:YES];

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
