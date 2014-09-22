//
//  JNKOAuth1.m
//
//  Copyright (c) 2013-2014 JNKLibrary
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

#import <CommonCrypto/CommonHMAC.h>
#include "JNKBase64Transcoder.h"
#import "JNKOAuth1.h"
#import "JNKMacro.h"
#import "NSString+JNKOAuth1Encoding.h"
#import "JNKAsyncURLConnection.h"

static inline NSString * getNonce() {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
#if __has_feature(objc_arc)
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
#else
    NSString *uuidStr = (NSString *)CFUUIDCreateString(NULL, uuid);
#endif
    CFRelease(uuid);
    return uuidStr;
}

static inline NSString * getTimestamp() {
    return [NSString stringWithFormat:@"%ld", time(NULL)];
}

static inline NSString * URLStringWithoutQuery(NSURL *url) {
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    return [parts objectAtIndex:0];
}

@interface JNKOAuth1()
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *signature_secret;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *realm;
@property (nonatomic, strong) NSDictionary *oauthBaseParams;
@property (nonatomic, strong) NSMutableDictionary *oauthExtraParams;
@property (nonatomic, strong) NSString *http_method;
@property (nonatomic, copy) JNKOAuth1SuccessHandler successHandler;
@property (nonatomic, copy) JNKOAuth1ErrorHandler errorHandler;
@end

@implementation JNKOAuth1

- (void)dealloc {
#ifdef DEBUG_LOG
    NSLog(@"<dealloc> JNKOAuth1");
#endif
    
    if (_path) {
        JNK_RELEASE(_path); _path = nil;
    }
    if (_realm) {
        JNK_RELEASE(_realm); _realm = nil;
    }
    if (_http_method) {
        JNK_RELEASE(_http_method); _http_method = nil;
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

- (id)initWithBaseURL:(NSString *)baseURL
          consumerKey:(NSString *)consumerKey
       consumerSecret:(NSString *)consumerSecret
          accessToken:(NSString *)accessToken
          tokenSecret:(NSString *)tokenSecret
                realm:(NSString *)realm
{
    self = [super init];
    if (self) {
        
        if (consumerKey == nil || [consumerKey isEqualToString:@""]) {
            NSAssert(NO, @"Consumer Key 없습니다.");
        }
        
        if (consumerSecret == nil || [consumerSecret isEqualToString:@""]) {
            NSAssert(NO, @"Consumer Secret 없습니다.");
        }
        
        accessToken = accessToken ? accessToken : @"";
        tokenSecret = tokenSecret ? tokenSecret : @"";
        realm = realm ? realm : @"";
        
        _baseURL = [NSURL URLWithString:baseURL];
        _oauthExtraParams = [NSMutableDictionary dictionary];
        _http_method = @"GET";
        _oauthBaseParams = [NSDictionary dictionaryWithObjectsAndKeys:
                            consumerKey,     @"oauth_consumer_key",
                            getNonce(),      @"oauth_nonce",
                            getTimestamp(),  @"oauth_timestamp",
                            @"1.0",          @"oauth_version",
                            @"HMAC-SHA1",    @"oauth_signature_method",
                            accessToken,     @"oauth_token",
                            nil];
        
        _signature_secret = [NSString stringWithFormat:@"%@&%@",
                             consumerSecret.URLEncodedString, tokenSecret.URLEncodedString ?: @""];

        
        _realm = realm;
    }
    return self;
}

+ (void)requestGET:(NSString *)urlString
        parameters:(NSDictionary *)unencodedParameters
              path:(NSString *)unencodedPathWithoutQuery
       consumerKey:(NSString *)consumerKey
    consumerSecret:(NSString *)consumerSecret
       accessToken:(NSString *)accessToken
       tokenSecret:(NSString *)tokenSecret
             realm:(NSString *)realm
           success:(JNKOAuth1SuccessHandler)success
           failure:(JNKOAuth1ErrorHandler)failure
{
    
    JNKOAuth1 *oauth1 = [[JNKOAuth1 alloc] initWithBaseURL:urlString
                                               consumerKey:consumerKey
                                            consumerSecret:consumerSecret
                                               accessToken:accessToken
                                               tokenSecret:tokenSecret
                                                     realm:realm];
    
    oauth1.successHandler = JNK_BLOCK_COPY(success);
    oauth1.errorHandler = JNK_BLOCK_COPY(failure);
    oauth1.http_method = @"GET";
    oauth1.path = unencodedPathWithoutQuery;
    
    NSString *requestString = [NSString stringWithFormat:@"%@", urlString];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [oauth1 request:requestURL Parameters:unencodedParameters];
    
#ifdef DEBUG_LOG
    NSLog(@"request URL : %@", [request.URL description]);
    NSLog(@"allHTTPHeaderFields : %@", [request allHTTPHeaderFields]);
#endif
    
    [JNKAsyncURLConnection request:request delegate:nil completeBlock:^(NSData *data) {
        // success!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            dispatch_async(dispatch_get_main_queue(), ^{
                if (oauth1.successHandler) {
                    oauth1.successHandler(oauth1, data);
                }
            });
        });
    } errorBlock:^(NSError *error) {
        // error!
        if (oauth1.errorHandler) {
            oauth1.errorHandler(oauth1, error);
        }
    }];
    
    JNK_AUTORELEASE(oauth1);
}

