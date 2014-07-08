//
//  TSMViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/05.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSMViewController.h"
#import "TSDTableViewController.h"
#import "TimeScheAppDelegate.h"
#import "TSMemoAddViewController.h"

@interface TSMViewController ()

@end

UILabel *lbComa[6][10];
NSInteger iweek,icoma;
NSString *NSTimeSche;
NSString *NSJoinMem;
NSString *NSCountMem;
UITextField *tf[10][6];
UITextField *tf_f[10][6][3];

@implementation TSMViewController

//タブバーイニシャライザ
- (id)init
{
    self = [super init];
    // タブバーのアイコンを設定
    if (self) self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"時間割" image:[UIImage imageNamed:@"jikanwari.png"] tag:1];
    return self;
}
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
    //tabBar
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.size.height = frame.size.height + 50;

    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];// (2) NADView の作成
    [self.nadView setIsOutputLog:NO];    // (3) ログ出力の指定
    [self.nadView setNendID:@"650d31495097bef27c023ddc189d6e6d934cf9de" spotID:@"189968"];    // (4) set apiKey, spotId.
    [self.nadView setDelegate:self];
    [self.nadView setBackgroundColor:[UIColor cyanColor]];
    [self.nadView load:[NSDictionary dictionaryWithObjectsAndKeys:@"30", @"retry", nil]];

    [self.tabBarController.tabBar setFrame:frame];
    [self.view setBounds:self.tabBarController.tabBar.bounds];

    [self.tabBarController.tabBar addSubview:self.nadView]; // 最初から表示する場合
    
}
-(void)viewDidLayoutSubviews {
    //タブバー切り替え検知用デリゲート
    self.tabBarController.delegate=self;
    
    //ナビゲーションバー設定
    self.tabBarController.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.tabBarController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self.viewDeckController action:@selector(toggleLeftView)];
    [UITabBar appearance].barTintColor = [UIColor blackColor];
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.contentSize = CGSizeMake(320, 630);
    [self.ScrollView flashScrollIndicators];
    
    //記憶領域初期値
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    NSMutableArray *NSALec = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)[NSALec addObject:@""];
    NSData *Data = [NSKeyedArchiver archivedDataWithRootObject:NSALec];
    [defaults setObject:Data forKey:@"UD_SET_TAG_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"0" forKey:@"UD_SET_WEEK_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"7限" forKey:@"UD_SET_JIGEN_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"1" forKey:@"UD_SET_TSNUM_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"1" forKey:@"UD_SET_TSNOW_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"時間割1" forKey:@"UD_SET_TSNAME1_KEY"];
    [userDef registerDefaults:defaults];
    [userDef synchronize];    
    
    NSInteger TSNum = [userDef integerForKey:@"UD_SET_TSNUM_KEY"];//時間割数
    NSArray *NSALec_Info=[[NSArray alloc] initWithObjects:@"", @"", @"",@"", @"", @"",@"", nil];
    for (int q=0; q<TSNum; q++) {
        for (int i=0; i<6; i++) {
            for (int k=0; k<8; k++) {
                [defaults setObject:NSALec_Info forKey:[NSString stringWithFormat:@"UD_No%d_LEC_KEY_x%dy%d",q+1,i+1,k+1]];
                [userDef registerDefaults:defaults];
            }
        }
    }
    [userDef synchronize];

    //ナビゲーションバーに名前を書き込み
    NSInteger TSName_Num=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    NSString *TSName=[userDef stringForKey:[NSString stringWithFormat:@"UD_SET_TSNAME%d_KEY",TSName_Num]];
    self.tabBarController.navigationItem.title=TSName;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    [self.ScrollView addGestureRecognizer:tapGesture];
    
    UITextField *textf = [[UITextField alloc] init];
    [textf addTarget:self action:nil forControlEvents:UIControlEventAllEditingEvents];
    
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.toyBox setObject:@"MainView" forKey:@"ViewName"];

    [self ScrBuild];    //時間割の描画
    [self.view layoutSubviews];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.nadView pause];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.nadView resume];
}

