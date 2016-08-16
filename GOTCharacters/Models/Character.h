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

- (void)insertIntoContext:(NSManagedObjectContext *)moc withName:(NSString *)name withURL:(NSString *)URL withImageURL:(NSString *)imgURL;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
