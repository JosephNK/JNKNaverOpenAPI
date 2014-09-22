//
//  JNKNaverShortUrlViewController.m
//  JNKNaverShortUrlOpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 22..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "JNKNaverShortUrlViewController.h"
#import "JNKNaverShortUrlOpenAPI.h"
#import "JNKNaverTBXMLParser.h"

@implementation JNKNaverShortUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -

- (IBAction)btnShoutUrl_clicked:(id)sender {
    NSString *orgUrl = _textFieldUrl.text;
    
    if (orgUrl.length <= 0) {
        return;
    }
    
    JNKNaverShortUrlRequest *api = [[JNKNaverShortUrlRequest alloc] init];
    [api requestShortUrlAPI:nil
                     orgUrl:orgUrl
                   dataType:@"xml"
                    parsing:^id(JNKNaverShortUrlRequest *request, NSData *responseData) {
                        return [JNKNaverTBXMLParser pasingFromShortUrlData:responseData];
                    } success:^(JNKNaverShortUrlRequest *request, id items) {
                        NSDictionary *dic = (NSDictionary *)items;
                        NSError *dicInfoError = [dic objectForKey:@"Error"];
                        NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                        if (dicInfoError != (NSError *)[NSNull null]) {
                            NSLog(@"error %@", [dicInfoError description]);
                        }
                        if (dicInfoArr != (NSArray *)[NSNull null]) {
                            NSLog(@"success %@", [dicInfoArr description]);
                        }
                    } failure:^(JNKNaverShortUrlRequest *request, NSError *error) {
                        NSLog(@"failure error %@", [error description]);
                    }];
}

@end
