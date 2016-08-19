//
//  CharacterDetailsViewController.m
//  GOTCharacters
//
//  Created by Patryk on 19/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CharacterDetailsViewController.h"

@interface CharacterDetailsViewController ()

@end

@implementation CharacterDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    if (self.characterImage != nil) {
        self.imageView.image = self.characterImage;
    } else {
        self.imageView.image = [UIImage imageNamed:@"image"];
    }
    
    self.abstractLabel.text = self.character.abstract;
    
    self.titleLabel.text = self.character.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToWiki:(id)sender {
    NSString *urlToWiki = @"http://gameofthrones.wikia.com";
    NSMutableString *urlString = [NSMutableString stringWithString:self.character.url];
    
    if (urlString != nil & urlString.length != 0) {
        [urlString insertString:urlToWiki atIndex:0];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
