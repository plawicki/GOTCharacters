//
//  CoreDataHelper.m
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    return app.managedObjectContext;
}



@end
