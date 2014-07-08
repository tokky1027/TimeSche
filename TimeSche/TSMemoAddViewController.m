//
//  TSMemoAddViewController.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/31.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TSMemoAddViewController.h"

@interface TSMemoAddViewController ()

@end

@implementation TSMemoAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// loadView メソッドを追加。
- (void)loadView
{
    // view の frame は親に追加された時に調整されるので、何でも良い。
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // tableView の frame は view.bounds 全体と仮定。他の UI 部品を配置する場合は要調整。
    tableView = [[UITableView alloc] init];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    [view addSubview:tableView];
    
    // 必要に応じて、ここで他の UI 部品を生成。
    self.view = view;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationBar* navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    navBarTop.barTintColor=[UIColor blackColor];
    navBarTop.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    // ナビゲーションアイテムを生成
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"メモの追加"];
    // ボタンを生成
    UIBarButtonItem* btnItemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(BackSc:)];
    UIBarButtonItem* btnItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(BackSc:)];
    // ナビゲーションアイテムにボタンを設置
    title.leftBarButtonItem = btnItemBack;
    title.rightBarButtonItem=btnItemAdd;
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBarTop pushNavigationItem:title animated:YES];
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:navBarTop];
    
    //メモ帳の追加
    [self ScrBuild];
}

-(void)BackSc:(id)sender{
    //画面を戻る（ついでに画面更新）
    [self dismissViewControllerAnimated:YES completion:^{
//        TimeScheAppDelegate *appDelegate = (TimeScheAppDelegate*)[[UIApplication sharedApplication] delegate];
//        TSMViewController *cc = [appDelegate.toyBox objectForKey:@"TSMViewSave"]; //インスタンス召還
//        [cc ChangeTS]; // メソッド呼び出し
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//時間割の描画
- (void)ScrBuild
{
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
    
    if ((indexPath.row==2 || indexPath.row==4 || indexPath.row==5) && indexPath.section==0) {
        rowN=indexPath.row;
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(10.0, 30.0, 300.0, 150.0)];
        picker.delegate = self;
        [pickerViewPopup addSubview:pickerToolbar];
        [pickerViewPopup addSubview:picker];
        [pickerViewPopup showInView:self.view];
        [pickerViewPopup setBounds:CGRectMake(0,0,320,320)];
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
        if (rowN==4){
            label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,150.0f,23.0f)];
            if (component==0) [self DateSetting:label tag:row];
            else label.text=[NSString stringWithFormat : @"%d%@",row+1, @"限"];
        }else if(rowN==5){
            label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,280.0f,23.0f)];
            [self colorSetting:label tag:row];
        }else{
            label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f,0.0f,280.0f,23.0f)];
            label.text = [NSString stringWithFormat:@"%d",row+1];
        }
        [view addSubview:label];
	}
	return view;
}

-(BOOL)closePicker:(id)sender {
    if (rowN==4) {
        [self DateSetting:lbDate tag:[picker selectedRowInComponent:0]];
        NSString *jikanwari=[NSString stringWithFormat : @"%d%@",[picker selectedRowInComponent:1]+1, @"限"];
        lbDate.text =[lbDate.text stringByAppendingString:jikanwari];
    }else if(rowN==5){
        [self colorSetting:lbColor tag:[picker selectedRowInComponent:0]];
        lbColor.tag=[picker selectedRowInComponent:0];
    }
    else lbDeg.text =[NSString stringWithFormat : @"%d%@",[picker selectedRowInComponent:0]+1, @"単位"];
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    return YES;
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
