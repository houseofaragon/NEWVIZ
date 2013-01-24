//
//  WebViewController.m
//  Reader
//

#import "WebViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize url = _url;
@synthesize webView = _webView;

- (void)initWithURL:(NSString *)postURL title:(NSString *)postTitle
{
    //self = [super init];
    //if (self) {
    
    if (_url != _url) {
        _url = postURL;
    }
    self.url = postURL;
    self.title = postTitle;
    
    //return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.url = [self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@", self.url);
    
    NSURL *newURL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//UIBarButtonItem *showVisualizationButton = [[UIBarButtonItem alloc] initWithTitle:@"Visualize" style:UIBarButtonItemStyleBordered target:self action:@selector(showVisualization:sender:)];
    //self.navigationItem.rightBarButtonItem = _showVisualizationButton;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:newURL]];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIBarButtonItem *)sender
{
    NSString *twitterSearch = self.title;
    //NSLog(@"%@", self.title);
    
    [segue.destinationViewController setTwitterSearch:twitterSearch];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.webView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}
@end
