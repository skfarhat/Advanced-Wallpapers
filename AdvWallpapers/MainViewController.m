//
//  MainViewController.m
//  AdvWallpapers
//
//  Created by Sami Farhat on 12/04/2016.
//  Copyright © 2016 Sami Farhat. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize hoursTextField, secTextField, minTextField, daysTextField;
@synthesize debugLabel, imageView, pathLabel;
@synthesize scrollText, clipView, textView;
@synthesize rotationComboBox;
@synthesize randomCheckbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init OpenDialog
    openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    
    // TODO:
    /// move these to enums or some constants that belong to Slideshow
    rotationStrings = [NSArray arrayWithObjects:
                       @"Off",
                       @"Interval",
                       @"Login",
                       @"Sleep", nil];
    index = 0;
    [rotationComboBox addItemsWithObjectValues:rotationStrings];
    if ([rotationStrings count] > 0)
        [rotationComboBox selectItemAtIndex:0];
    
    slideshow = [[Slideshow alloc] init];

    // update UI
    [self displayPreviousInterval];
    [rotationComboBox selectItemAtIndex:slideshow.getRotation];
    [randomCheckbox setState:slideshow.getRandom];
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
    NSString *imgPath = [NSString stringWithFormat:@"%@%@", wallpapersPath, filenames[index]];
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:imgPath];
    [imageView setImage:img];
}


/** debug method used as an alternative to NSLog() */
-(void) append:(NSString*)message {
    [textView setString:
     [NSString stringWithFormat:@"%@\n%@",
      textView.string, message]];
}

/** loads previous time interval into the view's textfields
 * days, hours, seconds, minutes */
-(void)displayPreviousInterval {

    NSInteger totalSec = [slideshow getSeconds];
    
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

/**
 * 1- updates filenames which is an array of png and jpg files from the given
 *     path
 * 2- update & save plist file with the last images directory path
 */
-(void) setWallpapersPath:(NSString*)newPath {
    
    if (newPath == NULL || [newPath length] == 0)
        [pathLabel setStringValue:@"Not set"];

    else
    {
        wallpapersPath = newPath;
        [pathLabel setStringValue:wallpapersPath];
        
        /* get all files from the selected directory path, then filter it leaving
         * only jpg and png files */
        filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:wallpapersPath error:nil];
        filenames = [filenames filteredArrayUsingPredicate:
                     [NSPredicate predicateWithFormat:@"(pathExtension IN %@)", @[@"jpg", @"png", @"JPG"]]];
        
        [self updateImageView];
    }
}

#pragma mark User Interface

- (IBAction)chooseFolderPressed:(id)sender {
    
    // Display the dialog.  If the OK button was pressed, process the files.
    if ([openDlg runModal] == NSModalResponseOK && [[openDlg URLs] count] > 0)
    {
        NSString *filename = [openDlg URLs][0].path;
        [self setWallpapersPath:filename];
    }
}

- (IBAction)nextImagePressed:(id)sender {
    
    if (++index == [filenames count])
        index = 0;
    
    [self updateImageView];
}

-(IBAction)prevImagePressed:(id)sender {
    
    if (--index < 0)
        index = [filenames count] - 1;
    
    [self updateImageView];
}
#pragma mark Save

/*
 // picture rotation: -- (0=off, 1=interval, 2=login, 3=sleep)
 // set random order
 // set pictures folder to file ""
 // set change interval to 5.0
 */
-(IBAction)apply:(id)sender {
    
    
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"CurrentDesktop" ofType:@"applescript"];
    NSString *contents = [NSString stringWithContentsOfFile:scriptPath encoding:
                          NSUTF8StringEncoding error:nil];
    NSString *rotation = @([rotationComboBox indexOfSelectedItem]).stringValue;
    NSString *seconds = @([self getTimeInterval]).stringValue;
    NSString *random =  ([randomCheckbox state] == true)? @"true" : @"false";
    
    NSAssert(contents != NULL, @"contents can't be null...");
    
    NSString *s = [NSString stringWithFormat:contents,
                   @"", rotation,
                   @"", random,
                   @"", wallpapersPath,
                   @"", seconds];
    
    // execute script
    NSDictionary *errorDict;
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:s];
    [scriptObject executeAndReturnError: &errorDict];
    
    NSLog(@"%@", errorDict.description);
    
    // save if no error
    if (errorDict == NULL) {
        [slideshow save:wallpapersPath random:random seconds:seconds rotation:rotation];
    }
}

@end