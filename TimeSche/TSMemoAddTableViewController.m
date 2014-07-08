//
//  TSMemoAddTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/06/01.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSMemoAddTableViewController.h"
#import "TimeScheAppDelegate.h"
#import "TSMemoPicViewController.h"

@interface TSMemoAddTableViewController ()

@end
UIPickerView *picker;
UIActionSheet *pickerViewPopup;
UILabel *lbDate,*lbLec,*lbTch,*lbCol;
UITextView *textv;
NSString *NSjikanwari;
NSInteger selectedNo;
UIImage *image;
BOOL UPDATE;

@implementation TSMemoAddTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];

    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate *)[[UIApplication sharedApplication] delegate];
    selectedNo = appDelegate.SelectedMemo.intValue;
    UPDATE=0;
    
    //ナビゲーションバー設定
    self.Navi_Bar_Nya.frame=CGRectMake(0, 0, 320, 65);
    NSString *btnleft,*btnright;
    if (selectedNo<0) {
        btnleft = @"Add";
        btnright= @"Cancel";
        NSjikanwari=nil;
        self.Navi_Bar_Item_Nya.title=@"メモの追加";
    }else{
        btnleft = @"Done";
        btnright= @"Delete";
        self.Navi_Bar_Item_Nya.title=@"メモの編集";
    }
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithTitle:btnright style:UIBarButtonItemStyleBordered target:self action:@selector(BackSc:)];
    UIBarButtonItem *btnA =[[UIBarButtonItem alloc]initWithTitle:btnleft style:UIBarButtonItemStyleBordered target:self action:@selector(BackAdd:)];
    self.Navi_Bar_Item_Nya.leftBarButtonItem = btn;
    self.Navi_Bar_Item_Nya.rightBarButtonItem = btnA;

    image=nil;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackSc:(id)sender{
    //Delete時
    if (selectedNo>=0) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
        NSString *NSMemo=[userDef objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]];//メモ数
        
        for (NSInteger i=selectedNo; i<NSMemo.intValue; i++) {
            //メモ削除＆上書き
            NSString *userKeyTS =[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,i]; //削除メモの時間割
            NSString *userKeyTSU=[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,i+1];//上書きメモ時間割
            NSString *textf = [userDef stringForKey:userKeyTSU];
            [userDef setObject:textf forKey:userKeyTS]; //上書き
            
            NSString *userKeyMemo =[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,i];//削除メモ情報
            NSString *userKeyMemoU=[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,i+1];//上書きメモ
            NSString *textfm = [userDef stringForKey:userKeyMemoU];
            [userDef setObject:textfm forKey:userKeyMemo]; //上書き
            
            NSString *userKeyPic =[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,i];//削除写真情報
            NSString *userKeyPicU=[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,i+1];//上書き写真
            NSData *Pic = [userDef objectForKey:userKeyPicU];
            [userDef setObject:Pic forKey:userKeyPic]; //上書き
            
            NSString *userKeyDate =[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TS_No,i];//削除日時情報
            NSString *userKeyDateU=[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TS_No,i+1];//上書きメモ
            NSString *textfd = [userDef stringForKey:userKeyDateU];
            [userDef setObject:textfd forKey:userKeyDate]; //上書き
            
            NSString *userKeyDate2 =[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE2_KEY",TS_No,i];//削除日時情報
            NSString *userKeyDate2U=[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE2_KEY",TS_No,i+1];//上書きメモ
            NSString *textfd2 = [userDef stringForKey:userKeyDate2U];
            [userDef setObject:textfd2 forKey:userKeyDate2]; //上書き
        }
        //ラストを物理削除
        [userDef removeObjectForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,NSMemo.intValue]];
        [userDef removeObjectForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,NSMemo.intValue]];
        [userDef removeObjectForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,NSMemo.intValue]];
        [userDef removeObjectForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TS_No,NSMemo.intValue]];
        [userDef removeObjectForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_DATE2_KEY",TS_No,NSMemo.intValue]];
        //メモ数を１つ減らして更新
        [userDef setObject:[NSString stringWithFormat : @"%d",NSMemo.intValue-1] forKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]];
        [userDef synchronize];
    }
    
    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
        TSMemoTableViewController *dd = [appDelegate.toyBox objectForKey:@"TSMemoViewSave"]; //インスタンス召還
        [dd.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新
    }];
}

