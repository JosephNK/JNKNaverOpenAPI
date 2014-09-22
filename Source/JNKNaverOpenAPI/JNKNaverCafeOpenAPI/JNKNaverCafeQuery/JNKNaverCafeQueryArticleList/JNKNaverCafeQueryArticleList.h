//
//  JNKNaverCafeQueryArticleList.h
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

#import <Foundation/Foundation.h>

@interface JNKNaverCafeQueryArticleList : NSObject

@property (nonatomic, strong, readonly) NSURL *requestURL;

/**
 * @brief 카페 번호
 * @see Integer (필수)
 * @author
 **/
@property (nonatomic) NSInteger clubid;

/**
 * @brief 메뉴 ID(최신 글 보기시 필요없음)
 * @see Integer
 * @author
 **/
@property (nonatomic) NSInteger menuid;

/**
 * @brief 페이지
 * @see Integer
 * @author
 **/
@property (nonatomic) NSInteger page;

/**
 * @brief 페이지 개수 default : 15
 * @see Integer
 * @author
 **/
@property (nonatomic) NSInteger perPage;

- (NSDictionary *)getParams;

@end
