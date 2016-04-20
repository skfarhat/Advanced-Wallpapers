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
@synthesize rotationComboBox;
@synthesize randomCheckbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init OpenDialog
    openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    
    rotationStrings = [NSArray arrayWithObjects:
                       @"Off", @"Interval", @"Login", @"Sleep", nil];
    [rotationComboBox addItemsWithObjectValues:rotationStrings];
    if ([rotationStrings count] > 0)
        [rotationComboBox selectItemAtIndex:0];

    
    // pass reference of self to app delegate
    AppDelegate *delegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    [delegate setMainViewController:self];
}

-(NSInteger) getTimeInterval {
    NSInteger days = [[daysTextField stringValue] intValue];
    NSInteger hours = [[hoursTextField stringValue] intValue] + days * 24;
    NSInteger minutes = [[minTextField stringValue] intValue] + hours * 60;
    NSInteger seconds = [[secTextField stringValue] intValue] + minutes * 60;
    return seconds;
}

/** loads previous time interval into the view's textfields
 * days, hours, seconds, minutes */
-(void)displayPreviousInterval {

    NSInteger totalSec = self.slideshow.seconds.integerValue;
    
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

#pragma mark Save
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

@end