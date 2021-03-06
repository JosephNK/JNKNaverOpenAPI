//
//  JNKNaverSearchQueryImage.h
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
//  이미지 API로 네이버의 풍부한 이미지를 여러분과 공유합니다.
//  http://developer.naver.com/wiki/pages/SrchImage
//

#import <Foundation/Foundation.h>
#import "JNKNaverOpenAPIConf.h"

@interface JNKNaverSearchQueryImage : NSObject

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
 * @see string (필수) : image
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
 * @brief 정렬 옵션입니다.
 * @see string : sim : 유사도순 (기본값), date : 날짜순
 * @author
 **/
@property (nonatomic, strong) NSString *sort;

/**
 * @brief 사이즈에 따른 필터 옵션입니다.
 * @see all : 전체 이미지(기본값), large : 큰 이미지만 제공, medium : 중간 이미지만 제공, small : 작은 이미지만 제공
 * @author
 **/
@property (nonatomic, strong) NSString *filter;

- (NSURL *)getURLRequestSearchBase;
- (BOOL)checkSumDefaultParam;
- (void)setFromInputDictionary:(NSDictionary *)dict;

@end
