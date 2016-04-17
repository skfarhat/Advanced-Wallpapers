//
//  KeyDelegate.h
//  AdvWallpapers
//
//  Created by Sami Farhat on 17/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#ifndef KeyDelegate_h
#define KeyDelegate_h

@protocol KeyDelegate <NSObject>

-(void)keyDown:(NSEvent *)theEvent;

@end
#endif /* KeyDelegate_h */
