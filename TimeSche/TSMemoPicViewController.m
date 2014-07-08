//
//  TSMemoPicViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/06/15.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSMemoPicViewController.h"
#import "TimeScheAppDelegate.h"

@interface TSMemoPicViewController ()

@end

@implementation TSMemoPicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;

    self.scrollView.backgroundColor=[UIColor blackColor];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];  // 取得
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger selectedNo = appDelegate.SelectedMemo.intValue;
    NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    NSData* iData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,selectedNo]];//画像データ
    if(iData){
        UIImage *Image = [UIImage imageWithData:iData];
        self.imageView.image=Image;
    }
    
    //ボタン設定
    self.btn.titleLabel.text=@"Done";
    // ボタンがタッチダウンされた時にhogeメソッドを呼び出す
    [self.btn addTarget:self action:@selector(BackSc:)forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackSc:(id)sender{    
    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
