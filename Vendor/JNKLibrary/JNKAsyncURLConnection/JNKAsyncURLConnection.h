//
//  JNKAsyncURLConnection.h
//
//  Copyright (c) 2013-2014 JNKLibrary
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

/*
 * AsyncURLConnection -request:completeBlock:errorBlock: have to be called
 * from Main Thread because it is required to use asynchronous API with RunLoop.
 
 NSString *url = @"http://download.thinkbroadband.com/5MB.zip";
 [JNKAsyncURLConnection requestURL:url delegate:nil completeBlock:^(NSData *data) {
 // success!
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 // process downloaded data in Concurrent Queue
 dispatch_async(dispatch_get_main_queue(), ^{
 // update UI on Main Thread
 });
 });
 } errorBlock:^(NSError *error) {
 // error!
 }];
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol JNKAsyncURLConnectionDelegate <NSObject>
@optional
- (void)asyncURLConnectionDidReceiveResponseWithTotalSize:(NSNumber *)total withCurrentSize:(NSNumber *)current withContentType:(NSString *)type;
@end

typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface JNKAsyncURLConnection : NSObject
{
    NSMutableData *data_;
    completeBlock_t completeBlock_;
    errorBlock_t errorBlock_;
    NSNumber *totalSize_;
    NSString *contentType;
}

@property (nonatomic, assign) id <JNKAsyncURLConnectionDelegate> delegate;
@property (nonatomic, retain) NSURLConnection *conn;
@property (nonatomic, readwrite) BOOL isNetworkActivityIndicatorVisible;

+ (id)requestURL:(NSString *)requestUrl delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithRequestURL:(NSString *)requestUrl delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

+ (id)request:(NSURLRequest *)request delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
@end
