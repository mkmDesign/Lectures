//
//  LTEditNoteController.h
//  Lectures
//
//  Created by Martyn McWhirter on 23/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LTAppDelegate;
@class Note;

@interface LTEditNoteController : NSWindowController{
    LTAppDelegate *appDel;
    Note *noteToEdit;
}

-(NSManagedObjectContext *)managedObjectContext;

-(IBAction)confirmEditNote:(id)sender;
-(IBAction)cancelEditNote:(id)sender;

@property (weak) IBOutlet NSTextField *editNoteTitle;
@property (unsafe_unretained) IBOutlet NSTextView *editNoteContent;

@end
