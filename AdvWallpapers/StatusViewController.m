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
@synthesize slideshow;
@synthesize pathControl;
@synthesize imageView;
@synthesize statusMainView;

-(id)initWithCoder:(NSCoder *)coder{

    self  = [super initWithCoder: coder];
    if (self)
    {
        IMAGE_EXTENSIONS = @[@"jpg", @"JPG", @"jpeg", @"JPEG", @"png", @"PNG", @"BMP", @"bmp",
                             @"tiff", @"TIFF"];
        NSImage *img = [NSImage imageNamed:@"instagram"];
        
        statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
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

-(BOOL)acceptsFirstResponder{
    return YES; 
}

-(void)viewDidLoad{
    [super viewDidLoad];

    // TODO: might be unnecessary
    [statusMainView setKeyDelegate:self];
    
}
- (void)flagsChanged:(NSEvent *)theEvent {
    commandDown = false;
    
    // command pressed
    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        commandDown = true;
    }
}

-(void)keyDown:(NSEvent *)theEvent{
    NSString*   const   character   =   [theEvent charactersIgnoringModifiers];
    unichar     const   code        =   [character characterAtIndex:0];
    
    switch (code)
    {
        case NSUpArrowFunctionKey:
        {
            break;
        }
        case NSDownArrowFunctionKey:
        {
            break;
        }
        case NSLeftArrowFunctionKey:
        {
            [self prevImageButtonPressed:nil];
            //            [self navigateToPreviousImage];
            break;
        }
        case NSRightArrowFunctionKey:
        {
            [self nextImageButtonPressed:nil];
            //            [self navigateToNextImage];
            break;
        }
        case 27:
        {
            [self closePanel];
            break;
        }
        case 44:
        {
            if (commandDown) [self settingsButtonPressed:nil];
        }
        default:
        {
            NSLog(@"key: %d", code);
        }
    }
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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

-(void)refresh {
    filenames = [[NSFileManager defaultManager]
                 contentsOfDirectoryAtPath:slideshow.path
                 error:nil];
    filenames = [filenames filteredArrayUsingPredicate:
                 [NSPredicate predicateWithFormat:@"(pathExtension IN %@)", IMAGE_EXTENSIONS]];
    
    // update imageview
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",
                           slideshow.path, filenames[index]];
    NSImage *image =[[NSImage alloc] initWithContentsOfFile:imagePath];
    [imageView setImage:image];
    
    // update path control
    [pathControl setURL:[NSURL URLWithString:slideshow.path]];
}

- (IBAction)prevImageButtonPressed:(id)sender {
    if (index-- == 0) {
        index = [filenames count] - 1;
    }
    
    [self refresh];
}

- (IBAction)nextImageButtonPressed:(id)sender {
    if (index++ == [filenames count] - 1) {
        index = 0;
    }
    
    [self refresh];
}

- (IBAction)applyButtonPressed:(id)sender {
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"SetDesktopPicture" ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *s = [NSString stringWithFormat:contents, [self getcurrentFilename]];
    NSDictionary *errorDict;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:s];
    [scriptObject executeAndReturnError: &errorDict];
}

- (IBAction)settingsButtonPressed:(id)sender {
    // tell app delegate to open the mainview controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMainViewController"
                                                        object:nil userInfo:slideshow];
    [self closePanel]; 
}

-(void)setSlideshow:(Slideshow *)slideshow1{
    slideshow = slideshow1;
    [self refresh];
}

/** returns the fullpath to the currently selected image */
-(NSString*)getcurrentFilename {
    return [NSString stringWithFormat:@"%@/%@", slideshow.path, filenames[index]];
}

#pragma mark -
#pragma mark PathControl 


-(BOOL)pathControl:(NSPathControl *)pathControl acceptDrop:(id<NSDraggingInfo>)info{
    return YES;
}
- (IBAction)pathControlClicked:(id)sender {
    NSURL *url = [pathControl objectValue];
    [slideshow setPath:url.path];
    [slideshow save];
    [self refresh];
}



@end