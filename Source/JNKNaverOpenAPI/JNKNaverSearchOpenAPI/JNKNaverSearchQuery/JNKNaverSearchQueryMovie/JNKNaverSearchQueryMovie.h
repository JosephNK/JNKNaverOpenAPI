//
//  JNKNaverSearchQueryMovie.h
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
//  영화API를 이용하여 다양한 영화의 정보를 편리하게 여러분의 웹사이트에 추가해 보세요.
//  http://developer.naver.com/wiki/pages/SrchMovie
//

#import <Foundation/Foundation.h>
#import "JNKNaverOpenAPIConf.h"

@interface JNKNaverSearchQueryMovie : NSObject

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
 * @brief 서비스를 위해서는 무조건 지정해야 합니다. (필수)
 * @see string (필수) : movie
 * @author
 **/
@property (nonatomic, strong) NSString *target;

/**
 * @brief 검색을 원하는 질의, UTF-8 인코딩 입니다. (필수)
 * @see string (필수)
 * @author
 **/
@property (nonatomic, strong) NSString *query;

/**
 * @brief 검색결과 출력건수를 지정합니다. 최대 100까지 가능합니다.
 * @see integer : 기본값 10, 최대 100
 * @author
 **/
@property (nonatomic)         NSInteger display;

/**
 * @brief 검색의 시작위치를 지정할 수 있습니다. 최대 1000까지 가능합니다.
 * @see integer : 기본값 1, 최대 1000
 * @author
 **/
@property (nonatomic)         NSInteger start;

/**
 * @brief 검색을 원하는 장르 코드를 의미합니다. 영화 코드는 다음과 같습니다.
 * @see  1 : 드라마       2 : 판타지
         3 : 서부        4 : 공포
         5 : 로맨스       6 : 모험
         7 : 스릴러       8 : 느와르
         9 : 컬트        10 : 다큐멘터리
         11 : 코미디      12 : 가족
         13 : 미스터리    14 : 전쟁
         15 : 애니메이션	16 : 범죄
         17 : 뮤지컬      18 : SF
         19 : 액션       20 : 무협
         21 : 에로       22 : 서스펜스
         23 : 서사       24 : 블랙코미디
         25 : 실험       26 : 영화카툰
         27 : 영화음악    28 : 영화패러디포스터
 * @author
 **/
@property (nonatomic, strong) NSString *genre;

/**
 * @brief 검색을 원하는 국가 코드를 의미합니다. 국가코드는 대문자만 사용가능하며, 분류는 다음과 같습니다.
 * @see 한국 (KR), 일본 (JP), 미국 (US), 홍콩 (HK), 영국 (GB), 프랑스 (FR), 기타 (ETC)
 * @author
 **/
@property (nonatomic, strong) NSString *country;

/**
 * @brief 검색을 원하는 영화의 제작년도(최소)를 의미합니다.
 * @see integer(ex : 2000) yearfrom은 yearto와 함께 사용되어야 합니다.
 * @author
 **/
@property (nonatomic) NSInteger yearfrom;

/**
 * @brief 검색을 원하는 영화의 제작년도(최대)를 의미합니다.
 * @see integer(ex : 2008) yearto는 yearfrom과 함께 사용되어야 합니다.
 * @author
 **/
@property (nonatomic) NSInteger yearto;

- (NSURL *)getURLRequestSearchBase;
- (BOOL)checkSumDefaultParam;
- (void)setFromInputDictionary:(NSDictionary *)dict;

@end
