//
//  JNKNaverOAuth1WebViewController.m
//
//  Copyright (c) 2014-2014 JNKNaverOpenAPI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "JNKNaverOAuth1WebViewController.h"
#import "JNKMacro.h"

#import "JNKNaverOAuth1OpenAPI.h"

@interface JNKNaverOAuth1WebViewController ()
{
    UIWebView *_webView;
    UIButton *_btnClose;
}
@end

@implementation JNKNaverOAuth1WebViewController

- (void)dealloc {
#ifdef LLOG_ENABLE
    LLog(@"<dealloc> JNKNaverOAuth1WebViewController");
#endif
    
    _delegate = nil;
    
    if (_webView) {
        JNK_RELEASE(_webView); _webView = nil;
    }
    
    if (_request) {
        JNK_RELEASE(_request); _request = nil;
    }
    if (_accessSecret) {
        JNK_RELEASE(_accessSecret); _accessSecret = nil;
    }
    if (_accessToken) {
        JNK_RELEASE(_accessToken); _accessToken = nil;
    }
    
    JNK_SUPER_DEALLOC();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initViewController:(id)delegate
                 request:(NSURLRequest *)request
             accessToken:(NSString *)accessToken
            accessSecret:(NSString *)accessSecret
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
        
#if __has_feature(objc_arc)
        _request = request;
        _accessToken = accessToken;
        _accessSecret = accessSecret;
#else
        _request = [request retain];
        _accessToken = [accessToken retain];
        _accessSecret = [accessSecret retain];
#endif
        
    }
    return self;
}

+ (id)viewController:(id)delegate
             request:(NSURLRequest *)request
         accessToken:(NSString *)accessToken
        accessSecret:(NSString *)accessSecret
{
    return JNK_AUTORELEASE([[self alloc] initViewController:delegate request:request accessToken:accessToken accessSecret:accessSecret]);
}

- (void)loadView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:screenRect];
    if (self.view == nil) {
        [super loadView]; // Try to load from NIB and fail properly, also avoiding inf. loop.
    }
    
    //self.view.backgroundColor = [UIColor darkGrayColor];
    
    //CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //_btnClose.backgroundColor = [UIColor redColor];
    [_btnClose addTarget:self action:@selector(btnClose_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnClose setTitle:@"Close" forState:UIControlStateNormal];
    _btnClose.frame = CGRectMake(10.0, statusBarHeight, 50.0, 20.0);
    [self.view addSubview:_btnClose];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_request) {
        [_webView loadRequest:_request];
    }
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - 
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
#ifdef LLOG_ENABLE
    LLog(@"request url %@", [request.URL absoluteString]);
#endif
    
    NSURL *url = [request URL];
    if ([url query].length > 0) {
#ifdef LLOG_ENABLE
        LLog(@"url query : %@", [[url query] description]);
#endif
        NSRange range = [[url query] rangeOfString:@"oauth_verifier"];
        if (range.location != NSNotFound) {
            [JNKNaverOAuth1Request requestAccessToken:nil
                                          queryString:[[url query] description]
                                          accessToken:_accessToken
                                         accessSecret:_accessSecret
                                              success:^(JNKNaverOAuth1Request *oauth1, NSURLRequest *request, NSString *accessToken, NSString *accessSecret) {
                                                  
                                                  if (_delegate
                                                      && [_delegate respondsToSelector:@selector(accessTokenDidFinishWithAccessToken:withAccessSecret:)])
                                                  {
                                                      [_delegate accessTokenDidFinishWithAccessToken:accessToken withAccessSecret:accessSecret];
                                                  }
                                                  
                                                  [self dismiss];
                                              } failure:^(JNKNaverOAuth1Request *oauth1, NSError *error) {
                                                  if (_delegate
                                                      && [_delegate respondsToSelector:@selector(accessTokenDidFailWithError:)])
                                                  {
                                                      [_delegate accessTokenDidFailWithError:error];
                                                  }
                                              }];
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -

- (void)btnClose_clicked:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

