//
//  LTAppDelegate.h
//  Lectures
//
//  Created by Martyn McWhirter on 04/12/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Subject.h"
@class LTNewSubjectController;
@class LTNewNoteController;
@class LTEditNoteController;

@interface LTAppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource, NSMenuDelegate, NSTableViewDelegate, NSTableViewDataSource>{
    IBOutlet NSWindow *newNoteSheet;
    IBOutlet NSWindow *newEditSheet;
    LTNewSubjectController *newSubjectController;
    LTNewNoteController *newNoteController;
    LTEditNoteController *editNoteController;
}

// Sidebar specific
@property Subject *selectedSubject;
@property (assign)IBOutlet NSOutlineView *sidebarOutlineView;
@property NSArray *topLevelItems;
@property NSViewController *currentContentViewController;
@property NSMutableDictionary *childrenDictionary;

// Subjects shizzle
@property (weak) IBOutlet NSButton *addSubjectBtn;
@property (weak) IBOutlet NSButton *deleteSubjectBtn;
@property (readwrite, strong, nonatomic) NSMutableArray *subjectsArray;
-(IBAction)showNewSubjectSheet:(id)sender;
-(IBAction)deleteSubject:(id)sender;

// Notes shizzle
@property (weak) IBOutlet NSTableView *notesTableView;
@property (weak) IBOutlet NSButton *deleteNoteButton;
-(IBAction)showNewNoteSheet:(id)sender;
-(IBAction)deleteNote:(id)sender;
-(void)rowDoubleClicked:(id)sender;

// Various
@property NSString *hasBeenLaunched;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *subjectTitleMainView;
@property (weak) IBOutlet NSImageView *bgImageView;
@property (weak) IBOutlet NSImageView *imageTest;
-(IBAction)saveAction:(id)sender;

// Managed Object Shizzle
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
