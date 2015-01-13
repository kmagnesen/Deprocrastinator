//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Matthew Bradshaw on 1/12/15.
//  Copyright (c) 2015 Matthew Bradshaw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *entryTextField;
@property (strong, nonatomic) IBOutlet UITableView *entryTableView;

@property NSMutableArray *userEntryArray;

@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.userEntryArray = [NSMutableArray arrayWithObjects: nil];
    self.userEntryArray = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", nil];

}

- (IBAction)onAddButtonPressed:(UIButton *)sender {

    NSString *myUserEntry = self.entryTextField.text;
    [self.userEntryArray addObject:myUserEntry];

//    NSLog(@"my user entry %@", myUserEntry);
//    NSLog(@"self.userEntries.count %lu", (unsigned long)self.userEntries.count);

    self.entryTextField.text = @"";
    [self.entryTextField resignFirstResponder];
    [self.entryTableView reloadData];
}

#pragma mark OnEdit

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *titleItem = [self.userEntryArray objectAtIndex:sourceIndexPath.row];
    [self.userEntryArray removeObject:titleItem];
    [self.userEntryArray insertObject:titleItem atIndex:destinationIndexPath.row];
    [self.entryTableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.indexPathToBeDeleted = indexPath;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERT!" message:@"Are You Sure You Would Like To Delete Entry?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];

    [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.userEntryArray removeObjectAtIndex:self.indexPathToBeDeleted.row];
        [self.entryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [UIView transitionWithView:self.entryTableView
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self.entryTableView reloadData];}
                        completion:NULL];
    }
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {

    if (self.entryTableView.editing) {
        self.editing = false;
        [self.entryTableView setEditing:NO animated:YES];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    } else {
        self.editing = true;
        [self.entryTableView setEditing:YES animated:YES];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
        [sender setTitle:@"Done"];
    }

    [self.entryTableView reloadData];
}

#pragma mark SwipeGestures

- (IBAction)onSwipeRight:(UISwipeGestureRecognizer *)sender {
    CGPoint location  = [sender locationInView:self.entryTableView];
    NSIndexPath *indexPath = [self.entryTableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell = [self.entryTableView cellForRowAtIndexPath:indexPath];

    if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
        swipedCell.textLabel.textColor = [UIColor redColor];
        [self.entryTableView reloadData];

    } else if (swipedCell.textLabel.textColor == [UIColor redColor]){
        swipedCell.textLabel.textColor = [UIColor yellowColor];
        [self.entryTableView reloadData];

    } else if (swipedCell.textLabel.textColor == [UIColor yellowColor]) {
        swipedCell.textLabel.textColor = [UIColor greenColor];
        [self.entryTableView reloadData];

    } else if (swipedCell.textLabel.textColor == [UIColor greenColor]) {
        swipedCell.textLabel.textColor = [UIColor blackColor];
        [self.entryTableView reloadData];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userEntryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCellID"];
    cell.textLabel.text = [self.userEntryArray objectAtIndex:indexPath.row];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor greenColor];
    [self.entryTableView reloadData];

}


@end