+ (void)requestPOST:(NSString *)urlString
         parameters:(NSDictionary *)unencodedParameters
               path:(NSString *)unencodedPathWithoutQuery
        consumerKey:(NSString *)consumerKey
     consumerSecret:(NSString *)consumerSecret
        accessToken:(NSString *)accessToken
        tokenSecret:(NSString *)tokenSecret
              realm:(NSString *)realm
            success:(JNKOAuth1SuccessHandler)success
            failure:(JNKOAuth1ErrorHandler)failure
{
    JNKOAuth1 *oauth1 = [[JNKOAuth1 alloc] initWithBaseURL:urlString
                                               consumerKey:consumerKey
                                            consumerSecret:consumerSecret
                                               accessToken:accessToken
                                               tokenSecret:tokenSecret
                                                     realm:realm];
    
    oauth1.successHandler = JNK_BLOCK_COPY(success);
    oauth1.errorHandler = JNK_BLOCK_COPY(failure);
    oauth1.http_method = @"POST";
    oauth1.path = unencodedPathWithoutQuery;
    
    NSString *requestString = [NSString stringWithFormat:@"%@", urlString];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [oauth1 request:requestURL Parameters:unencodedParameters];
    
#ifdef DEBUG_LOG
    NSLog(@"allHTTPHeaderFields : %@", [request allHTTPHeaderFields]);
#endif
    
    [JNKAsyncURLConnection request:request delegate:nil completeBlock:^(NSData *data) {
        // success!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (oauth1.successHandler) {
                    oauth1.successHandler(oauth1, data);
                }
            });
        });
    } errorBlock:^(NSError *error) {
        // error!
        if (oauth1.errorHandler) {
            oauth1.errorHandler(oauth1, error);
        }
    }];
}

+ (NSURLRequest *)requestGET:(NSString *)urlString
                  parameters:(NSDictionary *)unencodedParameters
                        path:(NSString *)unencodedPathWithoutQuery
                 consumerKey:(NSString *)consumerKey
              consumerSecret:(NSString *)consumerSecret
                 accessToken:(NSString *)accessToken
                 tokenSecret:(NSString *)tokenSecret
                       realm:(NSString *)realm
{
    JNKOAuth1 *oauth1 = [[JNKOAuth1 alloc] initWithBaseURL:urlString
                                               consumerKey:consumerKey
                                            consumerSecret:consumerSecret
                                               accessToken:accessToken
                                               tokenSecret:tokenSecret
                                                     realm:realm];
    oauth1.http_method = @"GET";
    oauth1.path = unencodedPathWithoutQuery;
    
    NSString *requestString = [NSString stringWithFormat:@"%@", urlString];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [oauth1 request:requestURL Parameters:unencodedParameters];
    
    return request;
}

+ (NSURLRequest *)requestPOST:(NSString *)urlString
                   parameters:(NSDictionary *)unencodedParameters
                         path:(NSString *)unencodedPathWithoutQuery
                  consumerKey:(NSString *)consumerKey
               consumerSecret:(NSString *)consumerSecret
                  accessToken:(NSString *)accessToken
                  tokenSecret:(NSString *)tokenSecret
                        realm:(NSString *)realm
{
    JNKOAuth1 *oauth1 = [[JNKOAuth1 alloc] initWithBaseURL:urlString
                                               consumerKey:consumerKey
                                            consumerSecret:consumerSecret
                                               accessToken:accessToken
                                               tokenSecret:tokenSecret
                                                     realm:realm];
    oauth1.http_method = @"POST";
    oauth1.path = unencodedPathWithoutQuery;
    
    NSString *requestString = [NSString stringWithFormat:@"%@", urlString];
    NSURL *requestURL = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [oauth1 request:requestURL Parameters:unencodedParameters];
    
#ifdef DEBUG_LOG
    NSLog(@"allHTTPHeaderFields : %@", [request allHTTPHeaderFields]);
#endif
    
    return request;
}

