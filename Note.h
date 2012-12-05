//
//  Note.h
//  Lectures
//
//  Created by Martyn McWhirter on 04/12/2012.
//  Copyright (c) 2012 Martyn McWhirter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Note : NSManagedObject

@property (nonatomic, retain) id content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Subject *subject;

@end