/*-------------------------------------------------------------
 　　ビュータップイベント
 　　-時間割のマスがタップされたときのイベント
 -------------------------------------------------------------*/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
    NSInteger TSNum = [userdefault integerForKey:@"UD_SET_TSNOW_KEY"];  // 時間割表番号の取得
    
    //座標取得
    CGPoint point = [sender locationOfTouch:0 inView:self.ScrollView];    
    if (point.x>=15) {
        for (int i=0; i<icoma; i++){
            if (point.y <=16+(550/icoma)*(i+1) && point.y >16+(550/icoma)*i) {
                for (int k=0; k<iweek; k++){
                    if (point.x <=15+(305/iweek)*(k+1) && point.x >15+(305/iweek)*k) {
                        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
                        appDelegate.TimeSche=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,k+1,i+1];
                        appDelegate.JoinMem=[NSString stringWithFormat : @"UD_No%d_JOIN_KEY_x%dy%d",TSNum,k+1,i+1];
                        appDelegate.CountMem=[NSString stringWithFormat : @"UD_No%d_LEC_COUNT_KEY_x%dy%d",TSNum,k+1,i+1];
                        break;
                    }
                }
                break;
            }
        }
        TSDTableViewController *TSD =[[TSDTableViewController alloc] initWithNibName:@"TSDTableViewController" bundle:nil];
        [self presentViewController:TSD animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//タブバーの切り替え時イベント
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //現在のビューの名前を保存
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([viewController.nibName isEqualToString:@"TSMViewController"])
    {
        for (UIView *view in [self.ScrollView subviews]) [view removeFromSuperview];
        for (UIView *view in [self.UITextVw subviews]) [view removeFromSuperview];
        [appDelegate.toyBox setObject:@"MainView" forKey:@"ViewName"];
        
        self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self.viewDeckController action:@selector(toggleLeftView)];
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
        [self ScrBuild];
    }
    if([viewController.nibName isEqualToString:@"TSMemoTableViewController"])
    {
        //ナビゲーションバーに名前を書き込み
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];// 取得
        NSInteger TSName_Num=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
        NSString *TSName=[userDef stringForKey:[NSString stringWithFormat:@"UD_SET_TSNAME%d_KEY",TSName_Num]];
        self.tabBarController.navigationItem.title=[TSName stringByAppendingString:@"のメモ"];
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
        [appDelegate.toyBox setObject:@"MemoView" forKey:@"ViewName"];
    }
    if([viewController.nibName isEqualToString:@"TSSTableViewController"])
    {
        [appDelegate.toyBox setObject:@"SetView" forKey:@"ViewName"];
        self.tabBarController.navigationItem.leftBarButtonItem = nil;
        
        self.tabBarController.navigationItem.title=@"全体設定";
    }
}

