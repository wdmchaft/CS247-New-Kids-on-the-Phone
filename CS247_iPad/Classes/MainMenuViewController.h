//
//  MainMenuViewController.h
//  CS247_iPad
//
//  Created by Elliot Babchick on 3/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKitCommunicatorViewController.h"
#import "SceneCoreDataTableViewController.h"

@interface MainMenuViewController : UIViewController {
	IBOutlet UIButton *newButton;
	IBOutlet UIButton *loadButton;
	IBOutlet UIButton *castleButton;
	IBOutlet UIButton *oceanButton;
	IBOutlet UIButton *spaceButton;
	IBOutlet UIButton *sunnyButton;
	
	IBOutlet UIView  *newView;
	IBOutlet UILabel *lab1;
	IBOutlet UILabel *lab2;
	IBOutlet UILabel *lab3;
	IBOutlet UILabel *lab4;
	IBOutlet UILabel *lab5;
	
	IBOutlet UIView  *loadView;

	GameKitCommunicatorViewController* gk;
	
	SceneCoreDataTableViewController *sceneTableViewController;
	
	NSManagedObjectContext *managedObjectContext;

}

-(IBAction) newClicked:(id)sender;
-(IBAction) loadClicked:(id)sender;
-(IBAction) castleClicked:(id)sender;
-(IBAction) oceanClicked:(id)sender;
-(IBAction) spaceClicked:(id)sender;
-(IBAction) sunnyClicked:(id)sender;

@property (nonatomic,retain)	GameKitCommunicatorViewController* gk;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
