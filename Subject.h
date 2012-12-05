//
//  Subject.h
//  Lectures
//
//  Created by Martyn McWhirter on 04/12/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * noOfNotes;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (NSInteger)getNoOfNotes;
- (void)addNotesObject:(NSManagedObject *)value;
- (void)removeNotesObject:(NSManagedObject *)value;
/*- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;*/

@end
