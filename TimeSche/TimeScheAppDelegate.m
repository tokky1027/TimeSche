//
//  TimeScheAppDelegate.m
//  TimeSche
//
//  Created by hiroshi tokito on 2014/04/30.
//  Copyright (c) 2014年 PikkyCorp. All rights reserved.
//

#import "TimeScheAppDelegate.h"
#import "TSAddTableViewController.h"
#import "LibList/IIViewDeckController.h"

@implementation TimeScheAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.toyBox = [[NSMutableDictionary alloc] init]; // お片づけ箱を確保
    
    self.deckController = [self generateControllerStack];
    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (IIViewDeckController*)generateControllerStack
{
    // タブの中身（UIViewController）をインスタンス化
    tab1 = [[TSMViewController alloc]init]; // タブ1
    tab3 = [[TSSTableViewController alloc]init]; // タブ2
    tab2 = [[TSMemoTableViewController alloc]init]; // タブ2
    NSArray *tabs = [NSArray arrayWithObjects:tab1, tab2, tab3,nil];
    // タブコントローラをインスタンス化
    tabController = [[UITabBarController alloc]init];
    // タブコントローラにタブの中身をセット
    [tabController setViewControllers:tabs animated:NO];
    //ナビゲーションバーのインスタンス化
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabController];
    
    //左テーブルをインスタンス化
    TSAddTableViewController* menu =[[TSAddTableViewController alloc]init];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navi leftViewController:menu];
    deckController.leftSize = 150;
    
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    
    [self.toyBox setObject:menu forKey:@"TSAddTableViewSave"];
    [self.toyBox setObject:tab1 forKey:@"TSMViewSave"];
    [self.toyBox setObject:tab2 forKey:@"TSMemoViewSave"];
    return deckController;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
