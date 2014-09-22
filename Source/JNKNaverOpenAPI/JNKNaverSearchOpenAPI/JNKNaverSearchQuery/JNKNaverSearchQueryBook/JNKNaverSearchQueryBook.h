//
//  JNKNaverSearchQueryBook.h
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
//
//  제목뿐만 아니라 저자, 출판사, 카테고리별 검색 등 다양한 옵션이 제공되는 책 API를 이용해 나만의 도서관을 만들어 보세요.
//  http://developer.naver.com/wiki/pages/SrchBook
//

#import <Foundation/Foundation.h>
#import "JNKNaverOpenAPIConf.h"

@interface JNKNaverSearchQueryBook : NSObject

/************************************************
 기본 검색
 ************************************************/

/**
 * @brief 이용 등록을 통해 받은 key 스트링을 입력합니다.
 * @see string (필수)
 * @author
 **/
@property (nonatomic, strong) NSString *key;

/**
 * @brief 검색을 원하는 질의, UTF-8 인코딩 입니다.
 * @see string (필수)
 * @author
 **/
@property (nonatomic, strong) NSString *query;

/**
 * @brief 서비스를 위해서는 무조건 지정해야 합니다.
 * @see string (필수) : book, book_adv
 * @author
 **/
@property (nonatomic, strong) NSString *target;

/**
 * @brief 검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다.
 * @see
 * @author
 **/
@property (nonatomic)         NSInteger display;

/**
 * @brief 검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다.
 * @see
 * @author
 **/
@property (nonatomic)         NSInteger start;


/************************************************
 상세 검색은 책 제목(d_titl), 저자명(d_auth), 목차(d_cont), ISBN(d_isbn), 출판사(d_publ) 5개 항목 중에서 1개 이상 값을 입력해야 함.
 ************************************************/

/**
 * @brief 책 제목에서의 검색을 의미합니다.
 * @see
 * @author
 **/
@property (nonatomic, strong) NSString *d_titl;

/**
 * @brief 저자명에서의 검색을 의미합니다.
 * @see
 * @author
 **/
@property (nonatomic, strong) NSString *d_auth;

/**
 * @brief 목차에서의 검색을 의미합니다.
 * @see
 * @author
 **/
@property (nonatomic, strong) NSString *d_cont;

/**
 * @brief isbn에서의 검색을 의미합니다.
 * @see
 * @author
 **/
@property (nonatomic, strong) NSString *d_isbn;

/**
 * @brief 출판사에서의 검색을 의미합니다.
 * @see
 * @author
 **/
@property (nonatomic, strong) NSString *d_publ;

/**
 * @brief 검색을 원하는 책의 출간 범위를 지정합니다. (시작일) (ex.20000203)
 * @see
 * @author
 **/
@property (nonatomic)         NSInteger d_dafr;

/**
 * @brief 검색을 원하는 책의 출간 범위를 지정합니다. (종료일) (ex.20000203)
 * @see
 * @author
 **/
@property (nonatomic)         NSInteger d_dato;

/**
 * @brief 검색을 원하는 카테고리를 지정합니다.
 * @see
 * @author
 **/
@property (nonatomic)         NSInteger d_catg;

- (NSURL *)getURLRequestSearchBase;
- (NSURL *)getURLRequestSearchDetail;
- (BOOL)checkSumDefaultParam;
- (void)setFromInputDictionary:(NSDictionary *)dict;

@end
