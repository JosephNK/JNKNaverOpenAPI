//
//  JNKNaverShortUrlRequest.h
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

#import <Foundation/Foundation.h>
#import "JNKNaverOpenAPIConf.h"

@class JNKNaverShortUrlRequest;
typedef id   (^JNKNaverShortUrlRequestParserHandler) (JNKNaverShortUrlRequest *request, NSData *responseData);
typedef void (^JNKNaverShortUrlRequestSuccessHandler)(JNKNaverShortUrlRequest *request, id items);
typedef void (^JNKNaverShortUrlRequestErrorHandler)  (JNKNaverShortUrlRequest *request, NSError *error);

@interface JNKNaverShortUrlRequest : NSObject

/**
 * @brief 변환 할 URL
 * @see String (필수)
 * @author
 **/
@property (nonatomic, strong) NSString *orgUrl;

/**
 * @brief XML, JSON 데이타 형식
 * @see String (필수) : xml, json
 * @author
 **/
@property (nonatomic, strong) NSString *dataType;

- (void)requestShortUrlAPI:(id)delegate
                   parsing:(JNKNaverShortUrlRequestParserHandler)parser
                   success:(JNKNaverShortUrlRequestSuccessHandler)success
                   failure:(JNKNaverShortUrlRequestErrorHandler)failure;

- (void)requestShortUrlAPI:(id)delegate
                    orgUrl:(NSString *)orgUrl
                  dataType:(NSString *)dataType
                   parsing:(JNKNaverShortUrlRequestParserHandler)parser
                   success:(JNKNaverShortUrlRequestSuccessHandler)success
                   failure:(JNKNaverShortUrlRequestErrorHandler)failure;

@end
