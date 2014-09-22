//
//  JNKNaverCafeViewController.m
//  JNKNaverCafeOpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 21..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "JNKNaverCafeViewController.h"
#import "JNKMacro.h"
#import "JNKNaverTBXMLParser.h"
#import "UIAlertView+JNKError.h"
#import "JNKNaverCafeOpenAPI.h"

@implementation JNKNaverCafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"ProviderName = %@", [[JNKNaverOAuth1UserDefaults getAccessTokenProviderName:NaverOpenAPIOAuthProviderName] description]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Naver Cafe API Test

- (IBAction)btnNaverCafeGetArticleList_clicked:(id)sender
{
    JNKNaverCafeQueryArticleList *query = [[JNKNaverCafeQueryArticleList alloc] init];
    query.clubid = 10660268;
    query.page = 1;
    query.perPage = 2;
    JNKNaverCafeRequest *api = [[JNKNaverCafeRequest alloc] init];
    [api requestCafeAPI:query
                parsing:^id(JNKNaverCafeRequest *request, NSData *responseData) {
                    return [JNKNaverTBXMLParser pasingFromArticleListData:responseData];
                } success:^(JNKNaverCafeRequest *request, id items) {
                    NSDictionary *dic = (NSDictionary *)items;
                    NSError *dicInfoError = [dic objectForKey:@"Error"];
                    NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                    if (dicInfoError != (NSError *)[NSNull null]) {
                        [UIAlertView showAlertError:dicInfoError];
                    }
                    if (dicInfoArr != (NSArray *)[NSNull null]) {
                        NSLog(@"success %@", [dicInfoArr description]);
                    }
                } failure:^(JNKNaverCafeRequest *request, NSError *error) {
                    NSLog(@"error : %@", [error description]);
                }];
}

- (IBAction)btnNaverCafeGetMenuList_clicked:(id)sender
{
    JNKNaverCafeQueryMenuList *query = [[JNKNaverCafeQueryMenuList alloc] init];
    query.clubid = 10660268;
    query.page = 1;
    query.perPage = 3;
    JNKNaverCafeRequest *api = [[JNKNaverCafeRequest alloc] init];
    [api requestCafeAPI:query
                parsing:^id(JNKNaverCafeRequest *request, NSData *responseData) {
                    return [JNKNaverTBXMLParser pasingFromMenuListData:responseData];
                } success:^(JNKNaverCafeRequest *request, id items) {
                    NSDictionary *dic = (NSDictionary *)items;
                    NSError *dicInfoError = [dic objectForKey:@"Error"];
                    NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                    if (dicInfoError != (NSError *)[NSNull null]) {
                        [UIAlertView showAlertError:dicInfoError];
                    }
                    if (dicInfoArr != (NSArray *)[NSNull null]) {
                        NSLog(@"success %@", [dicInfoArr description]);
                    }
                } failure:^(JNKNaverCafeRequest *request, NSError *error) {
                    NSLog(@"error : %@", [error description]);
                }];
}

- (IBAction)btnNaverCafeGetMyCafeList_clicked:(id)sender
{
    JNKNaverCafeQueryMyCafeList *query = [[JNKNaverCafeQueryMyCafeList alloc] init];
    query.page = 1;
    query.perPage = 2;
    query.order = @"U";
    JNKNaverCafeRequest *api = [[JNKNaverCafeRequest alloc] init];
    [api requestCafeAPI:query
                parsing:^id(JNKNaverCafeRequest *request, NSData *responseData) {
                    return [JNKNaverTBXMLParser pasingFromMyCafeListData:responseData];
                } success:^(JNKNaverCafeRequest *request, id items) {
                    NSDictionary *dic = (NSDictionary *)items;
                    NSError *dicInfoError = [dic objectForKey:@"Error"];
                    NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                    if (dicInfoError != (NSError *)[NSNull null]) {
                        [UIAlertView showAlertError:dicInfoError];
                    }
                    if (dicInfoArr != (NSArray *)[NSNull null]) {
                        NSLog(@"success %@", [dicInfoArr description]);
                    }
                } failure:^(JNKNaverCafeRequest *request, NSError *error) {
                    NSLog(@"error : %@", [error description]);
                }];
}

#pragma mark -
#pragma mark Naver OAuth 1.0 Request Token Action

- (IBAction)btnNaverOAuth1_clicked:(id)sender {
    [JNKNaverOAuth1Request requestToken:nil success:^(JNKNaverOAuth1Request *oauth1, NSURLRequest *request, NSString *accessToken, NSString *accessSecret) {
        JNKNaverOAuth1WebViewController *controller = [JNKNaverOAuth1WebViewController
                                                       viewController:self
                                                       request:request
                                                       accessToken:accessToken
                                                       accessSecret:accessSecret];
        [self presentViewController:controller animated:YES completion:nil];
    } failure:^(JNKNaverOAuth1Request *oauth1, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RequestToken Error"
                                                       message:[error description]
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        
        JNK_RELEASE(alert);
    }];
}

#pragma mark -
#pragma mark JNKNaverOAuth1WebViewController Delegate

- (void)accessTokenDidFinishWithAccessToken:(NSString *)accessToken withAccessSecret:(NSString *)accessSecret
{
    [JNKNaverOAuth1UserDefaults setAccessTokenProviderName:NaverOpenAPIOAuthProviderName
                                               AccessToken:accessToken
                                              AccessSecret:accessSecret];
}

- (void)accessTokenDidFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"AccessToken Error"
                                                   message:[error description]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
    JNK_RELEASE(alert);
}


@end
