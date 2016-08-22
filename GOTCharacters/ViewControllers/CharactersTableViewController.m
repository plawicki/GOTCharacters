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
#import "CharacterDetailsViewController.h"

@interface CharactersTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) NSCache *images;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CharactersTableViewController

static NSString *cellIdentifier = @"CharacterTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [[NSCache alloc] init];
    
    [self initializeGestureRecognizer];
    [self initializeContextAndNotification];
    [self initializeFetchResultsControllerWithContext:self.moc];
    [self initializeSearchController];
    
    [CharactersDownloader downloadCharactersAndStoreWithParentContext:self.moc];
}

- (void)initializeSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    self.searchController.searchBar.scopeButtonTitles = @[@"All", @"Favourites"];
    self.searchController.searchBar.delegate = self;
    self.navigationController.hidesBarsWhenKeyboardAppears = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)initializeGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.delegate = self;
    longPressGestureRecognizer.delaysTouchesBegan = YES;
    [self.tableView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)initializeContextAndNotification {
    self.moc = [CoreDataHelper managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMOCNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];

}

- (void)initializeFetchResultsControllerWithContext:(NSManagedObjectContext *)moc {
    self.fetchRequest = [Character defaultFetchRequest];
    self.fetchResultsController = [Character fetchedResultsControllerWithContext: moc andFetchRequest:self.fetchRequest];
    self.fetchResultsController.delegate = self;
    [self performFetch];
}

- (void)performFetch {
    NSError *fetchError = nil;
    [self.fetchResultsController performFetch:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Error, cannot perform fetch");
    }
}

- (void)handleMOCNotification:(NSNotification *)notification {
    [[self moc] mergeChangesFromContextDidSaveNotification:notification];
    [self reloadData];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    UIImage *cellImage = [self.images objectForKey:character.title];
    
    // select cell for edit mode if character is in favs
    if (self.tableView.isEditing && [character.isFavourite boolValue]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    // downloading and setting image to cell
    if (cellImage != nil) {
        [cell setImage:cellImage];
    } else {
        [cell setImage:[UIImage imageNamed:@"Image"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:character.imageURL]];
            UIImage *image = nil;
            if (imageData != nil) {
                image = [UIImage imageWithData:imageData];
            }
            if (image != nil) {
                [self.images setObject:image forKey:character.title];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                CharacterTableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                if (updateCell != nil) {
                    [updateCell setImage:[UIImage imageWithData:imageData]];
                }
            });
        });
    }
 
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        Character *character = [self.fetchResultsController objectAtIndexPath:indexPath];
        character.isFavourite = [NSNumber numberWithBool:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        Character *character = [self.fetchResultsController objectAtIndexPath:indexPath];
        character.isFavourite = [NSNumber numberWithBool:NO];
    }
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
            UIImage *cellImage = [self.images objectForKey:character.title];
            
            [cell configureForCharacter:character];
            
            if (cellImage != nil) {
                [cell setImage:cellImage];
            }
            
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    long selectedScopeIndex = self.searchController.searchBar.selectedScopeButtonIndex;
    NSString *scope = self.searchController.searchBar.scopeButtonTitles[selectedScopeIndex];
    [self filterTableByTitle:searchText andScope:scope];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSString *searchBarText = self.searchController.searchBar.text;
    NSString *scope = self.searchController.searchBar.scopeButtonTitles[selectedScope];
    [self filterTableByTitle:searchBarText andScope:scope];
}

- (void)filterTableByTitle:(NSString *)title andScope:(NSString *)scope {
    NSString *trimmedText = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL showOnlyFavourites = NO;
        
    if ([scope isEqualToString:@"Favourites"]) {
        showOnlyFavourites = YES;
    }
        
    NSPredicate *searchPredicate = [Character predicateWithTitle:trimmedText onlyFavourites:showOnlyFavourites];
    self.fetchRequest.predicate = searchPredicate;
    
    [self performFetch];
    [self reloadData];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (indexPath == nil) {
        return;
    } else if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CharacterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell resizeAbstract];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"DetailsSegue"]) {
        Character *character = [self getClickedCharacter];
        CharacterDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.character = character;
        UIImage *characterImage = [self.images objectForKey:character.title];
        if (characterImage != nil) {
            destinationVC.characterImage = characterImage;
        }
    }
}

- (Character *)getClickedCharacter {
    Character *character = [self.fetchResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    return character;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.tableView.isEditing;
}

#pragma mark - Actions

- (IBAction)editTable:(UIBarButtonItem *)sender {
    if (self.tableView.isEditing) {
        sender.title = @"Edit Favourites";
        [self reloadData];
        [self.tableView setEditing:NO animated:YES];
        
        
    } else {
        sender.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
        
        // we have to refresh cells to be selected if character is in favs
        [self reloadData];
    }
}

@end
