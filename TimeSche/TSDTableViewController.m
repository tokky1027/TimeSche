//
//  TSDTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/01.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSDTableViewController.h"
#import "TSMViewController.h"
#import "TSJTableViewController.h"
#import "TimeScheAppDelegate.h"

@interface TSDTableViewController ()

@end
UITextView *textv;
//UITextField *textf_Lec,*textf_Tec,*textf_Rom;
UILabel *lbColor,*lbDate,*lbDeg,*lbJoin;
NSString *text_Lec,*text_Tec,*text_Rom;
UIPickerView *picker;
UIActionSheet *pickerViewPopup;
NSInteger rowN;

@implementation TSDTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ナビゲーションバー設定
    self.Lec_Navi_Bar.frame=CGRectMake(0, 0, 320, 65);
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(BackSc:)];
    self.Lec_Navi.leftBarButtonItem = btn;
    
    text_Lec=@"";
    text_Tec=@"";
    text_Rom=@"";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)BackSc:(id)sender{
    //記憶領域保存用タグ名の呼び出し
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *FK = appDelegate.TimeSche;
    
    //記憶領域保存用
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if(lbDeg.text==nil)lbDeg.text=@"";
    if(lbDate.text==nil)lbDate.text=@"";
    NSArray *NSALec_w = [[NSArray alloc] initWithObjects: text_Lec, text_Tec, lbDeg.text, text_Rom, lbDate.text, [NSString stringWithFormat:@"%d",lbColor.tag], textv.text,nil];
    [userDef setObject:NSALec_w forKey:FK];
    [userDef synchronize];

    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
        TSMViewController *dd = [appDelegate.toyBox objectForKey:@"TSMViewSave"]; //インスタンス召還
        [dd ReloadMethod];
    }];
    
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
        case 0: // 1個目のセクションの場合
            return @"基本情報";
            break;
        case 1: // 2個目のセクションの場合
            return @"出欠状況";
            break;
        case 2: // 3個目のセクションの場合
            return @"メモ";
            break;
    }
    return nil;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: // 1個目のセクションの場合
            return 6;
            break;
        case 1: // 2個目のセクションの場合
            return 1;
            break;
        case 2: // 3個目のセクションの場合
            return 1;
            break;
    }
    return 0;
    
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) return 100;
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //記憶領域保存用タグ名の呼び出し
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //記憶領域からデータを読込
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray *NSALec_r = [userDef stringArrayForKey:appDelegate.TimeSche];
    
    CGRect Rect =CGRectMake(100, 2, 200, 36);
    UITextField *tf_L= [[UITextField alloc] init];
    [self textSetting:tf_L Posi:Rect tag:[indexPath row] placehold:@""];//テキストフィールドの設定
    
    if(indexPath.section == 0) {
        switch (indexPath.row) {
                cell.tag = [indexPath row];
            case 0: //講義名
            {
                if (![NSALec_r[0] isEqualToString:@""]) {
                    tf_L.text = NSALec_r[0];//過去に入力履歴がある場合には、初期値に入れる
                    text_Lec = tf_L.text;
                }
                [cell addSubview:tf_L];
                cell.textLabel.text=@"講義名";//ラベル
                break;
            }
            case 1: //教員名
            {
                if (![NSALec_r[1] isEqualToString:@""]) {
                    tf_L.text = NSALec_r[1];//過去に入力履歴がある場合には、初期値に入れる
                    text_Tec = tf_L.text;
                }
                [cell addSubview:tf_L];
                cell.textLabel.text=@"教員名";//ラベル
                break;
            }
            case 2: //単位数
            {
                lbDeg = [[UILabel alloc] initWithFrame:Rect];
                lbDeg.text = NSALec_r[2];
                [cell addSubview:lbDeg];
                cell.textLabel.text=@"単位数";
                break;
            }
            case 3: //場所
            {
                tf_L.text = NSALec_r[3];//過去に入力履歴がある場合には、初期値に入れる
                [cell addSubview:tf_L];
                text_Rom = tf_L.text;
                cell.textLabel.text=@"場所";
                break;
            }
            case 4: //時間割
            {
                lbDate = [[UILabel alloc] initWithFrame:Rect];
                NSString *Yobi = [appDelegate.TimeSche substringWithRange:NSMakeRange(16,1)];   //曜日取得
                NSString *Jigen = [appDelegate.TimeSche substringWithRange:NSMakeRange(18,1)];   //時限取得
                if([Yobi isEqualToString:@"1"]) lbDate.text = [NSString stringWithFormat : @"月曜%@限",Jigen];
                else if([Yobi isEqualToString:@"2"]) lbDate.text = [NSString stringWithFormat : @"火曜%@限",Jigen];
                else if([Yobi isEqualToString:@"3"]) lbDate.text = [NSString stringWithFormat : @"水曜%@限",Jigen];
                else if([Yobi isEqualToString:@"4"]) lbDate.text = [NSString stringWithFormat : @"木曜%@限",Jigen];
                else if([Yobi isEqualToString:@"5"]) lbDate.text = [NSString stringWithFormat : @"金曜%@限",Jigen];
                else if([Yobi isEqualToString:@"6"]) lbDate.text = [NSString stringWithFormat : @"土曜%@限",Jigen];
                [cell addSubview:lbDate];
                cell.textLabel.text=@"時間割";
                break;
            }
            case 5: //タグ
            {
                lbColor = [[UILabel alloc] initWithFrame:Rect];
                lbColor.layer.borderColor = [UIColor blackColor].CGColor;
                lbColor.layer.borderWidth = 1.0;
                NSString *ColorTag =NSALec_r[5];
                lbColor.tag=ColorTag.intValue;
                [self colorSetting:lbColor tag:ColorTag.intValue];
                [cell addSubview:lbColor];
                cell.textLabel.text=@"タグ";
                break;
            }
            default:
                break;
        }
    }
    //出席状況
    if(indexPath.section == 1) {
        //詳細画面より取得
        int Join=0,Abs=0,Del=0,Canc=0;
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        
        NSString *NSCon = [userDef objectForKey:appDelegate.CountMem];
        NSData *DataJoin = [userDef objectForKey:appDelegate.JoinMem];
        NSMutableArray *NSAJoin = [NSKeyedUnarchiver unarchiveObjectWithData:DataJoin];
        
        for (int i=0; i<NSCon.intValue; i++) {
            if([NSAJoin[i] isEqualToString:@"出席"]) Join++;
            else if([NSAJoin[i] isEqualToString:@"欠席"]) Abs++;
            else if([NSAJoin[i] isEqualToString:@"遅刻"]) Del++;
            else if([NSAJoin[i] isEqualToString:@"休講"]) Canc++;
        }
        lbJoin = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 320, 36)];
        lbJoin.font = [UIFont fontWithName:@"AppleGothic" size:14];
        lbJoin.text =[NSString stringWithFormat : @"出席：%d　 欠席：%d　 遅刻：%d　 休講：%d",Join,Abs,Del,Canc];
        [cell addSubview:lbJoin];
    }
    //メモ
    if(indexPath.section == 2) {
        textv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        textv.editable = YES;
        textv.text=NSALec_r[6];
        //ツールバーを編集
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        toolBar.barStyle = UIBarStyleBlackOpaque; // スタイルを設定
        [toolBar sizeToFit];
        // フレキシブルスペースの作成（Doneボタンを右端に配置したいため）
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        // Doneボタンの作成
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)];
        // ボタンをToolbarに設定
        NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
        [toolBar setItems:items animated:YES];
        // ToolbarをUITextFieldのinputAccessoryViewに設定
        textv.inputAccessoryView = toolBar;
        //画面に追加
        [cell addSubview:textv];
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

