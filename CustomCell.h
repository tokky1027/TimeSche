//
//  CustomCell.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/06/28.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbJigen;
@property (weak, nonatomic) IBOutlet UILabel *lbMemo;
@property (weak, nonatomic) IBOutlet UILabel *lbClock;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage;
@property (weak, nonatomic) IBOutlet UILabel *lbNowClock;

@property (weak, nonatomic) IBOutlet UIButton *Badd;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@end
