//
//  MainView2ControllerViewController.m
//  HouseSalad
//
//  Created by Karen Aragon on 1/23/13.
//  Copyright (c) 2013 karen. All rights reserved.
//

#import "MainView2ControllerViewController.h"
#import "WebViewController.h"

@interface MainView2ControllerViewController ()

@end

@implementation MainView2ControllerViewController
@synthesize parseResults = _parseResults;



- (IBAction)reloadFeed:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("feed downloader", NULL);
    dispatch_async(downloadQueue, ^{
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://feeds.foxnews.com/foxnews/latest" delegate:self];
        
        //NSArray *topPlaces = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            _parseResults = [parser posts];
            [self stripHTMLFromSummary];
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Sets the navigation bar title
    //self.title = @"NEWVIZ";
    //Set table row height so it can fit title & 2 lines of summary
    self.tableView.rowHeight = 90;    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor blackColor]];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.parseResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShowPost";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Check if cell is nil. If it is create a new instance of it
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure titleLabel
    cell.textLabel.text = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.numberOfLines = 2;
    //Configure detailTitleLabel
    cell.detailTextLabel.text = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"summary"];
    
    cell.detailTextLabel.numberOfLines = 2;
    
    //Set accessoryType
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *url = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"link"];
    //NSString *title = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    //WebViewController *vc = [performSeque;
    //[self.navigationController pushViewController:vc animated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIBarButtonItem *)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *url = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"link"];
    NSString *title = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    //NSLog(@"%@", title);
    //WebViewController *vc = [segue destinationViewController];

    [segue.destinationViewController initWithURL:url title:title];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
