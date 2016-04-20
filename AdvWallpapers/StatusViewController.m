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
@synthesize daysTextField, hoursTextField, minTextField, secTextField;
@synthesize randomCheckbox, rotationComboBox;

-(id)initWithCoder:(NSCoder *)coder{
    
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

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // TODO: might be unnecessary
    [statusMainView setKeyDelegate:self];
    
    
    NSArray *rotationStrings = [NSArray arrayWithObjects:
                       @"Off", @"Interval", @"Login", @"Sleep", nil];
    [rotationComboBox addItemsWithObjectValues:rotationStrings];
    if ([rotationStrings count] > 0)
        [rotationComboBox selectItemAtIndex:0];
}

#pragma mark -
- (void)openPanel
{
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

- (void)closePanel
{
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
}

- (IBAction)optionChanged:(id)sender {
    if ([[rotationComboBox stringValue] isEqualToString:@"Interval"])
    {
       // enable fields
        [daysTextField setEnabled:YES];
        [hoursTextField setEnabled:YES];
        [minTextField setEnabled:YES];
        [secTextField setEnabled:YES];
        [randomCheckbox setEnabled:YES];
    }
    else
    {
        // disable fields
        [daysTextField setEnabled:NO];
        [hoursTextField setEnabled:NO];
        [minTextField setEnabled:NO];
        [secTextField setEnabled:NO];
        [randomCheckbox setEnabled:NO];
    }
}

- (IBAction)settingsButtonPressed:(id)sender {
    // tell app delegate to open the mainview controller
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_MAIN_CONTROLLER
                                                        object:nil userInfo:self.slideshow];
    [self closePanel];
}

-(NSInteger) getTimeInterval {
    NSInteger days = [[daysTextField stringValue] intValue];
    NSInteger hours = [[hoursTextField stringValue] intValue] + days * 24;
    NSInteger minutes = [[minTextField stringValue] intValue] + hours * 60;
    NSInteger seconds = [[secTextField stringValue] intValue] + minutes * 60;
    return seconds;
}

- (IBAction)closeWindow:(id)sender {
    [self closePanel];
}

-(IBAction)apply:(id)sender {
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:APPLESCRIPT_CURRENT_DESKTOP ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *rotation = @([rotationComboBox indexOfSelectedItem]).stringValue;
    NSString *seconds = @([self getTimeInterval]).stringValue;
    NSString *random =  ([randomCheckbox state] == true)? @"true" : @"false";
    
    NSAssert(contents != NULL, @"contents can't be null...");
    
    NSString *s = [NSString stringWithFormat:contents,
                   @"", rotation,
                   @"", random,
                   @"", self.slideshow.path,
                   @"", seconds];
    
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
        [self.slideshow setSeconds:seconds];
        [self.slideshow setRotation:rotation];
        [self.slideshow save];
    }
}

/** returns the fullpath to the currently selected image */
-(NSString*)getcurrentFilename {
    return [NSString stringWithFormat:@"%@/%@", self.slideshow.path, self.filenames[index]];
}

-(BOOL)acceptsFirstResponder{
    return YES;
}

@end