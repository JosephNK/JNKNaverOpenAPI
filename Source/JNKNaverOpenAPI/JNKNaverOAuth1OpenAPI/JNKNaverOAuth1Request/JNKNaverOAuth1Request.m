//
//  JNKNaverOAuth1Request.m
//
//  Copyright (c) 2014-2014 JNKNaverOAuth1OpenAPI
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

#import "JNKNaverOAuth1Request.h"
#import "JNKMacro.h"
#import "JNKOAuth1.h"
#import "JNKOAuth1Helper.h"
#import "JNKOAuth1UserDefaults.h"

/////////////////////////////////////////////////
// JNKNaverOAuth1UserDefaults
/////////////////////////////////////////////////

@interface JNKNaverOAuth1UserDefaults()
{
    
}
@end

@implementation JNKNaverOAuth1UserDefaults

- (void)dealloc {
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)getAccessTokenProviderName:(NSString *)providerName
{
    return [JNKOAuth1UserDefaults getInUserDefaultsUsingServiceProviderName:providerName];
}

+ (void)setAccessTokenProviderName:(NSString *)providerName AccessInfo:(NSDictionary *)accessInfo
{
    [JNKOAuth1UserDefaults setInUserDefaultsWithServiceProviderName:providerName
                                                          KeySecret:accessInfo];
}

+ (void)setAccessTokenProviderName:(NSString *)providerName AccessToken:(NSString *)token AccessSecret:(NSString *)secret
{
    [JNKOAuth1UserDefaults setInUserDefaultsWithServiceProviderName:providerName
                                                                Key:token
                                                             Secret:secret];
}

+ (void)resetAccessTokenProviderName:(NSString *)providerName {
    [JNKOAuth1UserDefaults setInUserDefaultsWithServiceProviderName:providerName KeySecret:nil];
}

@end

/////////////////////////////////////////////////
// JNKNaverOAuth1Request
/////////////////////////////////////////////////

@interface JNKNaverOAuth1Request()
{
    NSString *_queryString;
    NSString *_accessToken;
    NSString *_accessSecret;
}
@property (nonatomic, copy) JNKNaverOAuth1RequestSuccessHandler successHandler;
@property (nonatomic, copy) JNKNaverOAuth1RequestErrorHandler errorHandler;
@end

@implementation JNKNaverOAuth1Request

