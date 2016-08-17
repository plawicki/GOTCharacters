//
//  CharactersTableViewController.m
//  GOTCharacters
//
//  Created by Patryk on 17/08/16.
//  Copyright © 2016 Patryk. All rights reserved.
//

#import "CharactersTableViewController.h"
#import "CoreDataHelper.h"
#import "Character.h"
#import "CharacterTableViewCell.h"
#import "CharactersDownloader.h"

@interface CharactersTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) NSCache *images;

@end

@implementation CharactersTableViewController

static NSString *cellIdentifier = @"CharacterTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeFetchResultsController];
    
    NSError *fetchError = nil;
    [self.fetchResultsController performFetch:&fetchError];
    
    [CharactersDownloader downloadCharacters];
}

- (void)initializeFetchResultsController {
    NSManagedObjectContext *moc = [CoreDataHelper managedObjectContext];
    self.fetchResultsController = [Character fetchedResultsControllerWithContext: moc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Character *character = [self.fetchResultsController objectAtIndexPath:indexPath];
    [cell configureForCharacter:character];
 
    return cell;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            Character *character = [self.fetchResultsController objectAtIndexPath:indexPath];
            CharacterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            [cell configureForCharacter:character];
            
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
