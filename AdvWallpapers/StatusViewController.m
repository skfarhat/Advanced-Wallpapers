//
//  StatusWindowController.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 13/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "StatusViewController.h"

#define OPEN_DURATION .15
#define CLOSE_DURATION .1
#define STATUS_ITEM_VIEW_WIDTH 24.0
#define SEARCH_INSET 17
#define POPUP_HEIGHT 122
#define PANEL_WIDTH 280
#define MENU_ANIMATION_DURATION .1
#define ARROW_WIDTH 12
#define ARROW_HEIGHT 8


@interface StatusViewController ()
@end

@implementation StatusViewController

@synthesize statusMainView;

-(id)initWithCoder:(NSCoder *)coder {
    
    self  = [super initWithCoder: coder];
    if (self)
    {
        NSImage *img = [NSImage imageNamed:@"instagram"];
        
        statusItem = [[NSStatusBar systemStatusBar]
                      statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        [statusItem setHighlightMode:YES];
        [statusItem setImage:img];
        [statusItem setAction:@selector(togglePanel:)];
        
        statusView = [[StatusView alloc] init];
        [statusView setStatusItem:statusItem];
        
        [statusView setAction:@selector(togglePanel:)];
        [statusView setTarget:self];
        [statusView setNeedsDisplay:YES];
        
        [statusItem setView: statusView];
        
        alreadyOpen = false;
        
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: might be unnecessary
    [statusMainView setKeyDelegate:self];

}

#pragma mark -
- (void)openPanel {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGFloat width =  self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    // some config
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSWindow *panel = [[self view] window];
    NSRect statusRect = [self statusRectForWindow:panel];
    // the panel of this window
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    // new panel
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect panelRect = [panel frame];
    
    panelRect.size.width = width;
    panelRect.size.height = height;
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    panelRect.origin.x = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    [self.view.window makeFirstResponder:statusMainView];
}

- (void)closePanel {
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[[self view] window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.view.window orderOut:nil];
    });
    [self.view.window makeFirstResponder:nil];
}

- (IBAction)togglePanel:(id)sender {
    
    if (alreadyOpen)    [self closePanel];
    else                [self openPanel];
    
    alreadyOpen = !alreadyOpen;
}

-(void)handleEscape {
    [self closePanel];
}

#pragma mark -


