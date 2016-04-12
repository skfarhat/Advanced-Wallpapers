//
//  Slideshow.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slideshow : NSObject {
    NSString *plistPath; 
    NSMutableDictionary *plist;

    
    NSString *seconds;
    NSString *path;
    NSString *random;
    NSString *rotation;
}

/** */ 
-(Slideshow*)init;

/** */
-(void) save:(NSString*)path random:(NSString*)random
     seconds:(NSString*)seconds rotation:(NSString*)rotation;

/** */
-(NSInteger)getSeconds;

/** */
-(NSInteger)getRotation;

/** */
-(BOOL) getRandom;
@end
