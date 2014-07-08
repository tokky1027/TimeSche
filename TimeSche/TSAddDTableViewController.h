//
//  TSAddDTableViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/18.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSAddDTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITabBarDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *TSAddD_Navi;
@property (weak, nonatomic) IBOutlet UINavigationItem *TSAddD_Navi_Item;

@end
