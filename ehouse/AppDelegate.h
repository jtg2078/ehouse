//
//  AppDelegate.h
//  ehouse
//
//  Created by jason on 1/10/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, IIViewDeckControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) RootViewController *homeViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
