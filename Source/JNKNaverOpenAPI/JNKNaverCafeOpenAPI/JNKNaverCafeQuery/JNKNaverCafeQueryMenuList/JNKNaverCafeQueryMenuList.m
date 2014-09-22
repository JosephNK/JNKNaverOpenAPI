//
//  JNKNaverCafeQueryMenuList.m
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
//  특정 카페의 게시판 목록을 제공합니다.
//  http://developer.naver.com/wiki/pages/cafeAPIspec
//

#import "JNKNaverCafeQueryMenuList.h"
#import "JNKMacro.h"

@implementation JNKNaverCafeQueryMenuList

- (void)dealloc {    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestURL = [NSURL URLWithString:@"http://openapi.naver.com/cafe/getMenuList.xml"];
        _clubid = 0;
        _page = 1;
        _perPage = 20;
        
    }
    return self;
}

#pragma mark -
#pragma mark Helper Method

- (BOOL)checkSumDefaultParam {
    if (_clubid == 0) {
        NSAssert(NO, @"카페 번호 필수값");
    }
    
    return YES;
}

- (NSDictionary *)getParams {
    [self checkSumDefaultParam];
    
    return @{@"clubid" : [NSString stringWithFormat:@"%d", _clubid],
             @"search.page" : [NSString stringWithFormat:@"%d", _page],
             @"search.perPage" : [NSString stringWithFormat:@"%d", _perPage]};
}

@end
