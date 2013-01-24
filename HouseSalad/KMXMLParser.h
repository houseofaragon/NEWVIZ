//
//  KMXMLParser.h
//  KMXMLClass
//



#import <Foundation/Foundation.h>

@protocol KMXMLParserDelegate;

@interface KMXMLParser : NSObject <NSXMLParserDelegate>{

	NSXMLParser *parser;
	NSMutableArray *posts;
	NSMutableDictionary *elements;
	NSString *element;
	NSMutableString *title;
	NSMutableString *date;
	NSMutableString *summary;
	NSMutableString *link;
    
    __weak id <KMXMLParserDelegate> delegate;
}

@property (weak, nonatomic) id <KMXMLParserDelegate> delegate;

- (id)initWithURL:(NSString *)url delegate:(id)delegate;
- (void)beginParsing:(NSURL *)xmlURL;
- (NSMutableArray *)posts;
@end

@protocol KMXMLParserDelegate <NSObject>

- (void)parserDidFailWithError:(NSError *)error;
- (void)parserCompletedSuccessfully;
- (void)parserDidBegin;

@end

