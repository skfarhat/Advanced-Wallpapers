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
}

@property (nonnull, strong) NSString *path ;
@property (nonnull, strong) NSString *rotation;
@property (nonnull, strong) NSString *random;
@property (nonnull, strong) NSString *seconds;

/** */
-(Slideshow*)init;

-(void) save;
@end
