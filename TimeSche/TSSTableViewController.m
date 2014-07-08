//
//  TSSTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/05.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSSTableViewController.h"
#import "TSAddTableViewController.h"
#import "TimeScheAppDelegate.h"

@interface TSSTableViewController ()

@end

UITextView *textv;
UITextField *textf[10];
UILabel *lbWeek,*lbComa;
UIPickerView *picker;
UIActionSheet *pickerViewPopup;
NSInteger rowN;
@implementation TSSTableViewController

//イニシャライザ
- (id)init
{
    self = [super init];
    if (self) {
        // タブバーのアイコンを設定
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"設定" image:[UIImage imageNamed:@"setting.png"] tag:3];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初期値
    for (int i=0; i<10; i++) {
        textf[i] = [[UITextField alloc] init];
        [textf[i] addTarget:self action:nil forControlEvents:UIControlEventAllEditingEvents];
    }
    
    //ナビゲーションバー設定
    self.Navi_Setting_Bar.frame=CGRectMake(0, 0, 320, 65);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
//セクション名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"データの全削除";
            break;
        case 1:
            return @"週設定";
            break;
        case 2:
            return @"タグ設定";
            break;
    }
    return nil;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 11;
            break;
    }
    return 0;
    
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==10) return 80;
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text=@"";
    //記憶領域からデータを読込
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    UITextField *textf = [[UITextField alloc] init];
    [textf addTarget:self action:nil forControlEvents:UIControlEventAllEditingEvents];

    //週設定
    if(indexPath.section == 1) {
        for (UIView *subview in [cell.contentView subviews]) [subview removeFromSuperview];
        switch (indexPath.row) {
            case 0: //週設定
            {
                NSString *NSWeek = [userDef objectForKey:@"UD_SET_WEEK_KEY"];
                lbWeek = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 300, 37)];
                [self WeekSetting:lbWeek tag:[NSWeek intValue]];
                [cell addSubview:lbWeek];
                cell.textLabel.text=@"曜日";
                break;
            }
            case 1: //教員名
            {
                NSString *NSJigen = [userDef objectForKey:@"UD_SET_JIGEN_KEY"];
                lbComa = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 200, 37)];
                lbComa.text = [NSString stringWithFormat : @"%@",NSJigen];
                [cell addSubview:lbComa];
                cell.textLabel.text=@"時限";
                break;
            }
            default:
                break;
        }
    }
    //タグ設定
    if(indexPath.section == 2 && indexPath.row<10) {
        NSData *Data = [userDef objectForKey:@"UD_SET_TAG_KEY"];
        NSMutableArray *NSALec_r = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
        
        CGRect Rect =CGRectMake(140, 2, 200, 38);
        UILabel *Lb =[[UILabel alloc] initWithFrame:CGRectMake(20, 3, 100, 37)];
        Lb.layer.borderColor = [UIColor blackColor].CGColor;
        Lb.layer.borderWidth = 1.0;
        [self textSetting:textf Posi:Rect tag:[indexPath row] placehold:@""];//テキストフィールドの設定
        
        textf.text = NSALec_r[indexPath.row];//過去に入力履歴がある場合には、初期値に入れる
        [cell addSubview:Lb];
        [cell addSubview:textf];
        switch(indexPath.row) {
            case 0:
                Lb.backgroundColor=[UIColor clearColor];
                break;
            case 1:
                Lb.backgroundColor = [UIColor grayColor];
                break;
            case 2:
                Lb.backgroundColor = [UIColor brownColor];
                break;
            case 3:
                Lb.backgroundColor = [UIColor redColor];
                break;
            case 4:
                Lb.backgroundColor = [UIColor orangeColor];
                break;
            case 5:
                Lb.backgroundColor = [UIColor yellowColor];
                break;
            case 6:
                Lb.backgroundColor = [UIColor greenColor];
                break;
            case 7:
                Lb.backgroundColor = [UIColor cyanColor];
                break;
            case 8:
                Lb.backgroundColor = [UIColor blueColor];
                break;
            case 9:
                Lb.backgroundColor = [UIColor purpleColor];
                break;
            default:
                break;
        }
    }
    if(indexPath.section == 0) {
        cell.textLabel.text=@"データを全削除する";
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
    return cell;
}

//テキストフィールドの設定
- (void)textSetting:(UITextField *)textField Posi:(CGRect)Posi tag:(int)tag placehold:(NSString *)placehold{
    textField.delegate=self;
    textField.frame = Posi;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehold attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;// ReturnキーをDoneに変える
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.tag = tag;
}

//UITextfiled終了時処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (textField.tag==1000) {
    }else{
        //データの保存
        NSData *Data = [userDef objectForKey:@"UD_SET_TAG_KEY"];
        NSMutableArray *NSALec_w = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
        NSALec_w[textField.tag]=textField.text;
        Data = [NSKeyedArchiver archivedDataWithRootObject:NSALec_w];
        [userDef setObject:Data forKey:@"UD_SET_TAG_KEY"];
    }
    [userDef synchronize];
    [textField resignFirstResponder];    // キーボードを隠す
    return YES;
}


//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==0) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"削除してもよろしいですか？"delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }
    
    //単位数&曜日時限 & カラー指定ピッカー用
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
    
    if (indexPath.section==1) {
        rowN=indexPath.row;
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 300.0)];
        picker.delegate = self;
        [pickerViewPopup addSubview:pickerToolbar];
        [pickerViewPopup addSubview:picker];
        [pickerViewPopup showInView:self.view];
        [pickerViewPopup setBounds:CGRectMake(0,0,320,500)];
    }
}

/*-------------------------------------------------------------
 　　曜日時限指定ピッカー用
 -------------------------------------------------------------*/
//表示列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//表示行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (rowN==0) return 2;
    return 8;
}

//行サイズ
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300.0;
}

//表示する値
-(UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel *label;
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectZero];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,150.0f,30.0f)];
        if (rowN==0) [self WeekSetting:label tag:row];
        else label.text = [NSString stringWithFormat:@"%d",row+1];
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (rowN==0){
        [self WeekSetting:lbWeek tag:[picker selectedRowInComponent:0]];
        [userDef setObject:[NSString stringWithFormat : @"%d",[picker selectedRowInComponent:0]] forKey:@"UD_SET_WEEK_KEY"];
    }else{
        lbComa.text =[NSString stringWithFormat : @"%d%@",[picker selectedRowInComponent:0]+1, @"限"];
        [userDef setObject:lbComa.text forKey:@"UD_SET_JIGEN_KEY"];
    }
    [userDef synchronize];
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

- (void)WeekSetting:(UILabel *)label tag:(int)tag{
    switch(tag) {
        case 0:
            label.text = @"月曜〜金曜";
            break;
        case 1:
            label.text = @"月曜〜土曜";
            break;
        default:
            break;
    }
}

//確認メッセージ
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    switch (buttonIndex) {
        case 0://いいえボタン
            break;
        case 1://はいボタン
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain]; //削除
            //初期値
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
            
            TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
            TSAddTableViewController *dd = [appDelegate.toyBox objectForKey:@"TSAddTableViewSave"]; //インスタンス召還
            [dd.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新
            TSMViewController *cc = [appDelegate.toyBox objectForKey:@"TSMViewSave"]; //インスタンス召還
            [cc ChangeTS]; // メソッド呼び出し
            TSMemoTableViewController *ff = [appDelegate.toyBox objectForKey:@"TSMemoViewSave"]; //インスタンス召還
            [ff.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新
            
            break;
    }
}

@end
