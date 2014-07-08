//
//  TSAddDTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/18.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSAddDTableViewController.h"
#import "TSAddTableViewController.h"
#import "TimeScheAppDelegate.h"

@interface TSAddDTableViewController ()

@end
UIPickerView *picker;
UIActionSheet *pickerViewPopup;
NSInteger rowN;
NSInteger TSNum,SelectNum,SelectNumDel;
UILabel *lbSelect,*lbSelectDel;
NSString *NSTSName;
NSMutableArray *NSAName;
NSInteger ChoiceItem;
@implementation TSAddDTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ナビゲーションバー設定
    self.TSAddD_Navi.frame=CGRectMake(0, 0, 320, 65);
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(BackSc:)];
    self.TSAddD_Navi_Item.leftBarButtonItem = btn;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];  // 取得
    TSNum = [userDef integerForKey:@"UD_SET_TSNUM_KEY"];//

    NSAName = [[NSMutableArray alloc] init];
    for (int i=0; i<TSNum; i++){
        NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",i+1];
        NSString *TSNameL = [userDef stringForKey:userKey];  // 時間割の名前をNSString型として取得
        [NSAName addObject:TSNameL];
    }
    
    SelectNum=0;    //時間割新規追加時参照時間割
    SelectNumDel=0; //時間割削除時削除時間割
    ChoiceItem=0;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)BackSc:(id)sender{
    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
        TSAddTableViewController *dd = [appDelegate.toyBox objectForKey:@"TSAddTableViewSave"]; //インスタンス召還
        [dd.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新
        TSMViewController *cc = [appDelegate.toyBox objectForKey:@"TSMViewSave"]; //インスタンス召還
        [cc ChangeTS]; // メソッド呼び出し
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
            return @"新規追加";
            break;
        case 1: // 2個目のセクションの場合
            return @"時間割名の変更";
            break;
        case 2: // 2個目のセクションの場合
            return @"時間割の削除";
            break;
    }
    return nil;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: // 1個目のセクションの場合
            return 4;
            break;
        case 1: // 2個目のセクションの場合
            return TSNum+2;
            break;
        case 3: // 2個目のセクションの場合
            return 3;
            break;
    }
    return 3;
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section==0 && indexPath.row==2) ||(indexPath.section==1 && indexPath.row==TSNum)|| (indexPath.section==2 && indexPath.row==1)) return 8;
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == 0 && indexPath.row==0) cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    else cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    UITextField *textf = [[UITextField alloc] init];
    [textf addTarget:self action:nil forControlEvents:UIControlEventAllEditingEvents];
    //新規追加
    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: //新規時間割名
            {
                cell.textLabel.text=@"追加時間割名";//ラベル
                CGRect Rect =CGRectMake(140, 2, 200, 38);
                NSTSName=[NSString stringWithFormat : @"時間割%d",TSNum+1];
                [self textSetting:textf Posi:Rect tag:1000 placehold:NSTSName];//テキストフィールドの設定
                [cell addSubview:textf];
                break;
            }
            case 1: //参照時間割
            {
                cell.textLabel.text=@"参照時間割";
                lbSelect = [[UILabel alloc] initWithFrame:CGRectMake(140, 2, 200, 38)];
                lbSelect.text = @"新規追加";
                [cell addSubview:lbSelect];
                break;
            }
            case 3: //追加確定
            {
                UILabel *lbDecide;
                lbDecide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
                lbDecide.textAlignment = NSTextAlignmentCenter;
                lbDecide.textColor = [UIColor redColor];
                lbDecide.text = @"追加";
                [cell addSubview:lbDecide];
                break;
            }
            default:
                break;
        }
    }
    //名称変更
    if(indexPath.section == 1) {
        if (indexPath.row==TSNum+1) {
            UILabel *lbDecide;
            lbDecide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
            lbDecide.textAlignment = NSTextAlignmentCenter;
            lbDecide.textColor = [UIColor redColor];
            lbDecide.text = @"確定";
            [cell addSubview:lbDecide];
        }else if(indexPath.row!=TSNum){
            CGRect Rect =CGRectMake(140, 2, 200, 38);
            NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",indexPath.row+1];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            textf.text = [userdefault stringForKey:userKey];  // 時間割の名前をNSString型として取得
            [self textSetting:textf Posi:Rect tag:indexPath.row placehold:@""];//テキストフィールドの設定
            cell.textLabel.text=[NSString stringWithFormat : @"時間割%d",indexPath.row+1];
            [cell addSubview:textf];
        }
    }
    //時間割の削除
    if(indexPath.section == 2) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"削除時間割";
            lbSelectDel = [[UILabel alloc] initWithFrame:CGRectMake(140, 2, 200, 38)];
            [cell addSubview:lbSelectDel];
        }else if(indexPath.row==2){
            UILabel *lbDecide;
            lbDecide = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
            lbDecide.textAlignment = NSTextAlignmentCenter;
            lbDecide.textColor = [UIColor redColor];
            lbDecide.text = @"削除";
            [cell addSubview:lbDecide];
        }
    }
    
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
    return cell;
}

