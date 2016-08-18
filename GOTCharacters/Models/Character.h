//
//  Character.h
//  GOTCharacters
//
//  Created by Patryk on 16/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSManagedObject

+ (void)insertIntoContext:(NSManagedObjectContext *)moc withName:(NSString *)name URL:(NSString *)URL abstract:(NSString *)abstract imageURL:(NSString *)imgURL;
+ (void)insertIntoContext:(NSManagedObjectContext *)moc fromJSONDictonary:(NSDictionary *)dict;
+ (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)moc;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
