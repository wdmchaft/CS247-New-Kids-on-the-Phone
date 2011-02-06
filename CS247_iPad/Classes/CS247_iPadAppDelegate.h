//
//  CS247_iPadAppDelegate.h
//  CS247_iPad
//
//  Created by Elliot Babchick on 2/6/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CS247_iPadViewController;

@interface CS247_iPadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CS247_iPadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CS247_iPadViewController *viewController;

@end