//テキストフィールドの設定
- (void)textSetting:(UITextField *)textField Posi:(CGRect)Posi tag:(NSInteger)tag placehold:(NSString *)placehold{
    //    textField.delegate=self;
    textField.frame = Posi;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehold attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;// ReturnキーをDoneに変える
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.tag = tag;
    textField.delegate= self;
}

//UITextfiled終了時処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag==1000) NSTSName= textField.text;
    else NSAName[textField.tag]=textField.text;
    [textField resignFirstResponder];    // キーボードを隠す
    return YES;
}

//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //新規追加入力時
    if ((indexPath.row==1 && indexPath.section==0) || (indexPath.section==2 && indexPath.row==0)) {
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
        
        rowN=indexPath.section*100+indexPath.row;
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 300.0)];
        picker.delegate = self;
        [pickerViewPopup addSubview:pickerToolbar];
        [pickerViewPopup addSubview:picker];
        [pickerViewPopup showInView:self.view];
        [pickerViewPopup setBounds:CGRectMake(0,0,320,500)];
    }
    //新規追加確定時
    if (indexPath.section==0 && indexPath.row==3) {
        ChoiceItem=1;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"確認" message:@"追加してもよろしいですか？"delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }
    //名称変更時
    if (indexPath.section==1 && indexPath.row==TSNum+1) {
        ChoiceItem=2;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"確認" message:@"変更してもよろしいですか？"delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert show];
    }
    //削除確定時
    if (indexPath.section==2 && indexPath.row==2) {
        if (TSNum<=1) {
            ChoiceItem=0;
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"確認" message:@"削除できません"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            ChoiceItem=3;
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"確認" message:@"削除してもよろしいですか？"delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            [alert show];
        }
    }
    
}

/*-------------------------------------------------------------
 
 　　単位数＆曜日時限＆カラー指定ピッカー用
 
 -------------------------------------------------------------*/
//表示列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//表示行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (rowN>=200) return TSNum;
    else return TSNum+1;
}

//行サイズ
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300.0;
}

