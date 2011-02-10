//
//  CS247_iPhoneAppDelegate.h
//  CS247_iPhone
//
//  Created by Elliot Babchick on 2/6/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CS247_iPhoneViewController;
@class GameKitCommunicatorViewController;

@interface CS247_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
     GameKitCommunicatorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GameKitCommunicatorViewController *viewController;

@end

