//
//  CS247_iPadAppDelegate.h
//  CS247_iPad
//
//  Created by Elliot Babchick on 2/6/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CS247_iPadViewController;
@class GameKitCommunicatorViewController;

@interface CS247_iPadAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	GameKitCommunicatorViewController *viewController;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet GameKitCommunicatorViewController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