//表示する値
-(UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel *label;
    NSString *TSName;
    if (view == nil){
        if (rowN<200 && row==0) TSName=@"新規追加";
        else if(rowN<200 && row!=0){
            NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",row];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
            TSName = [userdefault stringForKey:userKey];  // 時間割の名前をNSString型として取得
        }else{
            NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",row+1];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
            TSName = [userdefault stringForKey:userKey];  // 時間割の名前をNSString型として取得
        }
        view = [[UIView alloc] initWithFrame:CGRectZero];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,150.0f,30.0f)];
        label.text=TSName;
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    if (rowN<200) {
        SelectNum =[picker selectedRowInComponent:0];
        if (SelectNum==0) lbSelect.text=@"新規追加";
        else{
            NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",SelectNum];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
            lbSelect.text = [userdefault stringForKey:userKey];  // 時間割の名前をNSString型として取得
        }
    }else{
        SelectNumDel =[picker selectedRowInComponent:0]+1;
        NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",SelectNumDel];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];// 取得
        lbSelectDel.text = [userdefault stringForKey:userKey];  // 時間割の名前をNSString型として取得
    }
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",TSNum+1];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    switch (buttonIndex) {
        case 0://いいえボタン
            break;
        case 1://はいボタン
            if (ChoiceItem==1) {//追加時処理
                [userDef setObject:NSTSName forKey:userKey]; //時間割名の保存
                TSNum=TSNum+1;
                [userDef setInteger:TSNum forKey:@"UD_SET_TSNUM_KEY"]; //時間割数の更新
            
                //時間割の保存
                if(SelectNum==0){//新規追加時
                    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
                    NSArray *NSALec_Info=[[NSArray alloc] initWithObjects:@"", @"", @"",@"", @"", @"",@"", nil];
                    for (int i=0; i<6; i++) {
                        for (int k=0; k<8; k++) {
                            NSString *NSTimeScheTo=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,i+1,k+1];
                            [defaults setObject:NSALec_Info forKey:NSTimeScheTo];
                            [userDef registerDefaults:defaults];
                        }
                    }
                }else{//コピー追加
                    for (int i=0; i<6; i++) {
                        for (int k=0; k<8; k++) {
                            NSString *NSTimeScheFrom=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",SelectNum,i+1,k+1];
                            NSString *NSTimeScheTo=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,i+1,k+1];
                            NSArray* NSALec_Info = [userDef arrayForKey:NSTimeScheFrom];
                            [userDef setObject:NSALec_Info forKey:NSTimeScheTo]; //時間割の保存
                        }
                    }
                    NSString *NSMemoFrom = [NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",SelectNum]; //メモ数
                    NSString *NSMemoTo = [NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TSNum]; //メモ数
                    NSString *NSMemo = [userDef objectForKey:NSMemoFrom]; //メモ数
                    [userDef setObject:NSMemo forKey:NSMemoTo]; //メモ数の保存
                    for (int i=0; i<NSMemo.intValue+1; i++) {
                        NSData* iDataFrom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",SelectNum,i]];
                        NSString *YobiFrom=[userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",SelectNum,i]]; //メモ・時限
                        NSString *DateFrom=[userDef objectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",SelectNum,i]];
                        NSString *MemoFrom = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",SelectNum,i]]; //メモ・メモ
                        NSString *iDataTo = [NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TSNum,i];
                        NSString *YobiTo=[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TSNum,i]; //メモ・時限
                        NSString *DateTo=[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TSNum,i];
                        NSString *MemoTo = [NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TSNum,i]; //メモ・メモ
                        [userDef setObject:YobiFrom forKey:YobiTo];
                        [userDef setObject:MemoFrom forKey:MemoTo];
                        if(iDataFrom) [userDef setObject:iDataFrom forKey:iDataTo];
                        [userDef setObject:DateFrom forKey:DateTo];
                    }
                }
                [userDef synchronize];
                [NSAName addObject:NSTSName];
            }else if(ChoiceItem==2){//名称変更時処理
                for (int i=0; i<TSNum; i++){
                    NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",i+1];
                    [userDef setObject:NSAName[i] forKey:userKey];
                }
                [userDef synchronize];
            }else if(ChoiceItem==3){//削除時
                for (int i=SelectNumDel; i<TSNum; i++) {
                    //名前の削除
                    NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",i];  //削除する時間割名
                    NSString *userKeyU =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",i+1];//上書きする時間割名
                    NSString *textf = [userDef stringForKey:userKeyU];
                    [userDef setObject:textf forKey:userKey]; //時間割の上書き
                    //時間割の削除
                    for (int m=0; m<6; m++) {
                        for (int k=0; k<8; k++) {
                            NSString *userKeyTS=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",i,m+1,k+1];//削除する
                            NSString *userKeyTSU=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",i+1,m+1,k+1];//上書きする
                            NSArray* NSALec_Info = [userDef arrayForKey:userKeyTSU];
                            [userDef setObject:NSALec_Info forKey:userKeyTS]; //時間割の上書き
                            
                            NSString *userKeyJN=[NSString stringWithFormat : @"UD_No%d_JOIN_KEY_x%dy%d",i,m+1,k+1];//削除する
                            NSString *userKeyJNU=[NSString stringWithFormat : @"UD_No%d_JOIN_KEY_x%dy%d",i+1,m+1,k+1];//上書きする
                            NSData* NSMJoin =[userDef objectForKey:userKeyJNU];
                            [userDef setObject:NSMJoin forKey:userKeyJN]; //出席数の上書き
                            
                            NSString *userKeyCM=[NSString stringWithFormat : @"UD_No%d_LEC_COUNT_KEY_x%dy%d",i,m+1,k+1];//削除する
                            NSString *userKeyCMU=[NSString stringWithFormat : @"UD_No%d_LEC_COUNT_KEY_x%dy%d",i+1,m+1,k+1];//上書
                            NSString *NSACount_Info = [userDef stringForKey:userKeyCMU];
                            [userDef setObject:NSACount_Info forKey:userKeyCM]; //講義数の上書き
                        }
                    }
                    
                    //メモの削除
                    NSString *NSMemoFrom = [NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",i]; //削除するメモ数
                    NSString *NSMemoTo = [NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",i+1]; //上書きするメモ数
                    NSString *MemoFrom = [userDef objectForKey:NSMemoFrom]; //メモ数
                    NSString *MemoTo = [userDef objectForKey:NSMemoTo]; //メモ数
                    [userDef setObject:MemoTo forKey:NSMemoFrom]; //メモ数の保存
                    //削除
                    for (int m=0; m<MemoFrom.intValue+1; m++) {
                        [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",i,m]];
                        [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",i,m]];
                        [userDef removeObjectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",i,m]];
                        [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",i,m]];
                    }
                    //上書き
                    for (int n=0; n<MemoTo.intValue+1; n++) {
                        NSString *iDataTo = [NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",i,n];
                        NSString *YobiTo=[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",i,n]; //メモ・時限
                        NSString *DateTo=[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",i,n];
                        NSString *MemoTo = [NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",i,n]; //メモ・メモ
                        
                        NSData* iDataFrom = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",i+1,n]];
                        NSString *YobiFrom=[userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",i+1,n]]; //メモ・時限
                        NSString *DateFrom=[userDef objectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",i+1,n]];
                        NSString *MemoFrom = [userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",i+1,n]]; //メモ・メモ
                        [userDef setObject:YobiFrom forKey:YobiTo];
                        [userDef setObject:MemoFrom forKey:MemoTo];
                        if(iDataFrom) [userDef setObject:iDataFrom forKey:iDataTo];
                        [userDef setObject:DateFrom forKey:DateTo];
                    }
                }
                NSString *userKey =[NSString stringWithFormat : @"UD_SET_TSNAME%d_KEY",TSNum];  //削除する時間割名
                [userDef removeObjectForKey:userKey];  // 物理削除
                //時間割の削除
                for (int m=0; m<6; m++) {
                    for (int k=0; k<8; k++) {
                        NSString *userKeyTS=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,m+1,k+1];//削除する
                        NSString *userKeyJN=[NSString stringWithFormat : @"UD_No%d_JOIN_KEY_x%dy%d",TSNum,m+1,k+1];
                        NSString *userKeyCM=[NSString stringWithFormat : @"UD_No%d_LEC_COUNT_KEY_x%dy%d",TSNum,m+1,k+1];
                        [userDef removeObjectForKey:userKeyTS];  // 物理削除
                        [userDef removeObjectForKey:userKeyJN];  // 物理削除
                        [userDef removeObjectForKey:userKeyCM];  // 物理削除
                    }
                }
                //メモの削除
                NSString *NSMemoFrom = [NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TSNum]; //削除するメモ数
                NSString *MemoFrom = [userDef objectForKey:NSMemoFrom]; //メモ数
                //削除
                for (int m=0; m<MemoFrom.intValue+1; m++) {
                    [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TSNum,m]];
                    [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TSNum,m]];
                    [userDef removeObjectForKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TSNum,m]];
                    [userDef removeObjectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TSNum,m]];
                }
                
                TSNum=TSNum-1;
                [userDef setInteger:TSNum forKey:@"UD_SET_TSNUM_KEY"]; //時間割数の更新
                [userDef synchronize];
            }
            ChoiceItem=0;
            break;
    }
}


@end
