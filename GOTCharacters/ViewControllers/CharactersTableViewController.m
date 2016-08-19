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
@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) NSCache *images;

@end

@implementation CharactersTableViewController

static NSString *cellIdentifier = @"CharacterTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [[NSCache alloc] init];
    
    self.moc = [CoreDataHelper managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NSManagedObjectContextDidSaveNotification object:self.moc];
    [self initializeFetchResultsControllerWithContext:self.moc];
    
    NSError *fetchError = nil;
    [self.fetchResultsController performFetch:&fetchError];
    
    if (fetchError != nil) {
        NSLog(@"Error, cannot perform fetch");
    }
    
    [CharactersDownloader downloadCharactersAndStoreWithParentContext:self.moc];
}

- (void)initializeFetchResultsControllerWithContext:(NSManagedObjectContext *)moc {
    self.fetchResultsController = [Character fetchedResultsControllerWithContext: moc];
    self.fetchResultsController.delegate = self;
}

- (void)reloadData {
    [self.tableView reloadData];
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
    UIImage *cellImage = [self.images objectForKey:character.title];

    if (cellImage != nil) {
        [cell setImage:cellImage];
    } else {
        [cell setImage:[UIImage imageNamed:@"image"]];
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
                    updateCell.imageView.image = [UIImage imageWithData:imageData];
                }
            });
        });
    }
 
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"DetailsSegue"]) {
        Character *character = [self getClickedCharacter];
        CharacterDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.character = character;
//        UIImage *characterImage = [self.images valueForKey:character.title];
//        if (characterImage != nil) {
//            destinationVC.characterImage = characterImage;
//        }
    }
}

- (Character *)getClickedCharacter {
    Character *character = [self.fetchResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    return character;
}


@end
