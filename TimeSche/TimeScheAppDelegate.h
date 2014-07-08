//
//  TimeScheAppDelegate.h
//  TimeSche
//
//  Created by hiroshi tokito on 2014/04/30.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMViewController.h"
#import "TSSTableViewController.h"
#import "TSMemoTableViewController.h"
#import "LibList/IIViewDeckController.h"

@interface TimeScheAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIViewController *tab1;
    UITableViewController *tab2;
    UITableViewController *tab3;
    UITabBarController *tabController;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IIViewDeckController *deckController;
@property (strong, nonatomic) NSMutableDictionary* toyBox;// ここになんでもしまっていいよ！

@property (nonatomic,retain) NSString *TimeSche;      //時間割変数受け渡し用
@property (nonatomic,retain) NSString *JoinMem;       //出席記憶変数受け渡し用
@property (nonatomic,retain) NSString *CountMem;      //授業回数記憶変数受け渡し用
@property (nonatomic,retain) NSString *SelectedMemo; //メモ内容受け渡し用

@end
