JNKNaverOpenAPI
==============

네이버 오픈 API(Naver Open API)를 iOS에서 보다 쉽게 사용할 수 있게 하기 위해 공유 하고자 합니다.

http://developer.naver.com/wiki/pages/OpenAPI

## Setup

* `JNKNaverOpenAPI(Search)`
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPISearchKey : `[이용 등록을 통해 받은 key]` 설정
* `JNKNaverOpenAPI(OAuth1)`
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPIOAuthConsumerKey : `[컨슈머 key]` 설정
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPIOAuthConsumerSecret : `[컨슈머 Secret]` 설정
* `JNKNaverOpenAPI(Cafe)`
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPIOAuthConsumerKey : `[컨슈머 key]` 설정
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPIOAuthConsumerSecret : `[컨슈머 Secret]` 설정
* `JNKNaverOpenAPI(ShortUrl)`
  - `JNKNaverOpenAPIConf.h`::NaverOpenAPIShortUrlKey : `[이용 등록을 통해 받은 key]` 설정

## Use TBXML
- Use TBXML :  http://www.tbxml.co.uk/TBXML/TBXML_Free.html 참고.
- Use not TBXML : `TBXML`, `JNKNaverTBXMLParser` 폴더 삭제.

## Architecture

### Search API

#### JNKNaverSearchQuery 종류

* `JNKNaverSearchQuery`
  - `JNKNaverSearchQueryAdult` (성인 검색어 판별)
  - `JNKNaverSearchQueryBlog`  (블로그)
  - `JNKNaverSearchQueryBook`  (책)
  - `JNKNaverSearchQueryCafe`  (카페글)
  - `JNKNaverSearchQueryDoc`   (전문자료)
  - `JNKNaverSearchQueryEncyc` (백과사전)
  - `JNKNaverSearchQueryImage` (이미지)
  - `JNKNaverSearchQueryKin`   (지식인)
  - `JNKNaverSearchQueryLocal` (지역)
  - `JNKNaverSearchQueryMovie` (영화)
  - `JNKNaverSearchQueryNews`  (뉴스)
  - `JNKNaverSearchQueryShop`  (쇼핑)
  - `JNKNaverSearchQueryWebKr` (오타변환)

#### JNKNaverSearch Request 종류

```objective-c
- (void)requestSearchAPI:(id)queryitem
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure;
```

```objective-c
- (void)requestSearchAPI:(id)queryitem
                   QUERY:(NSString *)query
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure;
```

```objective-c
- (void)requestSearchAPI:(id)queryitem
                    ISBN:(NSString *)isbn
                 parsing:(JNKNaverSearchRequestParserHandler)parser
                 success:(JNKNaverSearchRequestSuccessHandler)success
                 failure:(JNKNaverSearchRequestErrorHandler)failure;
```

### OAuth1.0 API

#### JNKNaverOAuth1 Request 종류

```objective-c
+ (void)requestToken:(id)delegate
             success:(JNKNaverOAuth1RequestSuccessHandler)success
             failure:(JNKNaverOAuth1RequestErrorHandler)failure;
```

```objective-c
+ (void)requestAccessToken:(id)delegate
               queryString:(NSString *)queryString
               accessToken:(NSString *)accessToken
              accessSecret:(NSString *)accessSecret
                   success:(JNKNaverOAuth1RequestSuccessHandler)success
                   failure:(JNKNaverOAuth1RequestErrorHandler)failure;
```

#### JNKNaverWebViewController Protocol

```objective-c
- (void)accessTokenDidFinishWithAccessToken:(NSString *)accessToken 
                           withAccessSecret:(NSString *)accessSecret;
- (void)accessTokenDidFailWithError:(NSError *)error;
```

### Cafe API

#### JNKNaverCafeQuery 종류

* `JNKNaverCafeQuery`
  - `JNKNaverCafeQueryArticleList` (게시판 글 목록보기)
  - `JNKNaverCafeQueryMenuList` (게시판 목록)
  - `JNKNaverCafeQueryMyCafeList` (내 카페 목록)

#### JNKNaverCafe Request 종류

```objective-c
- (void)requestCafeAPI:(id)query
               parsing:(JNKNaverCafeRequestParserHandler)parser
               success:(JNKNaverCafeRequestSuccessHandler)success
               failure:(JNKNaverCafeRequestErrorHandler)failure;
```

### ShortUrl API

#### JNKNaverShortUrl Request 종류

```objective-c
- (void)requestShortUrlAPI:(NSString *)orgUrl
                  dataType:(NSString *)dataType
                   parsing:(JNKNaverShortUrlRequestParserHandler)parser
                   success:(JNKNaverShortUrlRequestSuccessHandler)success
                   failure:(JNKNaverShortUrlRequestErrorHandler)failure;
```

## Usage

