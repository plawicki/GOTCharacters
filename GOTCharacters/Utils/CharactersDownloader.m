//
//  CharactersDownloader.m
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CharactersDownloader.h"

@implementation CharactersDownloader

+ (void)downloadCharacters {
    NSString *urlString = @"http://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=Characters&limit=75";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"JSON: ", data);
}

@end