- (NSRect)statusRectForWindow:(NSWindow *)window {
    NSRect statusRect = NSZeroRect;
    if (statusView)
    {
        statusRect = statusView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    return statusRect;
}

- (IBAction)setCurrent:(id)sender {
    
    NSString *scriptPath = [[NSBundle mainBundle]
                            pathForResource:APPLESCRIPT_SET_DESKTOP_PICTURE
                            ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *s = [NSString stringWithFormat:contents, [self getcurrentFilename]];
    NSDictionary *errorDict;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:s];
    [scriptObject executeAndReturnError: &errorDict];
    
    // TODO: reset the interface to Off
    [self resetUI];
}


-(void) enableFields:(BOOL)enable {
    [self.daysTextField setEnabled:enable];
    [self.hoursTextField setEnabled:enable];
    [self.minTextField setEnabled:enable];
    [self.secTextField setEnabled:enable];
    [self.randomCheckbox setEnabled:enable];
}

- (IBAction)optionChanged:(id)sender {
    if ([[self.rotationComboBox stringValue] isEqualToString:@"Interval"])
    {
        [self enableFields:YES];
    }
    else
    {
        [self enableFields:NO];
    }
}

-(NSInteger)getTimeInterval {
    NSInteger days = [[self.daysTextField stringValue] intValue];
    NSInteger hours = [[self.hoursTextField stringValue] intValue] + days * 24;
    NSInteger minutes = [[self.minTextField stringValue] intValue] + hours * 60;
    NSInteger seconds = [[self.secTextField stringValue] intValue] + minutes * 60;
    return seconds;
}
-(NSDictionary*)getTimeComponents:(NSInteger) seconds {
    NSInteger totalSec = seconds;
    
    const NSInteger SEC_PER_MIN = 60;
    const NSInteger SEC_PER_HOUR = 3600;
    const NSInteger SEC_PER_DAY = SEC_PER_HOUR * 24;
    
    NSInteger days = totalSec / SEC_PER_DAY;
    totalSec -= days * SEC_PER_DAY;
    NSInteger hours = totalSec / SEC_PER_HOUR;
    totalSec -= hours * SEC_PER_HOUR;
    NSInteger min = totalSec / SEC_PER_MIN;
    NSInteger sec = totalSec - min * SEC_PER_MIN;
    NSArray *objects = @[
                         [NSNumber numberWithInteger:days],
                         [NSNumber numberWithInteger:hours],
                         [NSNumber numberWithInteger:min],
                         [NSNumber numberWithInteger:sec],
                         ];
    NSArray *keys = @[@"days", @"hours", @"min", @"sec"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return dict;
}

- (IBAction)closeWindow:(id)sender {
    [self closePanel];
}

-(IBAction)apply:(id)sender {
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:APPLESCRIPT_CURRENT_DESKTOP ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *rotation = @([self.rotationComboBox indexOfSelectedItem]).stringValue;
    NSInteger seconds = [self getTimeInterval];
    NSString *secondsStr = @(seconds).stringValue;
    NSString *random =  @(self.randomCheckbox.state).stringValue;
    
    NSAssert(contents != NULL, @"contents can't be null...");
    
    NSString *s = [NSString stringWithFormat:contents,
                   @"", rotation,
                   @"", random,
                   @"", self.slideshow.path,
                   @"", secondsStr];
    
    
    // make sure number of seconds is not zero and not less than some number
    
    if (seconds < 60)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        if (seconds == 0)
        {
            [alert setMessageText: @"Time interval cannot be 0"];
            [alert addButtonWithTitle:@"Ok change it"];
            [alert runModal];
            return;
        }
        else {
            [alert setMessageText:
             @"It is generally discouaged to a have a brief time interval as this might lead to lower OS performance"];
            [alert addButtonWithTitle:@"I'll change"];
            [alert addButtonWithTitle:@"I know what I'm doing"];
            [alert runModal];
        }
    }
    
    // exit if path is null
    if(self.slideshow.path == NULL)
        return;
    
    
    // execute script
    NSDictionary *errorDict;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:s];
    [scriptObject executeAndReturnError: &errorDict];
    
    NSLog(@"%@", errorDict.description);
    
    // save if no error
    if (errorDict == NULL) {
        [self.slideshow setRandom:random];
        [self.slideshow setSeconds:secondsStr];
        [self.slideshow setRotation:rotation];
        [self.slideshow setLastUpdate:[NSDate date]];
        [self.slideshow save];
    }
}

-(void)refresh {
    [super refresh];
    NSDictionary *timeDict = [self getTimeComponents:self.slideshow.seconds.integerValue];
    [self.daysTextField setStringValue:timeDict[@"days"]];
    [self.hoursTextField setStringValue:timeDict[@"hours"]];
    [self.minTextField setStringValue:timeDict[@"min"]];
    [self.secTextField setStringValue:timeDict[@"sec"]];
    [self updateRotationCombobox];
    [self optionChanged:nil];
    [self updateRandomCheckbox];

}
-(void) resetUI {
    if (self.rotationComboBox && self.rotationComboBox.numberOfItems > 1)
        [self.rotationComboBox selectItemAtIndex:0];
    
    [self enableFields:NO];
}

/** returns the fullpath to the currently selected image */
-(NSString*)getcurrentFilename {
    return [NSString stringWithFormat:@"%@/%@", self.slideshow.path, self.filenames[index]];
}

-(BOOL)acceptsFirstResponder {
    return YES;
}

@end