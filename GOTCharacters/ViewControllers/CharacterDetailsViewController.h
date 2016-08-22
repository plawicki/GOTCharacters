//
//  CharacterDetailsViewController.h
//  GOTCharacters
//
//  Created by Patryk on 19/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@interface CharacterDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;

@property (weak, nonatomic) Character *character;
@property (weak, nonatomic) UIImage *characterImage;

- (IBAction)goToWiki:(id)sender;

@end
