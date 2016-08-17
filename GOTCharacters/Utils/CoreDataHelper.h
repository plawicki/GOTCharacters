//
//  CoreDataHelper.h
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

+ (NSManagedObjectContext *)managedObjectContext;

@end
