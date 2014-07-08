//
//  TSAddTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/18.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSAddTableViewController.h"
#import "TimeScheAppDelegate.h"
#import "TSAddDTableViewController.h"
#import "TSMViewController.h"
#define COLOR [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]

@interface TSAddTableViewController ()

@end
NSInteger TSNum;

@implementation TSAddTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = COLOR;
    
    //記憶領域初期値
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"1" forKey:@"UD_SET_TSNUM_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"1" forKey:@"UD_SET_TSNOW_KEY"];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"時間割1" forKey:@"UD_SET_TSNAME1_KEY"];
    [userDef registerDefaults:defaults];
    [userDef synchronize];
    
    TSNum = [userDef integerForKey:@"UD_SET_TSNUM_KEY"];//  時間割表の数
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

//セル・カスタマイズ
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = COLOR;
    cell.textLabel.textColor =[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

//セクション名・カスタマイズ
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = COLOR;
    if (section == 1) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 310.0f, 22.0f)];
        lbl.backgroundColor = COLOR;
        lbl.textColor = [UIColor whiteColor];
        lbl.text = @"時間割の選択";
        lbl.font = [UIFont fontWithName:@"AppleGothic" size:12];
        [v addSubview:lbl];
    }
    return v;
}


//セクション名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @" ";
            break;
        case 1: // 2個目のセクションの場合
            return @"時間割の選択";
            break;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section) {
        case 0: // 1個目のセクションの場合
            return 1;
            break;
        case 1: // 2個目のセクションの場合
            return TSNum;
            break;
    }
    return 0;
}
// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if(indexPath.section == 0) cell.textLabel.text=@"時間割の編集";
    //時間割の選択
    if(indexPath.section == 1) {
        NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",indexPath.row+1];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
        cell.textLabel.text = [userdefault stringForKey:userKey];  //時間割の名前をNSString型として取得
    }
    
    return cell;
}

//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //時間割の追加
    if (indexPath.section==0 && indexPath.row==0) {
        TSAddDTableViewController *TSAD =[[TSAddDTableViewController alloc] initWithNibName:@"TSAddDTableViewController" bundle:nil];
        [self presentViewController:TSAD animated:NO completion:nil];
    }else if(indexPath.section==1){
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setInteger:indexPath.row+1 forKey:@"UD_SET_TSNOW_KEY"];//選択時間割の記憶
        [userDef synchronize];
        
        //再描画
        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
        TSMViewController *cc = [appDelegate.toyBox objectForKey:@"TSMViewSave"]; //インスタンス召還
        [cc ChangeTS]; // メソッド呼び出し
        TSMemoTableViewController *dd = [appDelegate.toyBox objectForKey:@"TSMemoViewSave"]; //インスタンス召還
        [dd.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新        
    }
}

@end
