//
//  WebViewController.h
//  HouseSalad
//
//  Created by jeremy krinsley on 11/27/12.
//  Copyright (c) 2012 karen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)initWithURL:(NSString *)postURL title:(NSString *)postTitle;



@end
