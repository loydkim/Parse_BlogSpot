//
//  ViewController.h
//  Parse_BlogSpot
//
//  Created by YOUNGSIC KIM on 2017-05-26.
//  Copyright © 2017 YOUNGSIC KIM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSString *element;
    NSMutableString *content;
}

@property(strong,nonatomic) NSMutableArray *array_title;
@property(strong,nonatomic) NSMutableArray *array_contentHTML;
@property(strong,nonatomic) NSMutableArray *array_contentText;
@property(strong,nonatomic) NSMutableArray *array_images;

@end