#pragma mark -
#pragma mark Extra Parameter

- (id)setParameters:(NSDictionary *)unencodedParameters {
    if (!unencodedParameters.count)
        return nil;
    
    NSMutableArray *parameterPairs = [NSMutableArray array];
    
    NSArray *keys = [[unencodedParameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys)
    {
        [parameterPairs addObject:[NSString URLEncodedPairWithKey:key withValue:unencodedParameters[key]]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *encodedParametersQueryString = [sortedPairs componentsJoinedByString:@"&"];

    return encodedParametersQueryString;
}

#pragma mark -
#pragma mark Request

- (NSMutableURLRequest *)request:(NSURL *)url Parameters:(NSDictionary *)unencodedParameters {
    NSString *encodedParameterPairs = [self setParameters:unencodedParameters];
    //if (_path) {
        [_oauthExtraParams addEntriesFromDictionary:unencodedParameters];
    //}
    
    NSMutableURLRequest *rq = [NSMutableURLRequest requestWithURL:url
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                  timeoutInterval:10.0];
    
    [rq setHTTPMethod:_http_method];
    [rq setHTTPShouldHandleCookies:NO];
    
    [rq setValue:[self authorizationHeader] forHTTPHeaderField:@"Authorization"];
    
    [self appendRequest:rq Parameters:encodedParameterPairs];
    
    return rq;
}

- (void)appendRequest:(NSMutableURLRequest *)request Parameters:(NSString *)encodedParameterPairs {
    if ([[request HTTPMethod] isEqualToString:@"GET"] || [[request HTTPMethod] isEqualToString:@"DELETE"]) {
        // GET, DELETE
        NSString *urlString;
        if (encodedParameterPairs) {
            urlString = [NSString stringWithFormat:@"%@?%@",
                         URLStringWithoutQuery(self.baseURL), encodedParameterPairs];
        }else {
            urlString = [NSString stringWithFormat:@"%@",
                         URLStringWithoutQuery(self.baseURL)];
        }
        [request setURL:[NSURL URLWithString:urlString]];
    }else {
        // POST, PUT
        NSData *postData = [encodedParameterPairs dataUsingEncoding:NSASCIIStringEncoding
                                               allowLossyConversion:YES];
        [request setHTTPBody:postData];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}

- (NSString *)authorizationHeader {
    NSMutableDictionary *sigParams = [_oauthBaseParams mutableCopy];
    [sigParams addEntriesFromDictionary:_oauthExtraParams];
#ifdef DEBUG_LOG
    NSLog(@"sigParams : %@", [sigParams description]);
#endif
    
    if (![_realm isEqualToString:@""]) {
        [sigParams setObject:_realm forKey:@"realm"];
    }
    
    NSMutableString *header = [NSMutableString string];
    [header appendString:@"OAuth "];
    
    for (NSString *key in sigParams.allKeys)
    {
        if ([key isEqualToString:@"oauth_token"]) {
            if ([(NSString *)sigParams[key] isEqualToString:@""]) {
                continue;
            }
        }
        
        [header appendString:key.URLEncodedString];
        [header appendString:@"=\""];
        [header appendString:((NSString *)sigParams[key]).URLEncodedString];
        [header appendString:@"\", "];
    }
    [header appendString:@"oauth_signature=\""];
    [header appendString:[self signatureBaseString].URLEncodedString];
    [header appendString:@"\""];
    
    return header;
}

#pragma mark -
#pragma mark Signature Base String

- (NSString *)signatureBaseString {
    NSMutableDictionary *sigParams = [_oauthBaseParams mutableCopy];
    [sigParams addEntriesFromDictionary:_oauthExtraParams];
    
    // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
    NSMutableArray *parameterPairs = [NSMutableArray array];
    NSArray *keys = [[sigParams allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys)
    {
        if ([key isEqualToString:@"oauth_token"]) {
            if ([(NSString *)sigParams[key] isEqualToString:@""]) {
                continue;
            }
        }

        [parameterPairs addObject:[NSString URLEncodedPairWithKey:key withValue:sigParams[key]]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedParameters = [sortedPairs componentsJoinedByString:@"&"];
    
    // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
    NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
                     _http_method,
                     URLStringWithoutQuery(_baseURL).URLEncodedString,
                     normalizedParameters.URLEncodedString];
#ifdef DEBUG_LOG
    NSLog(@"Signature String : %@", ret);
#endif
    
    NSString *signature = [self signClearText:ret withSecret:_signature_secret];
    
    //NSLog(@"Signature : %@", signature);
    
    return signature;
}

- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret
{
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    //Base64 Encoding
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return base64EncodedResult;
}


@end
