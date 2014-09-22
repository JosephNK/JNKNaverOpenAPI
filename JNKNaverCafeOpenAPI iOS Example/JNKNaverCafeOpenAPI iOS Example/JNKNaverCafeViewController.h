//
//  JNKNaverCafeViewController.h
//  JNKNaverCafeOpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 21..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNKNaverOAuth1WebViewController.h"
#import "JNKNaverOAuth1OpenAPI.h"

@interface JNKNaverCafeViewController : UIViewController <JNKNaverOAuth1WebViewControllerDelegate>

- (IBAction)btnNaverOAuth1_clicked:(id)sender;
- (IBAction)btnNaverCafeGetArticleList_clicked:(id)sender;
- (IBAction)btnNaverCafeGetMenuList_clicked:(id)sender;
- (IBAction)btnNaverCafeGetMyCafeList_clicked:(id)sender;

@end
