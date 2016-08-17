//
//  CharacterTableViewCell.h
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@interface CharacterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

- (void)configureForCharacter:(Character *)character;
- (void)setImage:(UIImage *)image;

@end
