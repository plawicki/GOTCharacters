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

+ (void)insertIntoContext:(NSManagedObjectContext *)moc withName:(NSString *)name URL:(NSString *)URL abstract:(NSString *)abstract imageURL:(NSString *)imgURL {
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
    
    if (character != nil) {
        character.title = name;
        character.abstract = abstract;
        character.url = URL;
        character.imageURL = imgURL;
    } else {
        NSLog(@"Failed to insert new character to managed object context");
    }
}

+ (void)insertIntoContext:(NSManagedObjectContext *)moc fromJSONDictonary:(NSDictionary *)dict {
    NSString *title = dict[@"title"];
    NSString *url = dict[@"url"];
    NSString *abstract = dict[@"abstract"];
    NSString *thumbnail = dict[@"thumbnail"];
    
    [self insertIntoContext:moc withName:title URL:url abstract:abstract imageURL:thumbnail];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)moc andFetchRequest:(NSFetchRequest *)fetchRequest {
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]
                                                            initWithFetchRequest:fetchRequest
                                                            managedObjectContext:moc
                                                            sectionNameKeyPath:nil
                                                            cacheName:nil];
    
    return fetchedResultsController;
}

+ (NSFetchRequest *)defaultFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

+ (NSPredicate *)predicateWithTitle:(NSString *)title onlyFavourites:(BOOL)onlyFavourites {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"(title contains [cd] %@)", title];
    NSPredicate *favouritesPredicate = [NSPredicate predicateWithFormat:@"(isFavourite == %@)", [NSNumber numberWithBool:YES]];
    
    if (title != nil && title.length != 0) {
        [predicates addObject:titlePredicate];
    }
    
    if (onlyFavourites) {
        [predicates addObject:favouritesPredicate];
    }
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

@end
