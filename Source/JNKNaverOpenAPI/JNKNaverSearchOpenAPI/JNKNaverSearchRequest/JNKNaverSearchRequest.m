//
//  JNKNaverSearchRequest.m
//
//  Copyright (c) 2014-2014 JNKNaverSearchOpenAPI
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

#import "JNKNaverSearchRequest.h"
#import "NSString+JNKURLEncode.h"
#import "JNKAsyncURLConnection.h"
#import "JNKMacro.h"

@interface JNKNaverSearchRequest()
{
    NSURL *_requestURL;
}
@property (nonatomic, copy) JNKNaverSearchRequestParserHandler parserHandler;
@property (nonatomic, copy) JNKNaverSearchRequestSuccessHandler successHandler;
@property (nonatomic, copy) JNKNaverSearchRequestErrorHandler errorHandler;
@end

@implementation JNKNaverSearchRequest

- (void)dealloc
{
#ifdef LLOG_ENABLE
    LLog(@"<dealloc> JNKNaverSearchRequest");
#endif
    
    if (_successHandler)
        JNK_BLOCK_RELEASE(_successHandler); _successHandler = nil;
        if (_errorHandler)
            JNK_BLOCK_RELEASE(_errorHandler); _errorHandler = nil;
    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setQueryObj:(id)queryObj {
    
}

#pragma mark -
#pragma mark Make URL Method

- (NSURL *)getURLRequestSearchOpenAPI:(id)queryItem InputData:(NSDictionary *)dict {
    
    NSURL *request = nil;
    
    if ([queryItem isKindOfClass:[JNKNaverSearchQueryBook class]]) {
        JNKNaverSearchQueryBook *query = (JNKNaverSearchQueryBook *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        if ([query.target isEqualToString:@"book"]) {
            request = [query getURLRequestSearchBase];
        }else if ([query.target isEqualToString:@"book_adv"]) {
            request = [query getURLRequestSearchDetail];
        }
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryCafe class]]) {
        JNKNaverSearchQueryCafe *query = (JNKNaverSearchQueryCafe *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryBlog class]]) {
        JNKNaverSearchQueryBlog *query = (JNKNaverSearchQueryBlog *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryNews class]]) {
        JNKNaverSearchQueryNews *query = (JNKNaverSearchQueryNews *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryKin class]]) {
        JNKNaverSearchQueryKin *query = (JNKNaverSearchQueryKin *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryLocal class]]) {
        JNKNaverSearchQueryLocal *query = (JNKNaverSearchQueryLocal *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryShop class]]) {
        JNKNaverSearchQueryShop *query = (JNKNaverSearchQueryShop *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryDoc class]]) {
        JNKNaverSearchQueryDoc *query = (JNKNaverSearchQueryDoc *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryAdult class]]) {
        JNKNaverSearchQueryAdult *query = (JNKNaverSearchQueryAdult *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryEncyc class]]) {
        JNKNaverSearchQueryEncyc *query = (JNKNaverSearchQueryEncyc *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryMovie class]]) {
        JNKNaverSearchQueryMovie *query = (JNKNaverSearchQueryMovie *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryWebKr class]]) {
        JNKNaverSearchQueryWebKr *query = (JNKNaverSearchQueryWebKr *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }else if ([queryItem isKindOfClass:[JNKNaverSearchQueryImage class]]) {
        JNKNaverSearchQueryImage *query = (JNKNaverSearchQueryImage *)queryItem;
        [query setFromInputDictionary:dict];
        [query checkSumDefaultParam];
        request = [query getURLRequestSearchBase];
    }
    
    return request;
}

#pragma mark -
#pragma mark Request Method

- (void)requestSearchAPI:(id)queryitem
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure
{
    if (_queryObj) {
        queryitem = _queryObj;
    }
    _requestURL = [self getURLRequestSearchOpenAPI:queryitem InputData:nil];
    
    if (_requestURL == nil) {
        NSAssert(NO, @"Request URL must not Nil");
    }
    
    _successHandler = JNK_BLOCK_COPY(success);
    _errorHandler = JNK_BLOCK_COPY(failure);
    
    [JNKAsyncURLConnection requestURL:[_requestURL absoluteString] delegate:nil
                        completeBlock:^(NSData *data) {
                            [self dispatchSuccess:data ParserBlock:parser];
                        } errorBlock:^(NSError *error) {
                            [self dispatchFailure:error];
                        }];
}

- (void)requestSearchAPI:(id)queryitem
                   QUERY:(NSString *)query
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure
{
    if (_queryObj) {
        queryitem = _queryObj;
    }
    _requestURL = [self getURLRequestSearchOpenAPI:queryitem InputData:@{DEFINE_QUERY : query}];
    
    if (_requestURL == nil) {
        NSAssert(NO, @"Request URL must not Nil");
    }
    
    _successHandler = JNK_BLOCK_COPY(success);
    _errorHandler = JNK_BLOCK_COPY(failure);
    
    [JNKAsyncURLConnection requestURL:[_requestURL absoluteString] delegate:nil
                        completeBlock:^(NSData *data) {
                            [self dispatchSuccess:data ParserBlock:parser];
                        } errorBlock:^(NSError *error) {
                            [self dispatchFailure:error];
                        }];
}

- (void)requestSearchAPI:(id)queryitem
                    ISBN:(NSString *)isbn
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure
{
    if (_queryObj) {
        queryitem = _queryObj;
    }
    if (![queryitem isKindOfClass:[JNKNaverSearchQueryBook class]]) {
        NSAssert(NO, @"Only Use JNKNaverSearchQueryBook Class");
    }
    
    _requestURL = [self getURLRequestSearchOpenAPI:queryitem InputData:@{DEFINE_ISBN : isbn}];
    
    if (_requestURL == nil) {
        NSAssert(NO, @"Request URL must not Nil");
    }
    
    _successHandler = JNK_BLOCK_COPY(success);
    _errorHandler = JNK_BLOCK_COPY(failure);
    
    [JNKAsyncURLConnection requestURL:[_requestURL absoluteString] delegate:nil
                        completeBlock:^(NSData *data) {
                            [self dispatchSuccess:data ParserBlock:parser];
                        } errorBlock:^(NSError *error) {
                            [self dispatchFailure:error];
                        }];
}

#pragma mark -
#pragma mark Dispatch Method

- (void)dispatchSuccess:(NSData *)data ParserBlock:(JNKNaverSearchRequestParserHandler)parserBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // on Background Thread
        //NSLog(@"in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
        
        id pasingData = nil;
        
        if ([data length]) {
#ifdef LLOG_ENABLE
            NSString *xml = JNK_AUTORELEASE([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            LLog(@"[GET XML]\n%@", xml);
#endif
            
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

@end
