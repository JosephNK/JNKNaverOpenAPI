//
//  JNKNaverCafeRequest.m
//
//  Copyright (c) 2014-2014 JNKNaverCafeOpenAPI
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

#import "JNKNaverCafeRequest.h"
#import "JNKMacro.h"
#import "JNKOAuth1.h"
#import "JNKOAuth1Helper.h"
#import "JNKOAuth1UserDefaults.h"
#import "JNKNaverCafeQuery.h"

NSString *const JNKOAuth1ErrorDomain = @"com.error.JNKNaverOAuth1";

@interface JNKNaverCafeRequest()
@property (nonatomic, copy) JNKNaverCafeRequestSuccessHandler successHandler;
@property (nonatomic, copy) JNKNaverCafeRequestErrorHandler errorHandler;
@end

@implementation JNKNaverCafeRequest

- (void)dealloc {
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

- (void)requestCafeAPI:(id)query
               parsing:(JNKNaverCafeRequestParserHandler)parser
               success:(JNKNaverCafeRequestSuccessHandler)success
               failure:(JNKNaverCafeRequestErrorHandler)failure
{
    _successHandler = JNK_BLOCK_COPY(success);
    _errorHandler = JNK_BLOCK_COPY(failure);
    
    NSDictionary *dic = [JNKOAuth1UserDefaults getInUserDefaultsUsingServiceProviderName:NaverOpenAPIOAuthProviderName];
    NSLog(@"Defaults : %@", [dic description]);
    if (dic == nil) {
        NSError *error = [self errorWithStatus:9999
                                        Reason:@"OAUTH1_ACCESS Not Found"];
        [self dispatchFailure:error];
    }else {
        NSString *requestString;
        NSDictionary *params;
        if ([query isKindOfClass:[JNKNaverCafeQueryMenuList class]]) {
            JNKNaverCafeQueryMenuList *item = (JNKNaverCafeQueryMenuList *)query;
            requestString = [item.requestURL absoluteString];
            params = [item getParams];
        }
        else if ([query isKindOfClass:[JNKNaverCafeQueryArticleList class]])
        {
            JNKNaverCafeQueryArticleList *item = (JNKNaverCafeQueryArticleList *)query;
            requestString = [item.requestURL absoluteString];
            params = [item getParams];
        }
        else if ([query isKindOfClass:[JNKNaverCafeQueryMyCafeList class]])
        {
            JNKNaverCafeQueryMyCafeList *item = (JNKNaverCafeQueryMyCafeList *)query;
            requestString = [item.requestURL absoluteString];
            params = [item getParams];
        }
        
        //NSString *requestString = @"http://openapi.naver.com/cafe/getArticleList.xml";
        //NSDictionary *params = @{@"search.clubid" : @"10660268", @"search.page" : @"1", @"search.perPage" : @"3"};
        
        [JNKOAuth1 requestGET:requestString
                   parameters:params
                         path:nil
                  consumerKey:NaverOpenAPIOAuthConsumerKey
               consumerSecret:NaverOpenAPIOAuthConsumerSecret
                  accessToken:[dic objectForKey:@"oauth_token"]
                  tokenSecret:[dic objectForKey:@"oauth_token_secret"]
                        realm:nil
                      success:^(JNKOAuth1 *oauth1, NSData *data) {
                          [self dispatchSuccess:data ParserBlock:parser];
                      } failure:^(JNKOAuth1 *oauth1, NSError *error) {
                          [self dispatchFailure:error];
                      }];
    }
}

#pragma mark -

#pragma mark -
#pragma mark Dispatch Method

- (void)dispatchSuccess:(NSData *)data ParserBlock:(JNKNaverCafeRequestParserHandler)parserBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // on Background Thread
        //NSLog(@"in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
        
        id pasingData = nil;
        
        if ([data length]) {
            NSString *xml = JNK_AUTORELEASE([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            LLog(@"[GET XML]\n%@", xml);
            
            if (parserBlock) {
                pasingData = parserBlock(self, data);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update UI on Main Thread
            if (_successHandler) {
                _successHandler(self, pasingData);
            }
        });
    });
}

- (void)dispatchFailure:(NSError *)error {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // on Background Thread
        //NSLog(@"in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
        dispatch_async(dispatch_get_main_queue(), ^{
            // update UI on Main Thread
            if (_errorHandler) {
                _errorHandler(self, error);
            }
        });
    });
}

#pragma mark -

- (NSError *)errorWithStatus:(int)errorCode Reason:(NSString *)reasonMessage {
    NSString * description = nil, * reason = nil;
    
    description = NSLocalizedString(@"ResponseData Error", @"Error description");
    reason = NSLocalizedString(reasonMessage, @"Error reason");
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject: description forKey: NSLocalizedDescriptionKey];
    
    if (reason != nil) {
        [userInfo setObject: reason forKey: NSLocalizedFailureReasonErrorKey];
    }
    
    return [NSError errorWithDomain:JNKOAuth1ErrorDomain
                               code:errorCode
                           userInfo:userInfo];
    
}


@end
