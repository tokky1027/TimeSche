//
//  TSJTableViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/02.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSJTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *Join_Navi;
@property (weak, nonatomic) IBOutlet UINavigationBar *Join_Navi_bar;

@end
