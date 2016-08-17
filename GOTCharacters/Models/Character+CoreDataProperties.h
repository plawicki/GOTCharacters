//
//  Character+CoreDataProperties.h
//  GOTCharacters
//
//  Created by Patryk on 16/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface Character (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *abstract;

@end

NS_ASSUME_NONNULL_END
