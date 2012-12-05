//
//  LTNewSubjectController.m
//  LecturesTest
//
//  Created by Martyn McWhirter on 19/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "LTNewSubjectController.h"
#import "LTAppDelegate.h"

@interface LTNewSubjectController ()

@end

@implementation LTNewSubjectController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    appDel = ((LTAppDelegate *)[[NSApplication sharedApplication] delegate]);
}

+(LTNewSubjectController*) windowInstance{
    static LTNewSubjectController* windowInstance = nil;
    
    @synchronized(self)
	{
		if (!windowInstance){
            windowInstance = [[self alloc] initWithWindowNibName:@"NewSubject"];
        }
        
		return windowInstance;
	}
    
	return nil;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [[NSApp delegate] managedObjectContext];
}

-(IBAction)confirmNewSubject:(id)sender{
    NSString *newSubjectTitle = [_subjectTitle stringValue];
    
    if ([[_subjectTitle stringValue] isEqualToString:@""]) {
        // TODO: alert user
    }
    else{
        // Create new instance of our Subject entity and add it to the managedObjectContext
        Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject"
                                                            inManagedObjectContext:[self managedObjectContext]];
        
        // Set the title for the Subject
        [newSubject setValue:newSubjectTitle forKey:@"title"];
        
        // Clear text field
        _subjectTitle.stringValue = @"";
        
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
        }
        
        [[appDel subjectsArray] addObject:newSubject];
        [[appDel sidebarOutlineView] reloadData];
        
        // Close the sheet
        [NSApp endSheet:[self window]];
        [[self window] orderOut:sender];
        
        // Get current no of subjects
        /*NSUInteger noOfSubjects = [[self _childrenForItem:@"SUBJECT"] count];
        noOfSubjects++;*/
        
        // TODO: Select newly added Subject
        
        // Automatically select first Subject in the sidebar
        [[appDel sidebarOutlineView] selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
        
    }
}

- (IBAction)cancelNewSubject:(id)sender{
    _subjectTitle.stringValue = @"";
    [NSApp endSheet:[self window]];
    [[self window] orderOut:sender];
}

@end
