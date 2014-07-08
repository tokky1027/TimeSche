//
//  TSJTableViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/02.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSJTableViewController.h"
#import "TSDTableViewController.h"
#import "TimeScheAppDelegate.h"

@interface TSJTableViewController ()

@end
UIPickerView *picker;
UIDatePicker *dpicker;
NSMutableArray *NSAJoin;
NSString *NSCon;
UIActionSheet *pickerViewPopup;
NSInteger rowN;

@implementation TSJTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //記憶領域に保存したタグ名の呼び出し
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *FKC = appDelegate.CountMem;
    NSString *FKJ = appDelegate.JoinMem;    
    
    //記憶領域読込用
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    NSAJoin = [[NSMutableArray alloc] init];
    for (int i=0; i<50; i++) [NSAJoin addObject:@"未登録"];
    NSData *DataJoin = [NSKeyedArchiver archivedDataWithRootObject:NSAJoin];
    //初期値
    [defaults setObject:DataJoin forKey:FKJ];
    [userDef registerDefaults:defaults];
    [defaults setObject:@"15" forKey:FKC];
    [userDef registerDefaults:defaults];
    
    //ナビゲーションバー設定
    self.Join_Navi_bar.frame=CGRectMake(0, 0, 320, 65);
    UIBarButtonItem *btn =[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(BackSc:)];
    self.Join_Navi.leftBarButtonItem = btn;
    //記憶領域からデータを読込
    NSCon = [userDef objectForKey:FKC];
    DataJoin = [userDef objectForKey:FKJ];
    NSAJoin = [NSKeyedUnarchiver unarchiveObjectWithData:DataJoin];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)BackSc:(id)sender{
    //記憶領域に保存したタグ名の呼び出し
    TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //記憶領域保存用
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *DataJoin = [NSKeyedArchiver archivedDataWithRootObject:NSAJoin];
    [userDef setObject:DataJoin forKey:appDelegate.JoinMem];
    [userDef setObject:NSCon forKey:appDelegate.CountMem];
    [userDef synchronize];
    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
        TSDTableViewController *dd = [[TSDTableViewController alloc] init]; // クラス呼び出し
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
    return 2;
}
//セクション名
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"出席状況";
            break;
        case 1: // 2個目のセクションの場合
            return @"詳細";
            break;
    }
    return nil;
}

//セル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case 0: // 1個目のセクションの場合
            return 2;
            break;
        case 1: // 2個目のセクションの場合
            return NSCon.intValue;
            break;
    }
    return 0;
    
}

// セルの高さ
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section == 0 && indexPath.row==0) cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    else cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: //出席状況
            {
                int Join=0,Abs=0,Del=0,Canc=0;
                for (int i=0; i<NSCon.intValue; i++) {
                    if([NSAJoin[i] isEqualToString:@"出席"]) Join++;
                    else if([NSAJoin[i] isEqualToString:@"欠席"]) Abs++;
                    else if([NSAJoin[i] isEqualToString:@"遅刻"]) Del++;
                    else if([NSAJoin[i] isEqualToString:@"休講"]) Canc++;
                }
                UILabel *lbD = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 320, 35)];
                lbD.font = [UIFont fontWithName:@"AppleGothic" size:14];
                lbD.text =[NSString stringWithFormat : @"出席：%d　 欠席：%d　 遅刻：%d　 休講：%d",Join,Abs,Del,Canc];
                [cell addSubview:lbD];
                break;
            }
            case 1: //講義回数
            {
                cell.detailTextLabel.text=NSCon;
                cell.textLabel.text=@"講義回数";//ラベル
                break;
            }
            default:
                break;
        }
    }
    //出席状況
    if(indexPath.section == 1) {
        cell.textLabel.text=[NSString stringWithFormat : @"%d回目",indexPath.row+1];;//ラベル
        cell.detailTextLabel.text=NSAJoin[indexPath.row];
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
    return cell;
}

//テキストフィールドの設定
- (void)textSetting:(UITextField *)textField Posi:(CGRect)Posi tag:(int)tag placehold:(NSString *)placehold{
//    textField.delegate=self;
    textField.frame = Posi;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehold attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;// ReturnキーをDoneに変える
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.tag = tag;
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
    
    if (!(indexPath.row==0 && indexPath.section==0)) {
        rowN=indexPath.section*100+indexPath.row;
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 300.0)];
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
    return 1;
}

//表示行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (rowN==1) return 50;
    return 4;
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
        if (rowN==1) label.text=[NSString stringWithFormat : @"%d",row+1];
        else{
            switch(row) {
                case 0:
                    label.text = @"出席";
                    break;
                case 1:
                    label.text = @"欠席";
                    break;
                case 2:
                    label.text = @"遅刻";
                    break;
                case 3:
                    label.text = @"休講";
                    break;
            }
        }
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    if (rowN==1){
        NSCon =[NSString stringWithFormat : @"%d",[picker selectedRowInComponent:0]+1];
    }else{
        switch([picker selectedRowInComponent:0]) {
            case 0:
                NSAJoin[rowN-100] = @"出席";
                break;
            case 1:
                NSAJoin[rowN-100] = @"欠席";
                break;
            case 2:
                NSAJoin[rowN-100] = @"遅刻";
                break;
            case 3:
                NSAJoin[rowN-100] = @"休講";
                break;
        }
    }
    [self.tableView reloadData];
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
}

@end