//メモ記入用textviewのdoneボタンが押されたときの処理
-(void)closeKeyboard:(id)sender{
	[textv resignFirstResponder];
}

//テキストフィールドの編集が終了する直後の処理
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0: //講義名
        {
            text_Lec=textField.text;
            break;
        }
        case 1: //教員名
        {
            text_Tec = textField.text;
            break;
        }
        case 3: //場所
        {
            text_Rom = textField.text;
            break;
        }
        default:
            break;
    }
    [textField resignFirstResponder];    // キーボードを隠す
}


//UITextfiled終了時処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];    // キーボードを隠す
    return YES;
}

//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //出欠状況遷移用
    if (indexPath.section==1) {
        TSJTableViewController *TSJ =[[TSJTableViewController alloc] initWithNibName:@"TSJTableViewController" bundle:nil];
        [self presentViewController:TSJ animated:NO completion:nil];
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
    
    if ((indexPath.row==2 || indexPath.row==5) && indexPath.section==0) {
        rowN=indexPath.row;
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 400.0)];
        picker.delegate = self;
        [pickerViewPopup addSubview:pickerToolbar];
        [pickerViewPopup addSubview:picker];
        [pickerViewPopup showInView:self.view];
        [pickerViewPopup setBounds:CGRectMake(0,0,320,500)];
    }
}

/*-------------------------------------------------------------
 
 　　単位数＆曜日時限＆カラー指定ピッカー用
 
 -------------------------------------------------------------*/
//表示列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (rowN==4) return 2;
    return 1;
}

//表示行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (rowN==4){
        if (component==0) return 6;
        else return 7;
    };
    return 10;
}

//行サイズ
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (rowN==4){
        if (component==0) return 150.0;
        else return 150.0;
    };
    return 300.0;
}

//表示する値
-(UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel *label;
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectZero];
        if(rowN==5){
            label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,280.0f,40.0f)];
            [self colorSetting:label tag:row];
        }else{
            label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,280.0f,40.0f)];
            label.text = [NSString stringWithFormat:@"%d",row+1];
        }
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    if(rowN==5){
        [self colorSetting:lbColor tag:[picker selectedRowInComponent:0]];
        lbColor.tag=[picker selectedRowInComponent:0];
    }
    else lbDeg.text =[NSString stringWithFormat : @"%d%@",[picker selectedRowInComponent:0]+1, @"単位"];
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

//カラーの設定
- (void)colorSetting:(UILabel *)label tag:(NSInteger)tag{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *Data = [userDef objectForKey:@"UD_SET_TAG_KEY"];
    NSMutableArray *NSALec_r = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
    label.text = NSALec_r[tag];//過去に入力履歴がある場合には、初期値に入れる
    
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
- (void)ReloadMethod{
    //時間割記憶userdef keyの呼び出し
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //詳細画面より取得
    int Join=0,Abs=0,Del=0,Canc=0;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *NSCon = [userDef objectForKey:appDelegate.CountMem];
    NSData *DataJoin = [userDef objectForKey:appDelegate.JoinMem];
    NSMutableArray *NSAJoin = [NSKeyedUnarchiver unarchiveObjectWithData:DataJoin];
    
    for (int i=0; i<NSCon.intValue; i++) {
        if([NSAJoin[i] isEqualToString:@"出席"]) Join++;
        else if([NSAJoin[i] isEqualToString:@"欠席"]) Abs++;
        else if([NSAJoin[i] isEqualToString:@"遅刻"]) Del++;
        else if([NSAJoin[i] isEqualToString:@"休講"]) Canc++;
    }
    lbJoin.text =[NSString stringWithFormat : @"出席：%d　 欠席：%d　 遅刻：%d　 休講：%d",Join,Abs,Del,Canc];    
}

@end
