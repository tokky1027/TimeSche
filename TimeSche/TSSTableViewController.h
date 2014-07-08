//
//  TSSTableViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/05.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *Navi_Setting_Bar;
@property (weak, nonatomic) IBOutlet UINavigationItem *Navi_Setting;

@end
