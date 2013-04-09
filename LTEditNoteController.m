//
//  LTEditNoteController.m
//  Lectures
//
//  Created by Martyn McWhirter on 23/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "LTEditNoteController.h"
#import "LTAppDelegate.h"
#import "Note.h"

@interface LTEditNoteController ()

@end

@implementation LTEditNoteController

- (void)windowDidLoad{
    [super windowDidLoad];
    [_editNoteTitle setStringValue:[noteToEdit title]];
    [[_editNoteContent textStorage] setAttributedString:[noteToEdit content]];
}

-(id)initWithWindowNibName:nibName{
    
    self = [super initWithWindowNibName:nibName];
    if (self) {

        appDel = ((LTAppDelegate *)[[NSApplication sharedApplication] delegate]);
        
        NSArray *notes = [[[appDel selectedSubject] notes] allObjects];
        noteToEdit = [notes objectAtIndex:[[appDel notesTableView] selectedRow]];
        
    }
    
    return self;
}

-(NSManagedObjectContext *)managedObjectContext{
    return [[NSApp delegate] managedObjectContext];
}

-(IBAction)confirmEditNote:(id)sender{
    // Get the selected note form the managedObjectContext
    Note *moNote = [[self managedObjectContext] objectWithID:[noteToEdit objectID]];
    
    [moNote setValue:[_editNoteTitle stringValue] forKey:@"title"];
    [moNote setValue:[_editNoteContent attributedString] forKey:@"content"];
    
    [NSApp endSheet:[self window]];
    [[self window] orderOut:sender];
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
    }
    
    [[appDel notesTableView] reloadData];
}

-(IBAction)cancelEditNote:(id)sender{
    // Clear text fields
    _editNoteTitle.stringValue = @"";
    _editNoteContent.string = @"";
    
    // Close window
    [NSApp endSheet:[self window]];
    [[self window] orderOut:sender];
}

@end
