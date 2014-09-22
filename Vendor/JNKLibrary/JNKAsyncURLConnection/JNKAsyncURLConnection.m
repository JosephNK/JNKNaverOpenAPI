//
//  JNKAsyncURLConnection.m
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

#import "JNKAsyncURLConnection.h"
#import "JNKMacro.h"

@implementation JNKAsyncURLConnection

- (void)dealloc
{
    //LLog(@"<dealloc> JNKAsyncURLConnection");
    
    _delegate = nil;
    
    if (_conn) {
        JNK_RELEASE(_conn); _conn = nil;
    }
    
    if (data_) {
        JNK_RELEASE(data_); data_ = nil;
    }
    
    if (totalSize_) {
        JNK_RELEASE(totalSize_); totalSize_ = nil;
    }
    
    if (completeBlock_) {
        JNK_BLOCK_RELEASE(completeBlock_); completeBlock_ = nil;
    }
    
    if (errorBlock_) {
        JNK_BLOCK_RELEASE(errorBlock_); errorBlock_ = nil;
    }
    
    JNK_SUPER_DEALLOC();
}

+ (id)requestURL:(NSString *)requestUrl delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    return JNK_AUTORELEASE([[self alloc] initWithRequestURL:requestUrl delegate:aDelegate
                                              completeBlock:completeBlock errorBlock:errorBlock]);
}

- (id)initWithRequestURL:(NSString *)requestUrl delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
    if ((self=[super init])) {
        _isNetworkActivityIndicatorVisible = YES;
        _delegate = aDelegate;
        data_ = [[NSMutableData alloc] init];
        completeBlock_ = JNK_BLOCK_COPY(completeBlock);
        errorBlock_ = JNK_BLOCK_COPY(errorBlock);
        
        if (_isNetworkActivityIndicatorVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10.0];
        _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
    
    return self;
}

+ (id)request:(NSURLRequest *)request delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    return JNK_AUTORELEASE([[self alloc] initWithRequest:request delegate:aDelegate
                                           completeBlock:completeBlock errorBlock:errorBlock]);
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
    if ((self=[super init])) {
        _isNetworkActivityIndicatorVisible = YES;
        _delegate = aDelegate;
        data_ = [[NSMutableData alloc] init];
        completeBlock_ = JNK_BLOCK_COPY(completeBlock);
        errorBlock_ = JNK_BLOCK_COPY(errorBlock);
        
        if (_isNetworkActivityIndicatorVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
        _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    return self;
}

#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
    
    contentType = [[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Content-Type"];
    totalSize_ = [[NSNumber alloc] initWithLongLong:[response expectedContentLength]];
    
    //NSLog(@"Header \n %@", [[(NSHTTPURLResponse*)response allHeaderFields] description]);
    //NSLog(@"%@", [[(NSHTTPURLResponse*)response allHeaderFields] objectForKey:@"Content-Type"]);
    //NSLog(@"Total-length: %@ bytes", totalSize_);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [data_ appendData:data];
    
    NSNumber *currentSize = [NSNumber numberWithUnsignedInteger:[data_ length]];
    //NSLog(@"Current-length: %@ bytes", currentSize);
    if ([self.delegate respondsToSelector:@selector(asyncURLConnectionDidReceiveResponseWithTotalSize:withCurrentSize:withContentType:)]) {
        [self.delegate asyncURLConnectionDidReceiveResponseWithTotalSize:totalSize_ withCurrentSize:currentSize withContentType:contentType];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_isNetworkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    if (completeBlock_) {
        completeBlock_(data_);
    }
    
    _delegate = nil;
    
    if (_conn) {
        JNK_RELEASE(_conn); _conn = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_isNetworkActivityIndicatorVisible) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    if (errorBlock_) {
        errorBlock_(error);
    }
    
    _delegate = nil;
    
    if (_conn) {
        JNK_RELEASE(_conn); _conn = nil;
    }
}

@end
