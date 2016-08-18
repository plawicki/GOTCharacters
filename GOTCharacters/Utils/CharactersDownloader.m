//
//  CharactersDownloader.m
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CharactersDownloader.h"
#import "Character.h"

@implementation CharactersDownloader

+ (void)downloadCharactersAndStoreWithParentContext:(NSManagedObjectContext *)parentMoc {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [moc setParentContext:parentMoc];
    
    NSString *urlString = @"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=Characters&limit=75";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionTask *downloadingTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:
    ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSMutableArray *jsonCharacters = json[@"items"];
        
        [moc performBlockAndWait:^(){
            if (jsonCharacters != nil && jsonCharacters.count != 0) {
                for (NSDictionary *dict in jsonCharacters) {
                    [Character insertIntoContext:moc fromJSONDictonary:dict];
                }
            }
            
            NSError *saveError;
            [moc save:&saveError];
            
            if (saveError != nil) {
                NSLog(@"Error saving context in thread");
            }
        }];
    }];
    
    [downloadingTask resume];
}

@end
