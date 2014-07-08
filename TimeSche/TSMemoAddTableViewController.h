//
//  TSMemoAddTableViewController.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/06/01.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSMemoAddTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *Navi_Bar_Nya;
@property (weak, nonatomic) IBOutlet UINavigationItem *Navi_Bar_Item_Nya;

@end
