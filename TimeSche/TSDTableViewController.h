//
//  TSDTableViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/05/01.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSDTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *Lec_Navi_Bar;
@property (weak, nonatomic) IBOutlet UINavigationItem *Lec_Navi;
- (void)ReloadMethod;
@end

