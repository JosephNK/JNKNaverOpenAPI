//
//  JNKNaverOAuth1ViewController.m
//  JNKNaverOAuth1OpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 21..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "JNKNaverOAuth1ViewController.h"
#import "JNKARCMacro.h"

@implementation JNKNaverOAuth1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"ProviderName = %@", [[JNKNaverOAuth1UserDefaults getAccessTokenProviderName:NaverOpenAPIOAuthProviderName] description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    [JNKNaverOAuth1UserDefaults setAccessTokenProviderName:NaverOpenAPIOAuthProviderName AccessToken:accessToken AccessSecret:accessSecret];
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
