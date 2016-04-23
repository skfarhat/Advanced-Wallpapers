//
//  Slideshow.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "Slideshow.h"
#import "AdvWallpapers.h"

@implementation Slideshow

@synthesize path;
@synthesize rotation;
@synthesize random;
@synthesize seconds;
@synthesize lastUpdate;

-(Slideshow*)init {
    self = [super init];
    
    plistPath   = [[NSBundle mainBundle] pathForResource:PLIST_CONFIG_NAME ofType:PLIST_EXTENSION];
    plist       = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    random      = [plist valueForKey:KEY_LAST_RANDOM];
    seconds     = [plist valueForKey:KEY_LAST_INTERVAL_SEC];
    rotation    = [plist valueForKey:KEY_LAST_ROTATION];
    path        = [plist valueForKey:KEY_LAST_DIRECTORY];
    lastUpdate  = [plist valueForKey:KEY_LAST_UPDATE];
    
    return self;
}
-(void) save {
    
    [plist setValue:path forKey:KEY_LAST_DIRECTORY];
    [plist setValue:random forKey:KEY_LAST_RANDOM];
    [plist setValue:rotation forKey:KEY_LAST_ROTATION];
    [plist setValue:seconds forKey:KEY_LAST_INTERVAL_SEC];
    [plist setValue:lastUpdate.description forKey:KEY_LAST_UPDATE];
    
    [plist writeToFile:plistPath atomically:YES];    
}

@end

