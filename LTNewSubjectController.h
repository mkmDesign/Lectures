//
//  LTNewSubjectController.h
//  LecturesTest
//
//  Created by Martyn McWhirter on 19/11/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LTAppDelegate.h"
@class LTAppDelegate;

@interface LTNewSubjectController : NSWindowController{
    LTAppDelegate *appDel;
}

+(LTNewSubjectController*) windowInstance;
-(NSManagedObjectContext *)managedObjectContext;
@property (weak) IBOutlet NSTextField *subjectTitle;
- (IBAction)confirmNewSubject:(id)sender;
- (IBAction)cancelNewSubject:(id)sender;

@end
