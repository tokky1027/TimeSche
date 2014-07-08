//
//  TSMemoPicViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/06/15.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMemoPicViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
