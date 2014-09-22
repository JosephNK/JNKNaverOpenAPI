//
//  JNKNaverOAuth1Request.h
//
//  Copyright (c) 2014-2014 JNKNaverOAuth1OpenAPI
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

@interface JNKNaverOAuth1UserDefaults : NSObject
+ (NSDictionary *)getAccessTokenProviderName:(NSString *)providerName;
+ (void)setAccessTokenProviderName:(NSString *)providerName AccessInfo:(NSDictionary *)accessInfo;
+ (void)setAccessTokenProviderName:(NSString *)providerName AccessToken:(NSString *)token AccessSecret:(NSString *)secret;
+ (void)resetAccessTokenProviderName:(NSString *)providerName;
@end

@class JNKNaverOAuth1Request;
typedef void (^JNKNaverOAuth1RequestSuccessHandler)(JNKNaverOAuth1Request *oauth1, NSURLRequest *request, NSString *accessToken, NSString *accessSecret);
typedef void (^JNKNaverOAuth1RequestErrorHandler)(JNKNaverOAuth1Request *oauth1, NSError *error);

@interface JNKNaverOAuth1Request : NSObject

+ (void)requestToken:(id)delegate
             success:(JNKNaverOAuth1RequestSuccessHandler)success
             failure:(JNKNaverOAuth1RequestErrorHandler)failure;

+ (void)requestAccessToken:(id)delegate
               queryString:(NSString *)queryString
               accessToken:(NSString *)accessToken
              accessSecret:(NSString *)accessSecret
                   success:(JNKNaverOAuth1RequestSuccessHandler)success
                   failure:(JNKNaverOAuth1RequestErrorHandler)failure;

@end
