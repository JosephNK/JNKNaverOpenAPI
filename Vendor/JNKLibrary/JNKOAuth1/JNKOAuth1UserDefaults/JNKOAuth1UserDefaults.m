//
//  JNKOAuth1UserDefaults.m
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

#import "JNKOAuth1UserDefaults.h"

@implementation JNKOAuth1UserDefaults

+ (NSDictionary *)getInUserDefaultsUsingServiceProviderName:(NSString *)provider
{
    NSString *theKey = [[NSUserDefaults standardUserDefaults] stringForKey:
                        [NSString stringWithFormat:@"OAUTH_ACCESS_KEY_%@", provider]];
    NSString *theSecret = [[NSUserDefaults standardUserDefaults] stringForKey:
                           [NSString stringWithFormat:@"OAUTH_ACCESS_SECRET_%@", provider]];
    
    if (theKey == nil || theSecret == nil) {
        return nil;
    }
    
    return @{@"oauth_token": theKey, @"oauth_token_secret" : theSecret};
}

+ (void)setInUserDefaultsWithServiceProviderName:(NSString *)provider KeySecret:(NSDictionary *)keysecret
{
    NSString *oauth_token;
    NSString *oauth_token_secret;
    if (keysecret == nil) {
        oauth_token = @"";
        oauth_token_secret = @"";
    }else {
        oauth_token = [keysecret objectForKey:@"oauth_token"];
        oauth_token_secret = [keysecret objectForKey:@"oauth_token_secret"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:oauth_token
                                              forKey:[NSString stringWithFormat:@"OAUTH_ACCESS_KEY_%@", provider]];
    [[NSUserDefaults standardUserDefaults] setObject:oauth_token_secret
                                              forKey:[NSString stringWithFormat:@"OAUTH_ACCESS_SECRET_%@", provider]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setInUserDefaultsWithServiceProviderName:(NSString *)provider Key:(NSString *)key Secret:(NSString *)secret
{
    NSString *oauth_token;
    NSString *oauth_token_secret;
    if (key == nil) {
        oauth_token = @"";
    }else {
        oauth_token = key;
    }
    if (secret == nil) {
        oauth_token_secret = @"";
    }else {
        oauth_token_secret = secret;
    }
    [[NSUserDefaults standardUserDefaults] setObject:oauth_token
                                              forKey:[NSString stringWithFormat:@"OAUTH_ACCESS_KEY_%@", provider]];
    [[NSUserDefaults standardUserDefaults] setObject:oauth_token_secret
                                              forKey:[NSString stringWithFormat:@"OAUTH_ACCESS_SECRET_%@", provider]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
