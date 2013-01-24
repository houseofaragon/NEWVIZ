

#import "MainViewController.h"
#import "WebViewController.h"


@implementation NSString (mycategory)

- (NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end

@implementation MainViewController
@synthesize parseResults = _parseResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationController* myNavController; myNavController.navigationBar.tintColor = [UIColor redColor]; 
    }
    return self;
}

- (void)setParseResults:(NSMutableArray *)parseResults
{
    if(_parseResults!= parseResults){
        _parseResults = parseResults;
        [self.tableView reloadData];
    }
}

- (IBAction)reloadFeed:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("feed downloader", NULL);
    dispatch_async(downloadQueue, ^{
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:@"http://www.nytimes.com/services/xml/rss/nyt/World.xml" delegate:self];
        
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
    UINavigationController* myNavController;
    myNavController.navigationBar.tintColor = [UIColor redColor];
           
    [self reloadFeed:self.navigationItem.rightBarButtonItem];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self reloadFeed:self.navigationItem.rightBarButtonItem];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)stripHTMLFromSummary {
    int i = 0;
    int count = self.parseResults.count;
    //cycles through each 'summary' element stripping HTML
    while (i < count) {
        NSString *tempString = [[self.parseResults objectAtIndex:i] objectForKey:@"summary"];
        NSString *strippedString = [tempString stringByStrippingHTML];
        NSMutableDictionary *dict = [self.parseResults objectAtIndex:i];
        [dict setObject:strippedString forKey:@"summary"];
        [self.parseResults replaceObjectAtIndex:i withObject:dict];
        i++;
    }
}


#pragma mark - Table view data source


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *url = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"link"];
    //NSString *title = [[self.parseResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    //WebViewController *vc = [performSeque;
    //[self.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor blackColor]];

    
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
#pragma mark - KMXMLParser Delegate

- (void)parserDidFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not parse feed. Check your network connection." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)parserCompletedSuccessfully {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)parserDidBegin {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