- (void)dealloc {
#ifdef LLOG_ENABLE
    LLog(@"<dealloc> JNKNaverOAuth1Request");
#endif
    
    if (_queryString) {
        JNK_RELEASE(_queryString); _queryString = nil;
    }
    if (_accessToken) {
        JNK_RELEASE(_accessToken); _accessToken = nil;
    }
    if (_accessSecret) {
        JNK_RELEASE(_accessSecret); _accessSecret = nil;
    }
    
    if (_successHandler) {
        JNK_RELEASE(_successHandler); _successHandler = nil;
    }
    if (_errorHandler) {
        JNK_RELEASE(_errorHandler); _errorHandler = nil;
    }
    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithDelegate:(id)delegate
                     queryString:(NSString *)queryString
                     accessToken:(NSString *)accessToken
                    accessSecret:(NSString *)accessSecret
                         success:(JNKNaverOAuth1RequestSuccessHandler)success
                         failure:(JNKNaverOAuth1RequestErrorHandler)failure
{
    self = [super init];
    if (self) {
#if __has_feature(objc_arc)
        _queryString = queryString;
        _accessToken = accessToken;
        _accessSecret = accessSecret;
#else
        _queryString = [queryString retain];
        _accessToken = [accessToken retain];
        _accessSecret = [accessSecret retain];
#endif
        
        _successHandler = JNK_BLOCK_COPY(success);
        _errorHandler = JNK_BLOCK_COPY(failure);
    }
    return self;
}

+ (void)requestToken:(id)delegate
             success:(JNKNaverOAuth1RequestSuccessHandler)success
             failure:(JNKNaverOAuth1RequestErrorHandler)failure
{
    
    JNKNaverOAuth1Request *oauth1Request = [[JNKNaverOAuth1Request alloc] initWithDelegate:delegate
                                                                               queryString:nil
                                                                               accessToken:nil
                                                                              accessSecret:nil
                                                                                   success:success
                                                                                   failure:failure];
    
    NSDictionary *params = @{@"mode" : NaverOpenAPIOAuthRequestToken, @"oauth_callback" : @"oob"};
    
    [JNKOAuth1 requestPOST:NaverOpenAPIOAuthUrl
                parameters:params
                      path:NaverOpenAPIOAuthRequestToken
               consumerKey:NaverOpenAPIOAuthConsumerKey
            consumerSecret:NaverOpenAPIOAuthConsumerSecret
               accessToken:nil
               tokenSecret:nil
                     realm:nil
                   success:^(JNKOAuth1 *oauth1, NSData *data) {
                       NSString *responseBody = JNK_AUTORELEASE([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#ifdef LLOG_ENABLE
                       LLog(@"responseBody Token : %@", responseBody);
#endif
                       
                       NSDictionary *info = [JNKOAuth1Helper getParametersFromQueryString:responseBody];
#ifdef LLOG_ENABLE
                       LLog(@"info : %@", [info description]);
#endif
                       NSDictionary *params = @{@"mode" : NaverOpenAPIOAuthAuthorize,
                                                @"oauth_token" : [info objectForKey:@"oauth_token"]};
                       NSURLRequest *request = [JNKOAuth1 requestPOST:NaverOpenAPIOAuthUrl
                                                           parameters:params
                                                                 path:NaverOpenAPIOAuthAuthorize
                                                          consumerKey:NaverOpenAPIOAuthConsumerKey
                                                       consumerSecret:NaverOpenAPIOAuthConsumerSecret
                                                          accessToken:[info objectForKey:@"oauth_token"]
                                                          tokenSecret:[info objectForKey:@"oauth_token_secret"]
                                                                realm:nil];
                       
                       if (oauth1Request.successHandler) {
                           NSString *accessToken = [info objectForKey:@"oauth_token"];
                           NSString *accessSecret = [info objectForKey:@"oauth_token_secret"];
                           oauth1Request.successHandler(oauth1Request, request, accessToken, accessSecret);
                       }
                       
                   } failure:^(JNKOAuth1 *oauth1, NSError *error) {
                       if (oauth1Request.errorHandler) {
                           oauth1Request.errorHandler(oauth1Request, error);
                       }
                   }];
    
    JNK_AUTORELEASE(oauth1Request);
}

+ (void)requestAccessToken:(id)delegate
               queryString:(NSString *)queryString
               accessToken:(NSString *)accessToken
              accessSecret:(NSString *)accessSecret
                   success:(JNKNaverOAuth1RequestSuccessHandler)success
                   failure:(JNKNaverOAuth1RequestErrorHandler)failure
{
    JNKNaverOAuth1Request *oauth1Request = [[JNKNaverOAuth1Request alloc] initWithDelegate:delegate
                                                                               queryString:queryString
                                                                               accessToken:accessToken
                                                                              accessSecret:accessSecret
                                                                                   success:success
                                                                                   failure:failure];
    
    NSDictionary *info = [JNKOAuth1Helper getParametersFromQueryString:queryString];
#ifdef LLOG_ENABLE
    LLog(@"info : %@", [info description]);
#endif
    
    NSDictionary *params = @{@"mode" : NaverOpenAPIOAuthAccessToken,
                             @"oauth_verifier" : [info objectForKey:@"oauth_verifier"]};
    
    [JNKOAuth1 requestPOST:NaverOpenAPIOAuthUrl
                parameters:params
                      path:NaverOpenAPIOAuthAccessToken
               consumerKey:NaverOpenAPIOAuthConsumerKey
            consumerSecret:NaverOpenAPIOAuthConsumerSecret
               accessToken:accessToken
               tokenSecret:accessSecret
                     realm:nil
                   success:^(JNKOAuth1 *oauth1, NSData *data) {
                       NSString *responseString = JNK_AUTORELEASE([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#ifdef LLOG_ENABLE
                       LLog(@"responseString Access Token : %@", responseString);
#endif
                       NSDictionary *accessInfo = [JNKOAuth1Helper getParametersFromQueryString:responseString];
                       if (oauth1Request.successHandler) {
                           NSString *accessToken = [accessInfo objectForKey:@"oauth_token"];
                           NSString *accessSecret = [accessInfo objectForKey:@"oauth_token_secret"];
                           oauth1Request.successHandler(oauth1Request, nil, accessToken, accessSecret);
                       }
                   } failure:^(JNKOAuth1 *oauth1, NSError *error) {
                       if (oauth1Request.errorHandler) {
                           oauth1Request.errorHandler(oauth1Request, error);
                       }
                   }];
    
    JNK_AUTORELEASE(oauth1Request);
}

@end

