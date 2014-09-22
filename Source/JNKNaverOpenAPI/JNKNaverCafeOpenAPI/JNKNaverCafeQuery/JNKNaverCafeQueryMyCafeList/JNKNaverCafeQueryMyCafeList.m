//
//  JNKNaverCafeQueryMyCafeList.m
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
//
//  내가 가입한 모든 카페의 목록을 제공합니다.
//  http://developer.naver.com/wiki/pages/cafeAPIspec
//

#import "JNKNaverCafeQueryMyCafeList.h"

@implementation JNKNaverCafeQueryMyCafeList

- (void)dealloc {
    if (_order) {
        JNK_RELEASE(_order); _order = nil;
    }
    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestURL = [NSURL URLWithString:@"http://openapi.naver.com/cafe/getMyCafeList.xml"];
        _page = 1;
        _perPage = 20;
        _order = @"C";
        
    }
    return self;
}

#pragma mark -
#pragma mark Helper Method

- (BOOL)checkSumDefaultParam {
    return YES;
}

- (NSDictionary *)getParams {
    [self checkSumDefaultParam];
    
    return @{@"search.page" : [NSString stringWithFormat:@"%d", _page],
             @"search.perPage" : [NSString stringWithFormat:@"%d", _perPage],
             @"order" : _order};
}


@end

