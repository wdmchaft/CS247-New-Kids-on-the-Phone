    //
//  MainMenuViewController.m
//  CS247_iPad
//
//  Created by Elliot Babchick on 3/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "MainMenuViewController.h"


@implementation MainMenuViewController
@synthesize gk;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	castleButton.alpha = 0;
	sunnyButton.alpha = 0;
	spaceButton.alpha = 0;
	oceanButton.alpha = 0;
	lab1.alpha = 0;
	lab2.alpha = 0;
	lab3.alpha = 0;
	lab4.alpha = 0;
	lab5.alpha = 0;
	newView.alpha = 0;
    [super viewDidLoad];
	
}


-(IBAction) newClicked:(id)sender{
	[UIView animateWithDuration:1 animations:^{ 
		castleButton.alpha = 1;
		sunnyButton.alpha = 1;
		spaceButton.alpha = 1;
		oceanButton.alpha = 1;
		lab1.alpha = 1;
		lab2.alpha = 1;
		lab3.alpha = 1;
		lab4.alpha = 1;
		lab5.alpha = 1;
		newView.alpha = 1;
	} completion:^(BOOL finished) {}];
}
-(IBAction) loadClicked:(id)sender{
	if (castleButton.alpha == 1){
		[UIView animateWithDuration:1 animations:^{ 
			castleButton.alpha = 0;
			sunnyButton.alpha = 0;
			spaceButton.alpha = 0;
			oceanButton.alpha = 0;
			lab1.alpha = 0;
			lab2.alpha = 0;
			lab3.alpha = 0;
			lab4.alpha = 0;
			lab5.alpha = 0;
			newView.alpha = 0;
		} completion:^(BOOL finished) {}];
	}
}
-(IBAction) castleClicked:(id)sender{
	[gk backgroundPicked:0];
	[gk dismissModalViewControllerAnimated:YES];
}
-(IBAction) oceanClicked:(id)sender{
	[gk backgroundPicked:1];
	[gk dismissModalViewControllerAnimated:YES];
}
-(IBAction) spaceClicked:(id)sender{
	[gk backgroundPicked:2];
	[gk dismissModalViewControllerAnimated:YES];
}
-(IBAction) sunnyClicked:(id)sender{
	[gk backgroundPicked:3];
	[gk dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
