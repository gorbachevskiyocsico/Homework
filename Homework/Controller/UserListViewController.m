//
//  UserListViewController.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "UserListViewController.h"
#import "NetworkManager.h"
#import "DataProvider.h"
#import "UsersListTableViewCell.h"
#import "MapViewController.h"

@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray <User *>*users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.users = [NSMutableArray new];
    [self checkIfNeedUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading Data

- (void)loadUsersWithArray:(NSArray<User *>*)users {
    
    self.users = [users mutableCopy];
    [self.tableView reloadData];
}

- (void)checkIfNeedUpdate {
    
    NSArray *users = [[DataProvider sharedInstance] getUsers];
    
    if (users.count < 1) {
        
        [self downloadUsersFromServer];
    } else {
        
        [self loadUsersWithArray:users];
    }
}

- (void)downloadUsersFromServer {
    
    [[NetworkManager sharedInstance] getUsersListWithSuccess:^(NSArray *responseArray) {
        
        for (NSDictionary *userDict in responseArray) {
                
            [[DataProvider sharedInstance] saveUserFromDict:userDict];
        }
        
        [[DataProvider sharedInstance] saveUsersListDownloadTime];
        
        [self loadUsersWithArray:[[DataProvider sharedInstance] getUsers]];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self downloadUsersFromServer];
        });
        
        NSLog(@"%@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"UsersListTableViewCell";
    
    UsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        
        cell = [[UsersListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.user = [self.users objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.users.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:kFromUserListToMapViewSegueIdentifier sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kFromUserListToMapViewSegueIdentifier]) {
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            
            NSIndexPath *indexPath = sender;
            
            MapViewController *vc = segue.destinationViewController;
            
            User *user = [self.users objectAtIndex:indexPath.row];
            
            vc.userid = user.userid;
        }
    }
}

@end
