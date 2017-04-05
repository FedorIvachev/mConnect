//
//  AppDelegate.h
//  try7
//
//  Created by Fedor Ivachev on 22.03.17.
//  Copyright © 2017 MSU CMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <VKSdk.h>
#import "TestViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end
