//
//  Character.m
//  GOTCharacters
//
//  Created by Patryk on 16/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "Character.h"
#import "CoreDataHelper.h"

@implementation Character

static NSString* entityName = @"Character";

+ (void)insertIntoContext:(NSManagedObjectContext *)moc withName:(NSString *)name URL:(NSString *)URL imageURL:(NSString *)imgURL {
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
    
    if (character != nil) {
        character.title = name;
        character.url = URL;
        character.imageURL = imgURL;
    } else {
        NSLog(@"Failed to insert new character to managed object context");
    }
}

+ (void)parseToContext:(NSManagedObjectContext *)moc fromString:(NSString *)str {
    
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:fetchRequest
                                                            managedObjectContext:moc
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    
    return fetchedResultsController;
}

@end
