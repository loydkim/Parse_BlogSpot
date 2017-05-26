//
//  ViewController.m
//  Parse_BlogSpot
//
//  Created by YOUNGSIC KIM on 2017-05-26.
//  Copyright © 2017 YOUNGSIC KIM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startParsing];
    
}

-(void)startParsing {
    content = [[NSMutableString alloc]init];
    
    _array_title = [[NSMutableArray alloc]init];
    _array_contentHTML = [[NSMutableArray alloc]init];
    _array_contentText = [[NSMutableArray alloc]init];
    _array_images = [[NSMutableArray alloc]init];
    
    // Change your blog address.
    // For example : http://YOURBLOGADDRESS.blogspot.com/feeds/posts/default
    NSURL *url = [NSURL URLWithString:@"http://devloydkimparsing.blogspot.com/feeds/posts/default"];
    parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark parse delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"Start blogspot parsing!!");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    element = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([element isEqualToString:@"title"]) {
        [_array_title addObject:string];
    }else if([element isEqualToString:@"content"]){
        [content appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    if(![content isEqualToString:@""]) {
        [_array_contentHTML addObject:content];
        content = [NSMutableString stringWithString:@""];
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    for(NSString* maincontent in _array_contentHTML) {
        //Get plain text from html text.
        NSScanner *myScanner;
        NSString *html = maincontent;
        NSString *text = nil;
        myScanner = [NSScanner scannerWithString:html];
        
        while ([myScanner isAtEnd] == NO) {
            [myScanner scanUpToString:@"<" intoString:NULL];
            [myScanner scanUpToString:@">" intoString:&text];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
        
        html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        html = [html stringByReplacingOccurrencesOfString:@"-&gt;" withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        
        // Add content Text to content array
        [_array_contentText addObject:html];
        
        //Get image thumbnail address from the post content.
        NSString *htmlString = maincontent;
        NSMutableString *imageLink = [[NSMutableString alloc]init];
        NSScanner *scanner = [[NSScanner alloc]initWithString:htmlString];
        
        [scanner scanUpToString:@"https://" intoString:nil];
        if([htmlString containsString:@".jpg"]) {
            [scanner scanUpToString:@"\" imageanchor=" intoString:&imageLink];
        }else {
            [scanner scanUpToString:@"\" style=" intoString:&imageLink];
        }
        
        // Add thumbnail image address to array
        [_array_images addObject:imageLink];
    }
    
    // Remove the title 0 position number. because that was parsed twice.
    [_array_title removeObjectAtIndex:0];
    
    // Check the parse result.
    
    NSLog(@"array title list is %@",_array_title);
    NSLog(@"array content text list is %@",_array_contentText);
    NSLog(@"array image list is %@",_array_images);
    NSLog(@"array content html list is %@",_array_contentHTML);
}



@end
