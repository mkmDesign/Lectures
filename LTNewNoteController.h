//
//  LTNoteController.h
//  Lectures
//
//  Created by Martyn McWhirter on 23/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LTNewNoteController : NSWindowController

+(LTNewNoteController*) windowInstance;
-(NSManagedObjectContext *)managedObjectContext;

-(IBAction)confirmNewNote:(id)sender;
-(IBAction)cancelNewNote:(id)sender;

@property (weak) IBOutlet NSTextField *noteTitle;
@property (unsafe_unretained) IBOutlet NSTextView *noteContent;
@property NSAttributedString *noteContentRT;

@end
