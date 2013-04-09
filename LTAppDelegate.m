//
//  LTAppDelegate.m
//  Lectures
//
//  Created by Martyn McWhirter on 04/12/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "LTAppDelegate.h"
#import "SidebarTableCellView.h"
#import "LTNewSubjectController.h"
#import "LTNewNoteController.h"
#import "LTEditNoteController.h"
#import "Subject.h"
#import "Note.h"

@implementation LTAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize subjectsArray;
@synthesize selectedSubject;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //  Check if the app has been launched before.  If the key 'firstLaunch' doesn't exist then it will be create and given the value of YES to indicate this is the first launch
    /*[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"firstLaunch",nil]];
    
    // Check if this is the apps first launch
    if (! [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // This is our very first launch so create a QuickNotes Subject
        Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject"
                                                            inManagedObjectContext:[self managedObjectContext]];
        
        // Set the title for the Subject
        [newSubject setValue:@"Quick Notes" forKey:@"title"];
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
        }
        
        // Setting userDefaults for next time - indicate that the app has been launched before
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }*/

    NSUserDefaults  *userSettings;
    userSettings = [NSUserDefaults standardUserDefaults];

    int launchCount = [userSettings integerForKey:@"launchCount"];
    if(launchCount == 0){
        // Set the title for the Subject
        [newSubject setValue:@"Quick Notes" forKey:@"title"];
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
        }
    }
    launchCount++;
    [userSettings setInteger: launchCount forKey:@"launchCount"];
    
    // Get all the Subjects from managedObjectContext and store them in an array
    NSFetchRequest *subjectsFetchReq = [[NSFetchRequest alloc]init];
    [subjectsFetchReq setEntity:[NSEntityDescription entityForName:@"Subject"
                                            inManagedObjectContext:self.managedObjectContext]];
    
    subjectsArray = [self.managedObjectContext executeFetchRequest:subjectsFetchReq error:nil];
    
    // These are the sections in out sidebar.  We only have one for Subjects
    _topLevelItems = [NSArray arrayWithObjects:@"SUBJECTS", nil];
    
    /* We store the data for the sidebar in a dictionary
     The key is the 'section' named SUBJECTS and the value is our array of Subjects*/
    _childrenDictionary = [NSMutableDictionary new];
    [_childrenDictionary setObject:subjectsArray forKey:@"SUBJECTS"];
    
    // The basic recipe for a sidebar
    [_sidebarOutlineView sizeLastColumnToFit];
    [_sidebarOutlineView reloadData];
    [_sidebarOutlineView setFloatsGroupRows:NO];
    
    // Sets the size of each row in the sidebar
    [_sidebarOutlineView setRowSizeStyle:NSTableViewRowSizeStyleLarge];
    
    // Expand all the root items; disable the expansion animation that normally happens
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [_sidebarOutlineView expandItem:nil expandChildren:YES];
    [NSAnimationContext endGrouping];
    
    // Automatically select first Subject in the sidebar
    [_sidebarOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];

}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "mkm.Lectures" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"mkm.Lectures"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lectures" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. 
// This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Lectures.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

/**************************************SUBJECT ADD SHIZZLE*************************************/

// Creates a new instance of LTNewSubjectController and displays its window as a sheet
-(IBAction)showNewSubjectSheet:(id)sender{
    
    newSubjectController = [LTNewSubjectController windowInstance];
    
    [NSApp beginSheet:[newSubjectController window]
       modalForWindow:[self window]
        modalDelegate:newSubjectController
       didEndSelector:NULL
          contextInfo:NULL];
    
}

-(IBAction)deleteSubject:(id)sender{
    Subject *subjectToDelete = selectedSubject;
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure you want to delete this Subject?"
                                     defaultButton:@"Delete"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"There are %ld notes linked to the subject - %@", [subjectToDelete getNoOfNotes], [subjectToDelete title]];
    
    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:@selector(alertEndedSubject:code:context:)
                        contextInfo:NULL];
}

-(void)alertEndedSubject:(NSAlert *)alert
                    code:(NSInteger)choice
                 context:(void *)v{
    if (choice == NSAlertDefaultReturn) {
        
        // Remove Subject from the managedObjectContext and the subjectsArray
        Subject *subjectToDelete = selectedSubject;
        [_managedObjectContext deleteObject:subjectToDelete];
        [subjectsArray removeObject:subjectToDelete];
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
        }
        
        [_sidebarOutlineView reloadData];
        
        // Automatically select first Subject in the sidebar
        [_sidebarOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
        
    }
}

/**********************************************END*******************************************/

/**************************************NOTE ADD SHIZZLE*************************************/

// Creates a new instance of LTNewNoteController and displays its window as a sheet
-(IBAction)showNewNoteSheet:(id)sender{
    
    newNoteController = [LTNewNoteController windowInstance];
    
    [NSApp beginSheet:[newNoteController window]
       modalForWindow:[self window]
        modalDelegate:newNoteController
       didEndSelector:NULL
          contextInfo:NULL];
    
}

-(IBAction)deleteNote:(id)sender{
    
    NSSet *notesForSubject = [selectedSubject notes];
    NSArray *notes = [notesForSubject allObjects];
    
    Note *noteToDelete = [notes objectAtIndex:[_notesTableView selectedRow]];
    
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure you want to delete this Note?"
                                     defaultButton:@"Delete"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@ created on %@", [noteToDelete title], [noteToDelete date]];
    
    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:self
                     didEndSelector:@selector(alertEndedNote:code:context:)
                        contextInfo:NULL];
}

