//
//  Slideshow.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "Slideshow.h"

/* keys in plist */
#define KEY_LAST_DIRECTORY      @"Last_Directory"
#define KEY_LAST_INTERVAL_SEC   @"Last_Interval"
#define KEY_LAST_RANDOM         @"Last_Random"
#define KEY_LAST_ROTATION       @"Last_Rotation"


@implementation Slideshow

@synthesize path;
@synthesize rotation;
@synthesize random;
@synthesize seconds;

-(Slideshow*)init {
    self = [super init];
    
    plistPath   = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    plist       = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    random      = [plist valueForKey:KEY_LAST_RANDOM];
    seconds     = [plist valueForKey:KEY_LAST_INTERVAL_SEC];
    rotation    = [plist valueForKey:KEY_LAST_ROTATION];
    path        = [plist valueForKey:KEY_LAST_DIRECTORY];
    
    return self;
}

-(void)save:(NSString*)path1
      random:(NSString*)random1
     seconds:(NSString*)seconds1
    rotation:(NSString*)rotation1 {
    path = path1;
    random = random1;
    seconds = seconds1;
    rotation = rotation1;
    
    [plist setValue:path forKey:KEY_LAST_DIRECTORY];
    [plist setValue:random forKey:KEY_LAST_RANDOM];
    [plist setValue:rotation forKey:KEY_LAST_ROTATION];
    [plist setValue:seconds forKey:KEY_LAST_INTERVAL_SEC];
    
    [plist writeToFile:plistPath atomically:YES];
}

-(void) save {
    return [self save:path random:random seconds:seconds rotation:rotation];
}

@end

