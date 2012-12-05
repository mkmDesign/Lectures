//
//  Subject.m
//  Lectures
//
//  Created by Martyn McWhirter on 04/12/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import "Subject.h"
#import "Note.h"

@implementation Subject

@dynamic title;
@dynamic noOfNotes;
@dynamic notes;

- (void)addNotesObject:(Note *)value{
    
    NSSet *set = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"notes"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:set];
    [[self primitiveValueForKey:@"notes"] addObject:value];
    [self didChangeValueForKey:@"notes"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:set];
}

- (void)removeNotesObject:(Note *)value{
    
    NSSet *set = [NSSet setWithObject:value];
    [self willChangeValueForKey:@"notes"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:set];
    [[self primitiveValueForKey:@"notes"] removeObject:value];
    [self didChangeValueForKey:@"notes"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:set];
}

- (NSInteger)getNoOfNotes{
    return [[self notes] count];
}

@end
