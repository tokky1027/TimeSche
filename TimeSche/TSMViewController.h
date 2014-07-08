//
//  TSMViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/05.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface TSMViewController : UIViewController <UITabBarControllerDelegate,UIScrollViewDelegate,NADViewDelegate>{}

@property (nonatomic, retain) NADView * nadView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITabBar *Main_TabBar;
@property (weak, nonatomic) IBOutlet UITextView *UITextVw;
- (void)ReloadMethod;
- (void)ChangeTS;
@end
