//
//  CharacterTableViewCell.m
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CharacterTableViewCell.h"

@implementation CharacterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForCharacter:(Character *)character {
    self.titleLabel.text = character.title;
    self.abstractLabel.text = character.abstract;
    self.imageView.clipsToBounds = YES;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)resizeAbstract {
    if (self.abstractLabel.numberOfLines > 0) {
        self.abstractLabel.numberOfLines = 0;
    } else {
        self.abstractLabel.numberOfLines = 2;
    }
}

@end
