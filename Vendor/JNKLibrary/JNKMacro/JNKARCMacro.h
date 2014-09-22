//
//  JNKARCMacros.h
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

//  http://raptureinvenice.com/arc-support-without-branches/
//  http://iosdeveloperzone.com/2013/05/24/snippet-macros-for-arc-agnostic-code/


#if !__has_feature(objc_arc)
#define JNK_PROP_RETAIN retain
#define JNK_RETAIN(x) ([(x) retain])
#define JNK_RELEASE(x) ([(x) release])
#define JNK_AUTORELEASE(x) ([(x) autorelease])
#define JNK_BLOCK_COPY(x) (Block_copy(x))
#define JNK_BLOCK_RELEASE(x) (Block_release(x))
#define JNK_SUPER_DEALLOC() ([super dealloc])
#define JNK_BRIDGE_CAST(_type, _identifier) ((_type)(_identifier))
#define JNK_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define JNK_AUTORELEASE_POOL_END() [pool release];
#else
#define JNK_PROP_RETAIN strong
#define JNK_RETAIN(x) (x)
#define JNK_RELEASE(x)
#define JNK_AUTORELEASE(x) (x)
#define JNK_BLOCK_COPY(x) (x)
#define JNK_BLOCK_RELEASE(x)
#define JNK_SUPER_DEALLOC()
#define JNK_BRIDGE_CAST(_type, _identifier) ((__bridge _type)(_identifier))
#define JNK_AUTORELEASE_POOL_START() @autoreleasepool {
#define JNK_AUTORELEASE_POOL_END() }
#endif