-(void)BackAdd:(id)sender{
    //記憶領域保存用
    if (NSjikanwari!=nil) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
        
        //日付取得
        NSDate *nowdate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *data = [formatter stringFromDate:nowdate];
        NSString *data2 = [NSString stringWithFormat:@"更新：%@",data];
        
        //画像変換
        NSData *iData = UIImagePNGRepresentation(image);
        
        if (selectedNo<0) {
            //メモ数の取得
            NSInteger TSNum=[userDef integerForKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]];
            TSNum=TSNum+1;
    
            [userDef setObject:NSjikanwari forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,TSNum]];
            [userDef setObject:textv.text forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,TSNum]];
            if(iData) [userDef setObject:iData forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,TSNum]];
            [userDef setInteger:TSNum forKey:[NSString stringWithFormat : @"UD_No%d_SET_MEMO_NUM_KEY",TS_No]];
            [userDef setObject:data forKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE_KEY",TS_No,TSNum]];
        }else{
            [userDef setObject:NSjikanwari forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,selectedNo]];
            [userDef setObject:textv.text forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,selectedNo]];
            if(iData) [userDef setObject:iData forKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,selectedNo]];
            if (UPDATE)[userDef setObject:data2 forKey:[NSString stringWithFormat :@"UD_No%d_SET_No%d_MEMO_DATE2_KEY",TS_No,selectedNo]];
        }
        [userDef synchronize];
        UPDATE=0;
    
        //画面を戻る（ついでに画面更新）
        [self dismissViewControllerAnimated:YES completion:^{
            TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
            TSMemoTableViewController *dd = [appDelegate.toyBox objectForKey:@"TSMemoViewSave"]; //インスタンス召還
            [dd.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];//テーブル更新
        }];
    }
}


#pragma mark - Table view data source
//セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) return 21;
    if (indexPath.row==3) return 200;
    if (indexPath.row==4) return 100;
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
    CGRect frame=CGRectMake(120, 3, 200, 40);
    
    NSData* iData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,selectedNo]];//画像データ
    
    switch (indexPath.row) {
        case 1://曜日時限
        {
            lbDate = [[UILabel alloc] initWithFrame:frame];
            if (selectedNo>=0) {
                lbDate.text=[userDef stringForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_TS_KEY",TS_No,selectedNo]];
                NSjikanwari =lbDate.text;
            }
            cell.textLabel.text=@"曜日時限";
            [cell addSubview:lbDate];
            break;
        }
        case 2://講義名
        {
            lbLec = [[UILabel alloc] initWithFrame:frame];
            if (selectedNo>=0) [self DateGetting:NSjikanwari];
            cell.textLabel.text=@"講義名";
            [cell addSubview:lbLec];
            break;
        }
        case 3:
        {
            //メモ・textview
            textv = [[UITextView alloc] initWithFrame:CGRectMake(15, 28, 290, 170)];
            textv.layer.borderWidth = 0.5;
            textv.layer.borderColor = [[UIColor blackColor] CGColor];
            textv.editable = YES;
            textv.text=[userDef stringForKey:[NSString stringWithFormat:@"UD_No%d_SET_No%d_MEMO_MEMO_KEY",TS_No,selectedNo]];
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)]; //textviewツールバーを編集
            toolBar.barStyle = UIBarStyleBlackOpaque; // スタイルを設定
            [toolBar sizeToFit];
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]; // フレキシブルスペース作成（Doneボタン配置のため）
            UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)]; // Doneボタンの作成
            // ボタンをToolbarに設定
            NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
            [toolBar setItems:items animated:YES];
            textv.inputAccessoryView = toolBar; // ToolbarをUITextFieldのinputAccessoryViewに設定
            [cell addSubview:textv];            //画面に追加
            
            //メモ・カメラ
            if(iData == nil){
                UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraOpen:)];
                UIToolbar *toolBarb = [[UIToolbar alloc] initWithFrame:CGRectMake(25, 0, 290, 28)]; //ツールバーを編集
                toolBarb.barTintColor = [UIColor whiteColor]; // スタイルを設定
                // ボタンをToolbarに設定
                NSArray *itemsC = [NSArray arrayWithObjects:spacer, camera, nil];
                [toolBarb setItems:itemsC animated:YES];
                [cell addSubview:toolBarb];
            }

            //メモ・ラベル
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(15, 3, 50, 25)];
            lb.font = [UIFont boldSystemFontOfSize:14];
            lb.text=@"メモ";
            [cell addSubview:lb];
            
            break;
        }
        case 4:
        {
            if(iData)cell.imageView.image = [UIImage imageWithData:iData];
            break;
        }
            
        default:
            break;
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
    return cell;
}

