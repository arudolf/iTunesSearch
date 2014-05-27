//
//  ViewController.m
//  iTunesSearch
//
//  Created by Ana Rudolf on 27/05/14.
//  Copyright (c) 2014 Ana Rudolf. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray* resultArray;

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    resultArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *string = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", [search.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSLog(@"%@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        resultArray = [responseObject objectForKey:@"results"];
        [table reloadData];
        [table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [search resignFirstResponder];
        
        if (resultArray.count == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"INFO"
                                                                message:@"There is no results!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"SearchResult";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary* itemResult = (NSDictionary*)[resultArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [itemResult objectForKey:@"artistName"], [itemResult objectForKey:@"trackName"]];
    cell.detailTextLabel.text = [itemResult objectForKey:@"kind"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[itemResult objectForKey:@"artworkUrl100"]]];
    
    return cell;
}


@end
