//
//  JNKNaverTBXMLParser.m
//
//  Copyright (c) 2014-2014 JNKNaverTBXMLParser
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

#import "JNKNaverTBXMLParser.h"
#import "JNKMacro.h"
#import "TBXML.h"

NSString *const NaverOpenAPIParserErrorDomain = @"com.error.NaverOpenAPI-TBXMLParser";

@implementation JNKNaverTBXMLParser

- (void)dealloc
{
    JNK_SUPER_DEALLOC();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -

+ (NSDictionary *)pasingFromShortUrlData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
    LLog(@"ROOT: %@", rootString);
    
    TBXMLElement *errorcodeElement = [TBXML childElementNamed:@"error_code" parentElement:rootElement];
    if(errorcodeElement) {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }else {
        //TBXMLElement *codeElement = [TBXML childElementNamed:@"code" parentElement:rootElement];
        //TBXMLElement *messageElement = [TBXML childElementNamed:@"message" parentElement:rootElement];
        TBXMLElement *resultElement = [TBXML childElementNamed:@"result" parentElement:rootElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (resultElement) {
            do
            {
                if (resultElement->firstChild)
                {
                    NSArray *keys = @[@"hash", @"url", @"orgUrl"];
                    NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:resultElement];
                    [items addObject:dicItem];
                }
            } while ((resultElement = resultElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

#pragma mark -

+ (NSDictionary *)pasingFromArticleListData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
    LLog(@"ROOT: %@", rootString);
    
    if ([rootString isEqualToString:@"result"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *resultElement = [TBXML childElementNamed:@"result" parentElement:rootElement];
        TBXMLElement *articlesElement = [TBXML childElementNamed:@"articles" parentElement:resultElement];
        TBXMLElement *articleElement = [TBXML childElementNamed:@"article" parentElement:articlesElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (articleElement) {
            do
            {
                NSArray *keys = @[@"articleid", @"menuid", @"subject", @"nickname", @"writedate",
                                  @"newArticle", @"readCount", @"commentCount"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:articleElement];
                [items addObject:dicItem];
                
            } while ((articleElement = articleElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}


+ (NSDictionary *)pasingFromMenuListData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
    LLog(@"ROOT: %@", rootString);
    
    if ([rootString isEqualToString:@"result"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *resultElement = [TBXML childElementNamed:@"result" parentElement:rootElement];
        TBXMLElement *menusElement = [TBXML childElementNamed:@"menus" parentElement:resultElement];
        TBXMLElement *menuElement = [TBXML childElementNamed:@"menu" parentElement:menusElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (menuElement) {
            do
            {
                NSArray *keys = @[@"menuid", @"menuname", @"menuType", @"boardType", @"code", @"hasNewArticle"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:menuElement];
                [items addObject:dicItem];
                
            } while ((menuElement = menuElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromMyCafeListData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
    LLog(@"ROOT: %@", rootString);
    
    if ([rootString isEqualToString:@"result"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *resultElement = [TBXML childElementNamed:@"result" parentElement:rootElement];
        TBXMLElement *myCafesElement = [TBXML childElementNamed:@"myCafes" parentElement:resultElement];
        TBXMLElement *myCafeElement = [TBXML childElementNamed:@"myCafe" parentElement:myCafesElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (myCafeElement) {
            do
            {
                NSArray *keys = @[@"clubid", @"cluburl", @"clubname", @"articleNewCount", @"lastUpdateDate"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:myCafeElement];
                [items addObject:dicItem];
                
            } while ((myCafeElement = myCafeElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

#pragma mark -

+ (NSDictionary *)pasingFromBookData:(NSData *)data
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"image", @"author", @"price",
                                  @"discount", @"discount", @"publisher", @"isbn", @"description"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromNewsData:(NSData *)data
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"originallink", @"link", @"description", @"pubDate"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromBlogData:(NSData *)data
{
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"bloggername", @"bloggerlink"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromCafeData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"description", @"cafename", @"cafeurl"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromAdultData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"adult"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromDocData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"description"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromEncycData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"description", @"thumbnail"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromImageData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"thumbnail", @"sizeheight", @"sizewidth"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromKinData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"description"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromLocalData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"category", @"description", @"telephone",
                                  @"address", @"roadAddress", @"mapx", @"mapy"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromMovieData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"image", @"subtitle", @"pubDate",
                                  @"director", @"actor", @"userRating"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromShopData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"image", @"lprice", @"hprice",
                                  @"mallName", @"productId", @"productType"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

+ (NSDictionary *)pasingFromWebKrData:(NSData *)data {
    NSMutableDictionary *dicData = [NSMutableDictionary new];
    
    TBXML *sourceXML = [[TBXML alloc] initWithXMLData:data error:nil];
    TBXMLElement *rootElement = sourceXML.rootXMLElement;
    NSString *rootString = [TBXML elementName:rootElement];
#ifdef LLOG_ENABLE
    LLog(@"ROOT: %@", rootString);
#endif
    
    if ([rootString isEqualToString:@"error"])
    {
        NSArray *keys = @[@"message", @"error_code"];
        NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:rootElement];
        
        NSError *error = [self errorWithStatus:[[dicItem objectForKey:@"error_code"] intValue]
                                        Reason:[dicItem objectForKey:@"message"]];
        
        [dicData setObject:error forKey:@"Error"];
        [dicData setObject:[NSNull null] forKey:@"Items"];
    }
    else
    {
        TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rootElement];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
        
        NSMutableArray *items = [NSMutableArray new];
        
        if (itemElement) {
            do
            {
                NSArray *keys = @[@"title", @"link", @"description"];
                NSDictionary *dicItem = [self getDictParsingFromXML:keys parentElement:itemElement];
                [items addObject:dicItem];
                
            } while ((itemElement = itemElement->nextSibling));
        }
        
        [dicData setObject:[NSNull null] forKey:@"Error"];
        [dicData setObject:items forKey:@"Items"];
    }
    
    return dicData;
}

#pragma mark -
#pragma mark Helper

+ (NSDictionary *)getDictParsingFromXML:(NSArray *)keys parentElement:(TBXMLElement*)aParentXMLElement {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (NSString *key in keys) {
        TBXMLElement *element = [TBXML childElementNamed:key parentElement:aParentXMLElement];
        NSString *elementString = [TBXML textForElement:element];
        [dict setObject:elementString forKey:key];
    }
    
    return dict;
}

#pragma mark -
#pragma mark Error Method

+ (NSError *)errorWithStatus:(int)errorCode Reason:(NSString *)reasonMessage {
    NSString * description = nil, * reason = nil;
    
    description = NSLocalizedString(@"ResponseData Error", @"Error description");
    reason = NSLocalizedString(reasonMessage, @"Error reason");
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject: description forKey: NSLocalizedDescriptionKey];
    
    if (reason != nil) {
        [userInfo setObject: reason forKey: NSLocalizedFailureReasonErrorKey];
    }
    
    return [NSError errorWithDomain:NaverOpenAPIParserErrorDomain
                               code:errorCode
                           userInfo:userInfo];
    
}


@end
