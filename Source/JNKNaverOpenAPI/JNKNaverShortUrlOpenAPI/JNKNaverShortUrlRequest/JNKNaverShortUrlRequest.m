//
//  JNKNaverShortUrlRequest.m
//
//  Copyright (c) 2014-2014 JNKNaverShortUrlOpenAPI
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

#import "JNKNaverShortUrlRequest.h"
#import "JNKMacro.h"
#import "JNKAsyncURLConnection.h"

@interface JNKNaverShortUrlRequest()
{
    NSURL *_requestURL;
    NSString *_key;
}
@property (nonatomic, copy) JNKNaverShortUrlRequestSuccessHandler successHandler;
@property (nonatomic, copy) JNKNaverShortUrlRequestErrorHandler errorHandler;
@end

@implementation JNKNaverShortUrlRequest

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

- (void)requestShortUrlAPI:(NSString *)orgUrl
                  dataType:(NSString *)dataType
                   parsing:(JNKNaverShortUrlRequestParserHandler)parser
                   success:(JNKNaverShortUrlRequestSuccessHandler)success
                   failure:(JNKNaverShortUrlRequestErrorHandler)failure
{
    _orgUrl = orgUrl;
    _key = NaverOpenAPIShortUrlKey;
    _dataType = [dataType lowercaseString];
    
    _successHandler = JNK_BLOCK_COPY(success);
    _errorHandler = JNK_BLOCK_COPY(failure);
    
    if ([_key isEqualToString:@""]) {
        NSAssert(NO, @"Key 값 필수");
    }
    if ([_orgUrl isEqualToString:@""]) {
        NSAssert(NO, @"변환할 URL 값 필수");
    }
    
    NSString *urlString;
    if ([_dataType isEqualToString:@"xml"]) {
        urlString = [NSString stringWithFormat:@"%@?key=%@&url=%@",
                     NaverOpenAPIShortUrlXML, _key, orgUrl];
    }else if ([_dataType isEqualToString:@"json"]) {
        urlString = [NSString stringWithFormat:@"%@?key=%@&url=%@",
                     NaverOpenAPIShortUrlJSON, _key, orgUrl];
    }else {
        NSAssert(NO, @"DataType not XML, JSON");
    }
    
    _requestURL = JNK_AUTORELEASE([[NSURL alloc] initWithString:urlString]);
    
    [JNKAsyncURLConnection requestURL:[_requestURL absoluteString] delegate:nil
                        completeBlock:^(NSData *data) {
                            [self dispatchSuccess:data ParserBlock:parser];
                        } errorBlock:^(NSError *error) {
                            [self dispatchFailure:error];
                        }];
    
}

#pragma mark -
#pragma mark Dispatch Method

- (void)dispatchSuccess:(NSData *)data ParserBlock:(JNKNaverShortUrlRequestParserHandler)parserBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // on Background Thread
        //NSLog(@"in main thread?: %@", [NSThread isMainThread] ? @"YES" : @"NO");
        
        id pasingData = nil;
        
        if ([data length]) {
            NSString *str = JNK_AUTORELEASE([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            LLog(@"[GET STR]\n%@", str);
            
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
