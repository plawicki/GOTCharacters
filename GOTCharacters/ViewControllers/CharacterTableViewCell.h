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

- (void)configureForCharacter:(Character *)character;

@end