#### JNKNaverSearchRequest 예제 (블로그)

```objective-c
#import "JNKNaverSearchOpenAPI.h"

JNKNaverSearchQueryBlog *query = [[JNKNaverSearchQueryBlog alloc] init];
JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
[api requestSearchAPI:query QUERY:@"리뷰"
              parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                  // parsing (on Background Thread)
                  // return id (ResponseData로부터 파싱한 후 파싱 데이터 리턴)
              } success:^(JNKNaverSearchRequest *request, id items) {
                  // success (on Main Thread)
                  // id items : parsing Block에서 리턴된 값
              } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                  // failure (on Main Thread)
              }];
```

#### JNKNaverOAuth1Request 예제 

```objective-c
[YourViewControllor.h]

#import "JNKNaverOAuth1WebViewController.h"
#import "JNKNaverOAuth1OpenAPI.h"

@interface YourViewControllor : UIViewController <JNKNaverOAuth1WebViewControllerDelegate>
@end
```

```objective-c
[YourViewControllor.m]

@implementation YourViewControllor

#pragma mark -
#pragma mark Naver OAuth 1.0 Request Token Action

- (void)naverOAuth1Action {
  [JNKNaverOAuth1Request requestToken:nil success:^(JNKNaverOAuth1Request *oauth1, NSURLRequest *request, NSString *accessToken, NSString *accessSecret) {
        JNKNaverOAuth1WebViewController *controller = [JNKNaverOAuth1WebViewController
                                                       viewController:self
                                                       request:request
                                                       accessToken:accessToken
                                                       accessSecret:accessSecret];
        [self presentViewController:controller animated:YES completion:nil];
    } failure:^(JNKNaverOAuth1Request *oauth1, NSError *error) {
        NSLog(@"error : %@", [error description]);
    }];
}

#pragma mark -
#pragma mark JNKNaverOAuth1WebViewController Delegate

- (void)accessTokenDidFinishWithAccessToken:(NSString *)accessToken withAccessSecret:(NSString *)accessSecret
{
    // Save AccessToken
    [JNKNaverOAuth1UserDefaults setAccessTokenProviderName:ProviderName AccessToken:accessToken AccessSecret:accessSecret];
}

- (void)accessTokenDidFailWithError:(NSError *)error
{
    NSLog(@"accessTokenDidFailWithError : %@", [error description]);
}

@end
```

#### JNKNaverCafeRequest 예제

```objective-c
JNKNaverCafeQueryMyCafeList *query = [[JNKNaverCafeQueryMyCafeList alloc] init];
query.page = 1;
query.perPage = 2;
query.order = @"U";
JNKNaverCafeRequest *api = [[JNKNaverCafeRequest alloc] init];
[api requestCafeAPI:query
            parsing:^id(JNKNaverCafeRequest *request, NSData *responseData) {
                // parsing (on Background Thread)
                // return id (ResponseData로부터 파싱한 후 파싱 데이터 리턴)
            } success:^(JNKNaverCafeRequest *request, id items) {
                // success (on Main Thread)
                // id items : parsing Block에서 리턴된 값
            } failure:^(JNKNaverCafeRequest *request, NSError *error) {
                // failure (on Main Thread)
            }];
```

#### JNKNaverShortUrRequest 예제

```objective-c
#import "JNKNaverShortUrlOpenAPI.h"

JNKNaverShortUrlRequest *api = [[JNKNaverShortUrlRequest alloc] init];
[api requestShortUrlAPI:@"www.naver.com" dataType:@"xml"
                parsing:^id(JNKNaverShortUrlRequest *request, NSData *responseData) {
                    // parsing (on Background Thread)
                    // return id (ResponseData로부터 파싱한 후 파싱 데이터 리턴)
                } success:^(JNKNaverShortUrlRequest *request, id items) {
                    // success (on Main Thread)
                    // id items : parsing Block에서 리턴된 값
                } failure:^(JNKNaverShortUrlRequest *request, NSError *error) {
                    // failure (on Main Thread)
                }];
```

## Support

- non-ARC와 ARC 둘다 지원합니다.

## Tests

* `JNKNaverOpenAPI(Search)`
  - `JNKNaverSearchOpenAPI iOS Example Project` JNKNaverSearchViewController 참고
* `JNKNaverOpenAPI(OAuth1)`
  - `JNKNaverOAuth1OpenAPI iOS Example Project` JNKNaverOAuth1ViewController 참고
* `JNKNaverOpenAPI(Cafe)`
  - `JNKNaverCafeOpenAPI iOS Example Project` JNKNaverCafeViewController 참고
* `JNKNaverOpenAPI(ShortUrl)`
  - `JNKNaverShortUrlOpenAPI iOS Example Project` JNKNaverShortUrlViewController 참고

## Contact

nkw68@naver.com

## License

MIT license
