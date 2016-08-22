//
//  CharactersTableViewController.h
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CharactersTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
- (IBAction)editTable:(UIBarButtonItem *)sender;

@end
