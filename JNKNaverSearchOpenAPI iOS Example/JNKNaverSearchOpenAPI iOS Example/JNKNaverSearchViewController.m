//
//  JNKNaverSearchViewController.m
//  JNKNaverSearchOpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 21..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import "JNKNaverSearchViewController.h"
#import "UIAlertView+JNKError.h"
#import "JNKNaverTBXMLParser.h"
#import "JNKNaverSearchOpenAPI.h"

@implementation JNKNaverSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testNaverSearchOpenAPI_Adult:(id)sender {
    JNKNaverSearchQueryAdult *query = [[JNKNaverSearchQueryAdult alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"소녀"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromAdultData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Blog:(id)sender {
    JNKNaverSearchQueryBlog *query = [[JNKNaverSearchQueryBlog alloc] init];
    query.target = @"news";
    query.query = @"리뷰";
    
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"리뷰"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromBlogData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Book:(id)sender {
    JNKNaverSearchQueryBook *query = [[JNKNaverSearchQueryBook alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"삼국지"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromBookData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Book_ISBN:(id)sender {
    JNKNaverSearchQueryBook *query = [[JNKNaverSearchQueryBook alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query ISBN:@"9788931006216"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromBookData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Cafe:(id)sender {
    JNKNaverSearchQueryCafe *query = [[JNKNaverSearchQueryCafe alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"요리"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromCafeData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Doc:(id)sender {
    JNKNaverSearchQueryDoc *query = [[JNKNaverSearchQueryDoc alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"물리학"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromDocData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Encyc:(id)sender {
    JNKNaverSearchQueryEncyc *query = [[JNKNaverSearchQueryEncyc alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"독도"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromEncycData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Image:(id)sender {
    JNKNaverSearchQueryImage *query = [[JNKNaverSearchQueryImage alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"제주도"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromImageData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Kin:(id)sender {
    JNKNaverSearchQueryKin *query = [[JNKNaverSearchQueryKin alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"화성"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromKinData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Local:(id)sender {
    JNKNaverSearchQueryLocal *query = [[JNKNaverSearchQueryLocal alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"갈비집"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromLocalData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Movie:(id)sender {
    JNKNaverSearchQueryMovie *query = [[JNKNaverSearchQueryMovie alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"벤허"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromMovieData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_News:(id)sender {
    JNKNaverSearchQueryNews *query = [[JNKNaverSearchQueryNews alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"주식"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromNewsData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}

- (IBAction)testNaverSearchOpenAPI_Shop:(id)sender {
    JNKNaverSearchQueryShop *query = [[JNKNaverSearchQueryShop alloc] init];
    JNKNaverSearchRequest *api = [[JNKNaverSearchRequest alloc] init];
    [api requestSearchAPI:query QUERY:@"노트북"
                  parsing:^id(JNKNaverSearchRequest *request, NSData *responseData) {
                      return [JNKNaverTBXMLParser pasingFromShopData:responseData];
                  } success:^(JNKNaverSearchRequest *request, id items) {
                      NSDictionary *dic = (NSDictionary *)items;
                      NSError *dicInfoError = [dic objectForKey:@"Error"];
                      NSArray *dicInfoArr = [dic objectForKey:@"Items"];
                      if (dicInfoError != (NSError *)[NSNull null]) {
                          [UIAlertView showAlertError:dicInfoError];
                      }
                      if (dicInfoArr != (NSArray *)[NSNull null]) {
                          NSLog(@"success %@", [dicInfoArr description]);
                      }
                  } failure:^(JNKNaverSearchRequest *request, NSError *error) {
                      NSLog(@"failure error %@", [error description]);
                  }];
}


@end
