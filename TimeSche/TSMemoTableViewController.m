//
//  TSMemoTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/05.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSMemoTableViewController.h"
#import "TSMemoAddTableViewController.h"
#import "TimeScheAppDelegate.h"
#import "CustomCell.h"
#import "CustomSearchCell.h"
#define TABBAR_HEIGHT 98 //下のタブの縦の長さ

@interface TSMemoTableViewController ()

@end
UIPickerView *picker;
UIActionSheet *pickerViewPopup;
NSInteger TSNum,MemoP[1000];
UITextField *tf;
NSString *SearchW;
NSInteger MemoNum2=0;

@implementation TSMemoTableViewController

//タブバーイニシャライザ
- (id)init
{
    self = [super init];
    // タブバーのアイコンを設定
    if (self) self.tabBarItem =[[UITabBarItem alloc]initWithTitle:@"Memo" image:[UIImage imageNamed:@"Memo.png"] tag:2];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];

    SearchW=@"";
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    NSString *NSMemo = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]]; //メモ数
    TSNum=NSMemo.intValue;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomSearchCell" bundle:nil] forCellReuseIdentifier:@"CellS"];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.nadView pause];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.nadView resume];
}


#pragma mark - Table view data source
//セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    NSString *NSMemo = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]]; //メモ数

    TSNum=NSMemo.intValue;
    if (TSNum<0) TSNum=0;
    return TSNum+1;
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) return 60;
    if (indexPath.row==TSNum) return 200;
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.row==0) identifier=@"CellS";
    else identifier=@"Cell";
    CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(indexPath.row==0) {
        [cell.Badd addTarget:self action:@selector(AddMemo:) forControlEvents:UIControlEventTouchDown];
        cell.tfSearch.delegate=self;
        cell.tfSearch.text=SearchW;
    }else if(indexPath.row>0){
        cell.lbJigen.text=@"";
        cell.lbMemo.text=@"";
        cell.lbClock.text=@"";
        cell.lbNowClock.text=@"";
        cell.ivImage.image=nil;
        
        NSInteger LocalMemoNum=0;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
        MemoNum2=0;
        while (LocalMemoNum<=TSNum){//まずは表示時間割リストを作る
            NSString *Yobi=[userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,TSNum - LocalMemoNum]]; //メモ・時限
            if ([SearchW isEqualToString:@""] || [SearchW isEqualToString:Yobi]) {
                MemoP[MemoNum2]=LocalMemoNum;
                MemoNum2=MemoNum2+1;
            }
            LocalMemoNum=LocalMemoNum+1;
        }
        //そのセルに表示すべきメモ情報を抽出し表示
        if (indexPath.row <MemoNum2+1) {
            NSData* iData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,TSNum - MemoP[indexPath.row-1]]];
            cell.lbJigen.text = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,TSNum - MemoP[indexPath.row-1]]]; //メモ・時限
            cell.lbClock.text = [userDef objectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TS_No,TSNum - MemoP[indexPath.row-1]]];
            cell.lbNowClock.text = [userDef objectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE2_KEY",TS_No,TSNum - MemoP[indexPath.row-1]]];
            cell.lbMemo.text = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,TSNum - MemoP[indexPath.row-1]]]; //メモ・メモ
            if(iData) cell.ivImage.image = [UIImage imageWithData:iData];
        }
    }
    return cell;
}

//テキストビュクリックイベント
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Show UIPickerView
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"ho" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closePicker:)];
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 300.0)];
    picker.delegate = self;
    [pickerViewPopup addSubview:pickerToolbar];
    [pickerViewPopup addSubview:picker];
    [pickerViewPopup showInView:self.view];
    [pickerViewPopup setBounds:CGRectMake(0,0,320,500)];
    
    return NO;
}

//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0 && indexPath.row <MemoNum2+1) {
        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.SelectedMemo=[NSString stringWithFormat:@"%d",TSNum - MemoP[indexPath.row-1]]; //メモNoの記憶

        TSMemoAddTableViewController *TSMA =[[TSMemoAddTableViewController alloc] initWithNibName:@"TSMemoAddTableViewController" bundle:nil];
        [self presentViewController:TSMA animated:NO completion:nil];
    }
}

//メモ追加ボタンクリック時イベント
-(void)AddMemo:(UIBarButtonItem*)b{
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.SelectedMemo=[NSString stringWithFormat:@"%d",-1]; //メモNo.-1で記憶
    TSMemoAddTableViewController *TSMA =[[TSMemoAddTableViewController alloc] initWithNibName:@"TSMemoAddTableViewController" bundle:nil];
    [self presentViewController:TSMA animated:NO completion:nil];
}

/*-------------------------------------------------------------
 
 　　単位数＆曜日時限＆カラー指定ピッカー用
 
 -------------------------------------------------------------*/
//表示列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//表示行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) return 7;
    else return 9;
}

//行サイズ
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 150.0;
}

//表示する値
-(UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel *label;
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectZero];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,150.0f,40.0f)];
        if (row > 0) {
            if (component==0)[self DateSetting:label tag:row-1];
            else label.text=[NSString stringWithFormat : @"%d%@",row, @"限"];
        }
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    UILabel* Yobi=[[UILabel alloc]init];
    [self DateSetting:Yobi tag:[picker selectedRowInComponent:0]-1];
    NSString *jikanwari=[NSString stringWithFormat : @"%d限",[picker selectedRowInComponent:1]];
    if (![jikanwari isEqualToString:@"0限"]) tf.text =[Yobi.text stringByAppendingString:jikanwari];
    else tf.text=@"";
    SearchW=tf.text;
    [self.tableView reloadData];
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

- (void)DateSetting:(UILabel *)label tag:(int)tag{
    switch(tag) {
        case 0:
            label.text = @"月曜";
            break;
        case 1:
            label.text = @"火曜";
            break;
        case 2:
            label.text = @"水曜";
            break;
        case 3:
            label.text = @"木曜";
            break;
        case 4:
            label.text = @"金曜";
            break;
        case 5:
            label.text = @"土曜";
            break;
        default:
            break;
    }
}

@end
