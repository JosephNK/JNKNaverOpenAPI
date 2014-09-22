//
//  JNKNaverSearchQueryDoc.m
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

#import "JNKNaverSearchQueryDoc.h"
#import "NSString+JNKURLEncode.h"
#import "JNKMacro.h"

@implementation JNKNaverSearchQueryDoc

- (void)dealloc
{
#ifdef LLOG_ENABLE
    LLog(@"<dealloc> JNKNaverSearchQueryDoc");
#endif
    
    if (_key) {
        JNK_RELEASE(_key); _key = nil;
    }
    if (_query) {
        JNK_RELEASE(_query); _query = nil;
    }
    if (_target) {
        JNK_RELEASE(_target); _target = nil;
    }
    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key = NaverOpenAPISearchKey;
        _query = nil;
        _target = @"doc";
        _display = 10;
        _start = 1;
    }
    return self;
}

#pragma mark -
#pragma mark Make URL Method

- (NSString *)getURLRequestBase {
    return [NSString stringWithFormat:@"%@?key=%@", NaverOpenAPISearchUrl, _key];
}

- (NSURL *)getURLRequestSearchBase {
    NSMutableString *strRequestURL = [NSMutableString stringWithString:[self getURLRequestBase]];
    
    if (_query) {
        [strRequestURL appendFormat:@"&query=%@",
         [NSString URLEncodeWithUnEncodedString:_query withEncoding:NSUTF8StringEncoding]];
    }
    if (_target) {
        [strRequestURL appendFormat:@"&target=%@", _target];
    }
    if (_display) {
        [strRequestURL appendFormat:@"&display=%ld", (long)_display];
    }
    if (_start) {
        [strRequestURL appendFormat:@"&start=%ld", (long)_start];
    }

#ifdef LLOG_ENABLE
    LLog(@"StringRequestURL : %@", strRequestURL);
#endif
    
    //NSString *escaped = [strRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return JNK_AUTORELEASE([[NSURL alloc] initWithString:strRequestURL]);
}

#pragma mark -
#pragma mark Helper Method

- (BOOL)checkSumDefaultParam {
    if (_key == nil || [_key isEqualToString:@""]) {
        NSAssert(NO, @"Key 필수값");
    }
    
    if (_query == nil || [_query isEqualToString:@""]) {
        NSAssert(NO, @"Query 필수값");
    }
    
    if (_target == nil || [_target isEqualToString:@""]) {
        NSAssert(NO, @"Target 필수값");
    }
    
    if (!(_display >= 10 && _display <= 100)) {
        NSAssert(NO, @"Display : 기본값 10, 최대값 : 100");
    }
    
    if (!(_start >= 1 && _start <= 1000)) {
        NSAssert(NO, @"Start : 기본값 1, 최대값 : 1000");
    }
    
    return YES;
}

- (void)setFromInputDictionary:(NSDictionary *)dict {
    if (dict != nil) {
        NSString *qry = [dict objectForKey:DEFINE_QUERY];
        if (qry != nil) {
            _query = qry;
        }
    }
}

@end
