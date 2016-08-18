//
//  CharactersDownloader.h
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CharactersDownloader : NSObject

+ (void)downloadCharactersAndStoreWithParentContext:(NSManagedObjectContext *)parentMoc;

@end