//時間割の描画
- (void)ScrBuild
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    //週曜日数、コマ数取得
    NSString *NSWeek = [userDef objectForKey:@"UD_SET_WEEK_KEY"];
    if (NSWeek.intValue==0) iweek=5;
    else iweek=6;
    NSString *NSComa = [userDef objectForKey:@"UD_SET_JIGEN_KEY"];
    icoma=NSComa.intValue;

    //ナビゲーションバーに名前を書き込み
    NSInteger TSName_Num=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    NSString *TSName=[userDef stringForKey:[NSString stringWithFormat:@"UD_SET_TSNAME%d_KEY",TSName_Num]];
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *viewName=[appDelegate.toyBox objectForKey:@"ViewName"];
    
    if([viewName isEqualToString:@"MainView"]) self.tabBarController.navigationItem.title=TSName;
    if([viewName isEqualToString:@"MemoView"]) self.tabBarController.navigationItem.title=[TSName stringByAppendingString:@"のメモ"];
    if([viewName isEqualToString:@"SetView"])self.tabBarController.navigationItem.title=@"全体設定";    
    
    //時間割配置
    UILabel *Coma[icoma];
    for (int i=0; i<icoma; i++){
        Coma[i] = [[UILabel alloc] init];
        Coma[i].userInteractionEnabled = YES;
        Coma[i].frame = CGRectMake(0, (550/icoma)*i, 16, (550/icoma)+1);
        Coma[i].font = [UIFont fontWithName:@"AppleGothic" size:12];
        Coma[i].text = [NSString stringWithFormat : @"%d",i+1];
        Coma[i].layer.borderColor = [UIColor blackColor].CGColor;
        Coma[i].layer.borderWidth = 1.0;
        [self.ScrollView addSubview:Coma[i]];
    }
    UILabel *Day[iweek];
    for (int i=0; i<iweek; i++){
        Day[i] = [[UILabel alloc] init];
        Day[i].userInteractionEnabled = YES;
        Day[i].frame = CGRectMake(15+(305/iweek)*i, 0, (305/iweek)+1,17);
        Day[i].font = [UIFont fontWithName:@"AppleGothic" size:12];
        if (i==0) Day[i].text = @"月";
        else if(i==1) Day[i].text = @"火";
        else if(i==2) Day[i].text = @"水";
        else if(i==3) Day[i].text = @"木";
        else if(i==4) Day[i].text = @"金";
        else if(i==5) Day[i].text = @"土";
        Day[i].layer.borderColor = [UIColor blackColor].CGColor;
        Day[i].layer.borderWidth = 1.0;
        [self.UITextVw addSubview:Day[i]];
    }

    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
    NSInteger TSNum = [userdefault integerForKey:@"UD_SET_TSNOW_KEY"];  // 時間割表番号の取得
    for (int i=0; i<iweek; i++) {
        for (int k=0; k<icoma; k++) {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSArray* NSALec_Info = [userDef arrayForKey:[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,i+1,k+1]];
            
            tf[k][i]=[[UITextField alloc] initWithFrame:CGRectMake(15+(305/iweek)*i, (550/icoma)*k, (305/iweek)+1, (550/icoma)+1)];
            tf[k][i].enabled = NO;
            tf[k][i].borderStyle = UITextBorderStyleLine;
            NSString *tag=NSALec_Info[5];
            [self colorSetting:tf[k][i] tag:tag.intValue];
            [self.ScrollView addSubview:tf[k][i]];
        }
    }
    UIFont *font = [UIFont systemFontOfSize:14];
    for (int i=0; i<iweek; i++) {
        for (int k=0; k<icoma; k++) {
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            NSArray* NSALec_Info = [userDef arrayForKey:[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,i+1,k+1]];

            for (int m=0; m<3; m++) {
                tf_f[k][i][m]=[[UITextField alloc] initWithFrame:CGRectMake(15+(305/iweek)*i, 5+((550/icoma)/3)*m+(550/icoma)*k, (305/iweek)+1, 15)];
                tf_f[k][i][m].enabled = NO;
                tf_f[k][i][m].borderStyle = UITextBorderStyleNone;
                tf_f[k][i][m].font=[font fontWithSize:12];
                if (m==2) tf_f[k][i][m].text =NSALec_Info[3];
                else tf_f[k][i][m].text =NSALec_Info[m];

                [self.ScrollView addSubview:tf_f[k][i][m]];
            }
        }
    }
}

//カラーの設定
- (void)colorSetting:(UITextField *)label tag:(int)tag{
    switch(tag) {
        case 0:
            label.backgroundColor = [UIColor clearColor];
            break;
        case 1:
            label.backgroundColor = [UIColor grayColor];
            break;
        case 2:
            label.backgroundColor = [UIColor brownColor];
            break;
        case 3:
            label.backgroundColor = [UIColor redColor];
            break;
        case 4:
            label.backgroundColor = [UIColor orangeColor];
            break;
        case 5:
            label.backgroundColor = [UIColor yellowColor];
            break;
        case 6:
            label.backgroundColor = [UIColor greenColor];
            break;
        case 7:
            label.backgroundColor = [UIColor cyanColor];
            break;
        case 8:
            label.backgroundColor = [UIColor blueColor];
            break;
        case 9:
            label.backgroundColor = [UIColor purpleColor];
            break;
        default:
            break;
    }
}

- (void)ReloadMethod{
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray* NSALec_Info = [userDef arrayForKey:appDelegate.TimeSche];
    NSString *px = [appDelegate.TimeSche substringWithRange:NSMakeRange(16,1)];
    NSString *py = [appDelegate.TimeSche substringWithRange:NSMakeRange(18,1)];

    NSString *tag=NSALec_Info[5];
    [self colorSetting:tf[py.intValue-1][px.intValue-1] tag:tag.intValue];

    tf_f[py.intValue-1][px.intValue-1][0].text =NSALec_Info[0];
    tf_f[py.intValue-1][px.intValue-1][1].text =NSALec_Info[1];
    tf_f[py.intValue-1][px.intValue-1][2].text =NSALec_Info[3];
}

- (void)ChangeTS{
    for (UIView *view in [self.ScrollView subviews]) [view removeFromSuperview];
    for (UIView *view in [self.UITextVw subviews]) [view removeFromSuperview];
    [self ScrBuild];
}

@end