-(void)alertEndedNote:(NSAlert *)alert code:(NSInteger)choice context:(void *)v{
    if (choice == NSAlertDefaultReturn) {
        // Delete Note from the managedObjectContext
        NSSet *notesForSubject = [selectedSubject notes];
        NSArray *notes = [notesForSubject allObjects];
        
        Note *noteToDelete = [notes objectAtIndex:[_notesTableView selectedRow]];
        [_managedObjectContext deleteObject:noteToDelete];
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error - could not save managedObjectContext - %@", error);
        }
        
        NSInteger subjectIndex = [_sidebarOutlineView rowForItem:selectedSubject];
        
        [_sidebarOutlineView reloadData];
        [_notesTableView reloadData];
        
        // Automatically select the Subject in the sidebar
        [_sidebarOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:subjectIndex] byExtendingSelection:NO];
        
    }
}

/**********************************************END********************************************/


/**************************************NOTE EDIT SHIZZLE*************************************/

// Creates a new instance of LTEditNoteController and displays its window as a sheet
-(void)rowDoubleClicked:(id)sender{
    
    editNoteController = [[LTEditNoteController alloc] initWithWindowNibName:@"EditNote"];
    
    [NSApp beginSheet:[editNoteController window]
       modalForWindow:[self window]
        modalDelegate:editNoteController
       didEndSelector:NULL
          contextInfo:NULL];
    
}

/**********************************************END********************************************/


/***************************************SIDEBAR SHIZZLE**************************************/

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    if ([_sidebarOutlineView selectedRow] != -1) {
        Subject *item = [_sidebarOutlineView itemAtRow:[_sidebarOutlineView selectedRow]];
        if ([_sidebarOutlineView parentForItem:item] != nil) {
            _subjectTitleMainView.stringValue = [item title];
            
            NSInteger subjectIndex = [_sidebarOutlineView rowForItem:item];
            selectedSubject = [subjectsArray objectAtIndex:subjectIndex-1];
            
            [_notesTableView reloadData];
            
            // Disable delete button if Quick Notes Subject is selected
            if ([[item title] isEqualToString:@"Quick Notes"]) {
                [_deleteSubjectBtn setEnabled:NO];
            }
            else{
                [_deleteSubjectBtn setEnabled:YES];
            }
            
            // Disable delete button for Notes if Subject has no Notes
            if ([selectedSubject getNoOfNotes] == 0) {
                [_deleteNoteButton setEnabled:NO];
            }
            else{
                // Specifies the double click action for the table view that displays the Notes
                [_notesTableView setTarget:self];
                [_notesTableView setDoubleAction:@selector(rowDoubleClicked:)];
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [_notesTableView selectRowIndexes:indexSet byExtendingSelection:NO];
                [_deleteNoteButton setEnabled:YES];
            }
        }
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    if ([_topLevelItems containsObject:item]) {
        return NO;
    }
    return YES;
}

- (NSArray *)_childrenForItem:(id)item {
    NSArray *children;
    if (item == nil) {
        children = _topLevelItems;
    } else {
        NSMutableArray *subjectTitles = [[NSMutableArray alloc] init];
        for (Subject *subject in subjectsArray) {
            [subjectTitles addObject:subject];
            children = subjectTitles;
        }
        
        
    }
    return children;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return [[self _childrenForItem:item] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([outlineView parentForItem:item] == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [[self _childrenForItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [_topLevelItems containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item {
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    if ([_topLevelItems containsObject:item]) {
        NSTextField *result = [outlineView makeViewWithIdentifier:@"HeaderTextField" owner:self];
        // Uppercase the string value, but don't set anything else. NSOutlineView automatically applies attributes as necessary
        NSString *value = [item uppercaseString];
        [result setStringValue:value];
        return result;
    } else  {
        // The cell is setup in IB. The textField and imageView outlets are properly setup.
        // Special attributes are automatically applied by NSTableView/NSOutlineView for the source list
        SidebarTableCellView *result = [outlineView makeViewWithIdentifier:@"MainCell" owner:self];
        result.textField.stringValue = [item title];
        // Set the icon
        if ([[item title] isEqualToString:@"Quick Notes"]) {
            result.imageView.image = [NSImage imageNamed:@"silverFolder.png"];
        }
        else{
            result.imageView.image = [NSImage imageNamed:@"glyphicons_071_book.png"];
        }
        
        // Setup the no of notes indicator to show.  Layout is done in SidebarTableCellView's viewWillDraw
        BOOL hideUnreadIndicator = NO;
        [result.button setTitle:[NSString stringWithFormat:@"%ld", [item getNoOfNotes]]];
        [result.button sizeToFit];
        // Make it appear as a normal label and not a button
        [[result.button cell] setHighlightsBy:0];
        result.button.target = self;
        result.button.action = @selector(buttonClicked:);
        [result.button setHidden:hideUnreadIndicator];
        return result;
    }
}

/**********************************************END********************************************/


/*************************************TABLE VIEW SHIZZLE*************************************/

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[selectedSubject notes] count];
}   

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSArray *notes = [[selectedSubject notes] allObjects];
    
    Note *note = [notes objectAtIndex:row];
    
    NSString *identifier = [tableColumn identifier];
    return [note valueForKey:identifier];
    
}

/**********************************************END********************************************/

@end
