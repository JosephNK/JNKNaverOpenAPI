//
//  JNKNaverShortUrlViewController.h
//  JNKNaverShortUrlOpenAPI iOS Example
//
//  Created by Joseph NamKung on 2014. 9. 22..
//  Copyright (c) 2014년 JosephNK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNKNaverShortUrlViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *textFieldUrl;

- (IBAction)btnShoutUrl_clicked:(id)sender;

@end