//メモ記入用textviewのdoneボタンが押されたときの処理
-(void)closeKeyboard:(id)sender{
    UPDATE=1;
	[textv resignFirstResponder];
}

//カメラ起動
-(void)cameraOpen:(id)sender{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ) {
        // UIImageControllerの初期化
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];//カメラ起動
        [ipc setDelegate:self];            // Delegateをセット
        [ipc setAllowsEditing:YES];        // NOを設定するとイメージを取得できない
        [self presentViewController: ipc animated:YES completion: nil];// 指定したViewを一番上に表示する
    }
}
//カメラ画像撮影後、保存用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 選択したイメージをUIImageにセットする
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self ImageSetting:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)ImageSetting:(UIImage *)imageL {
    UIImage *imageEdit=imageL;
    //画像縮小
    CGRect rect = CGRectMake(0, 0, 120, 120);
    UIGraphicsBeginImageContext(rect.size);
    [imageEdit drawInRect:rect];
    
    // 非表示領域を設定（四角形）
    CGRect exclusionRect = CGRectMake(0, 80, 120, 120);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:exclusionRect];
    // テキストビューに設定
    textv.textContainer.exclusionPaths = @[path];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageEdit];
    imageView.frame = exclusionRect;
    [textv addSubview:imageView];
}


//セルクリックデリゲート
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    if (indexPath.row==1) {
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 300.0)];
        picker.delegate = self;
        [pickerViewPopup addSubview:pickerToolbar];
        [pickerViewPopup addSubview:picker];
        [pickerViewPopup showInView:self.view];
        [pickerViewPopup setBounds:CGRectMake(0,0,320,500)];
    }
    if (indexPath.row==4) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSInteger TS_No=[userDef integerForKey:@"UD_SET_TSNOW_KEY"];
        NSData* iData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat : @"UD_No%d_SET_No%d_MEMO_PIC_KEY",TS_No,selectedNo]];//画像データ
        if(iData){//画像があれば画面遷移
            TSMemoPicViewController *TSP =[[TSMemoPicViewController alloc] initWithNibName:@"TSMemoPicViewController" bundle:nil];
            [self presentViewController:TSP animated:NO completion:nil];
            
        }

    }
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
    if (component==0) return 6;
    else return 8;
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
        if (component==0) [self DateSetting:label tag:row];
        else label.text=[NSString stringWithFormat : @"%d%@",row+1, @"限"];
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    [self DateSetting:lbDate tag:[picker selectedRowInComponent:0]];
    NSString *jikanwari=[NSString stringWithFormat : @"%d%@",[picker selectedRowInComponent:1]+1, @"限"];
    lbDate.text =[lbDate.text stringByAppendingString:jikanwari];
    NSjikanwari =lbDate.text;
    
    //記憶領域からデータを読込
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSInteger TSNum = [userdefault integerForKey:@"UD_SET_TSNOW_KEY"];  // 時間割表番号の取得
    NSString* NSTimeSche=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,[picker selectedRowInComponent:0]+1,[picker selectedRowInComponent:1]+1];
    NSArray* NSALec_Info = [userdefault arrayForKey:NSTimeSche];
            
    lbLec.text =NSALec_Info[0];
    UPDATE=1;
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

- (void)DateGetting:(NSString *)YobiJigen {
    NSString *Yobi = [YobiJigen substringWithRange:NSMakeRange(0,1)];
    NSString *Jigen = [YobiJigen substringWithRange:NSMakeRange(2,1)];
    NSInteger iYobi, iJigen;
    
    if ([Yobi isEqualToString:@"月"]) iYobi=1;
    else if ([Yobi isEqualToString:@"火"]) iYobi=2;
    else if ([Yobi isEqualToString:@"水"]) iYobi=3;
    else if ([Yobi isEqualToString:@"木"]) iYobi=4;
    else if ([Yobi isEqualToString:@"金"]) iYobi=5;
    else if ([Yobi isEqualToString:@"土"]) iYobi=6;
    iJigen = Jigen.intValue;
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSInteger TSNum = [userdefault integerForKey:@"UD_SET_TSNOW_KEY"];  // 時間割表番号の取得
    NSString* NSTimeSche=[NSString stringWithFormat : @"UD_No%d_LEC_KEY_x%dy%d",TSNum,iYobi,iJigen];
    NSArray* NSALec_Info = [userdefault arrayForKey:NSTimeSche];
    lbLec.text =NSALec_Info[0];
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
