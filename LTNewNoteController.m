//
//  LTNoteController.m
//  Lectures
//
//  Created by Martyn McWhirter on 23/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "LTNewNoteController.h"
#import "LTAppDelegate.h"
#import "Note.h"

@interface LTNewNoteController ()

@end

@implementation LTNewNoteController

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

+(LTNewNoteController*) windowInstance{
    static LTNewNoteController* windowInstance = nil;
    
    @synchronized(self)
	{
		if (!windowInstance){
            windowInstance = [[self alloc] initWithWindowNibName:@"NewNote"];
        }
        
		return windowInstance;
	}
    
	return nil;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [[NSApp delegate] managedObjectContext];
}

-(IBAction)confirmNewNote:(id)sender{
    LTAppDelegate *appDel = ((LTAppDelegate *)[[NSApplication sharedApplication] delegate]);
    
    // Create new instance of our Note entity and add it to the managedObjectContext
    Note *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
     inManagedObjectContext:[self managedObjectContext]];
     
    // Set title for the new Note
    [newNote setValue:[_noteTitle stringValue] forKey:@"title"];
     
    // Set the date
    NSDate *currentDate = [NSDate date];
    [newNote setValue:currentDate forKey:@"date"];
    
    // Add the content of the note to the Note object
    [newNote setValue:[_noteContent attributedString] forKey:@"content"];
     
    // Add the new note to the Set for the subject
    [[appDel selectedSubject] addNotesObject:newNote];
     
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
    }
     
    // Clear text fields
    _noteTitle.stringValue = @"";
    _noteContent.string = @"";
     
    // Close the sheet
    [NSApp endSheet:[self window]];
    [[self window] orderOut:sender];

    NSInteger subjectIndex = [[appDel sidebarOutlineView] rowForItem:[appDel selectedSubject]];
    
    [[appDel sidebarOutlineView] reloadData];
    [[appDel notesTableView] reloadData];
     
    // Automatically select the Subject in the sidebar
    [[appDel sidebarOutlineView] selectRowIndexes:[NSIndexSet indexSetWithIndex:subjectIndex] byExtendingSelection:NO];
    
}

-(IBAction)cancelNewNote:(id)sender{
    // Clear text fields
    _noteTitle.stringValue = @"";
    _noteContent.string = @"";
    
    [NSApp endSheet:[self window]];
    [[self window] orderOut:sender];
}

@end
