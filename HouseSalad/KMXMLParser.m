//
//  KMXMLParser.m
//  KMXMLClass
//


#import "KMXMLParser.h"


@implementation KMXMLParser
@synthesize delegate;

- (id)initWithURL:(NSString *)url delegate:(id)theDelegate;
{
    self.delegate = theDelegate;
	NSURL *xmlURL = [NSURL URLWithString:url];
	[self beginParsing:xmlURL];
    
    return self;
}

-(void)beginParsing:(NSURL *)xmlURL
{
	posts = [[NSMutableArray alloc] init];
	parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
	[parser parse];
}

-(NSMutableArray *)posts
{
	return posts;
}

#pragma mark NSXMLParser Delegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [self.delegate parserDidBegin];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate parserCompletedSuccessfully];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate parserDidFailWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	element = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) 
	{
		elements = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		date = [[NSMutableString alloc] init];
		summary = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"item"]) 
	{
		[elements setObject:title forKey:@"title"];
		[elements setObject:date forKey:@"date"];
		[elements setObject:summary forKey:@"summary"];
		[elements setObject:link forKey:@"link"];
		
		[posts addObject:elements ];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([element isEqualToString:@"title"]) 
	{
		[title appendString:string];
	} 
	else if ([element isEqualToString:@"pubDate"]) 
	{
		[date appendString:string];
	} 
	else if ([element isEqualToString:@"description"]) 
	{
		[summary appendString:string];
	} 
	else if ([element isEqualToString:@"link"]) 
	{
		[link appendString:string];
	} 
}


@end
