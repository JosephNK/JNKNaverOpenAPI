//
//  JNKNaverCafeQueryArticleList.m
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
//  특정카페의 특정게시판의 게시글 리스트를 제공합니다.
//  (통합게시판,블로그형게시판,앨범형게시판,웹진형게시판,질문답변게시판,상품등록게시판,사진게시판,그림게시판)
//  http://developer.naver.com/wiki/pages/cafeAPIspec
//

#import "JNKNaverCafeQueryArticleList.h"
#import "JNKMacro.h"

@implementation JNKNaverCafeQueryArticleList

- (void)dealloc {    
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestURL = [NSURL URLWithString:@"http://openapi.naver.com/cafe/getArticleList.xml"];
        _clubid = 0;
        _menuid = 0;
        _page = 1;
        _perPage = 15;
        
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
    
    if (_menuid != 0) {
        return @{@"search.clubid" : [NSString stringWithFormat:@"%d", _clubid],
                 @"search.menuid" : [NSString stringWithFormat:@"%d", _menuid],
                 @"search.page" : [NSString stringWithFormat:@"%d", _page],
                 @"search.perPage" : [NSString stringWithFormat:@"%d", _perPage]};
    }
    
    return @{@"search.clubid" : [NSString stringWithFormat:@"%d", _clubid],
             @"search.page" : [NSString stringWithFormat:@"%d", _page],
             @"search.perPage" : [NSString stringWithFormat:@"%d", _perPage]};
}


@end
