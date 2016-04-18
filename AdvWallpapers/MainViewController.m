//
//  MainViewController.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
@interface MainViewController ()

@end

@implementation MainViewController

@synthesize hoursTextField, secTextField, minTextField, daysTextField;
@synthesize imageView, pathLabel;
@synthesize rotationComboBox;
@synthesize randomCheckbox;

@synthesize slideshow;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init OpenDialog
    openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    rotationStrings = [NSArray arrayWithObjects:
                       @"Off", @"Interval", @"Login", @"Sleep", nil];
    index = 0;
    [rotationComboBox addItemsWithObjectValues:rotationStrings];
    if ([rotationStrings count] > 0)
        [rotationComboBox selectItemAtIndex:0];

    
    // pass reference of self to app delegate
    AppDelegate *delegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    [delegate setMainViewController:self];
}

-(void)refresh {
    if (!slideshow) return;
    
    // get all files from the selected directory path, then filter it leaving
    // only jpg and png files
    filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:slideshow.path error:nil];
    filenames = [filenames filteredArrayUsingPredicate:
                 [NSPredicate predicateWithFormat:@"(pathExtension IN %@)", @[@"jpg", @"png", @"JPG"]]];
    
    
    [self updateImageView];
    
    if (slideshow.path)
        [pathLabel setStringValue:slideshow.path];
    if (slideshow.rotation)
        [rotationComboBox selectItemAtIndex:slideshow.rotation.integerValue];
    if (slideshow.random)
        [randomCheckbox setState:slideshow.random.integerValue];
}


-(NSInteger) getTimeInterval {
    NSInteger days = [[daysTextField stringValue] intValue];
    NSInteger hours = [[hoursTextField stringValue] intValue] + days * 24;
    NSInteger minutes = [[minTextField stringValue] intValue] + hours * 60;
    NSInteger seconds = [[secTextField stringValue] intValue] + minutes * 60;
    return seconds;
}

-(void) updateImageView {
    
    if (filenames == NULL || [filenames count] < 1)
        return;
    
    /* update ImageView */
    NSString *imgPath = [NSString stringWithFormat:@"%@/%@", slideshow.path, filenames[index]];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPath];
    [imageView setImage:img];
}

/** loads previous time interval into the view's textfields
 * days, hours, seconds, minutes */
-(void)displayPreviousInterval {

    NSInteger totalSec = slideshow.seconds.integerValue;
    
    const NSInteger SEC_PER_MIN = 60;
    const NSInteger SEC_PER_HOUR = 3600;
    const NSInteger SEC_PER_DAY = SEC_PER_HOUR * 24;
    
    NSInteger days = totalSec / SEC_PER_DAY;
    totalSec -= days * SEC_PER_DAY;
    NSInteger hours = totalSec / SEC_PER_HOUR;
    totalSec -= hours * SEC_PER_HOUR;
    NSInteger min = totalSec / SEC_PER_MIN;
    NSInteger sec = totalSec - min * SEC_PER_MIN;
    
    /* set the text fields */
    [secTextField setStringValue:@(sec).stringValue];
    [minTextField setStringValue:@(min).stringValue];
    [hoursTextField setStringValue:@(hours).stringValue];
    [daysTextField setStringValue:@(days).stringValue];
}

#pragma mark User Interface

- (IBAction)chooseFolderPressed:(id)sender {
    
    // Display the dialog.  If the OK button was pressed, process the files.
    if ([openDlg runModal] == NSModalResponseOK && [[openDlg URLs] count] > 0)
    {
        NSString *filename = [openDlg URLs][0].path;
        [slideshow setPath:filename];
    }
}

- (IBAction)nextImagePressed:(id)sender {
    
    if (++index == [filenames count])
        index = 0;
    
    [self refresh];
}

-(IBAction)prevImagePressed:(id)sender {
    
    if (--index < 0)
        index = [filenames count] - 1;
    
    [self refresh];
}
#pragma mark Save

-(IBAction)apply:(id)sender {
    
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"CurrentDesktop" ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *rotation = @([rotationComboBox indexOfSelectedItem]).stringValue;
    NSString *seconds = @([self getTimeInterval]).stringValue;
    NSString *random =  ([randomCheckbox state] == true)? @"true" : @"false";
    
    NSAssert(contents != NULL, @"contents can't be null...");
    
    NSString *s = [NSString stringWithFormat:contents,
                   @"", slideshow.rotation,
                   @"", slideshow.random,
                   @"", slideshow.path,
                   @"", slideshow.seconds];
    
    // execute script
    NSDictionary *errorDict;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:s];
    [scriptObject executeAndReturnError: &errorDict];
    
    NSLog(@"%@", errorDict.description);
    
    // save if no error
    if (errorDict == NULL) {
        NSLog(@"wallpapersPath: %@", slideshow.path);
        [slideshow setRandom:random];
        [slideshow setSeconds:seconds];
        [slideshow setRotation:rotation];
        [slideshow save];
    }
}

-(void)setSlideshow:(Slideshow *)slideshow1{
    slideshow = slideshow1;
    [self refresh];
}
@end