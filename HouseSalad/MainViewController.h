//
//  MainTVC.h
//  HouseSalad
//
//  Created by jeremy krinsley on 11/27/12.
//  Copyright (c) 2012 karen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMXMLParser.h"

@interface MainViewController : UITableViewController <KMXMLParserDelegate>
// array of headlines
@property (strong, nonatomic) NSMutableArray *parseResults;

- (void)stripHTMLFromSummary;


@end
