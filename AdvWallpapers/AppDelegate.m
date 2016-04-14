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

// Status Stuff
@synthesize statusController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    statusController = [[StatusWindowController alloc] initWithWindowNibName:@"StatusWindowController"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
