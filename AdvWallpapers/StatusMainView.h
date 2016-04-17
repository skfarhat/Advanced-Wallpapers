//
//  StatusMainView.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 17/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyDelegate.h"

@interface StatusMainView : NSView

@property (nonatomic, assign) id<KeyDelegate> keyDelegate;
@end
