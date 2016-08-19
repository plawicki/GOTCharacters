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
    // Do any additional setup after loading the view.
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
}

@end
