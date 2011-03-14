//
//  SceneCoreDataTableViewController.m
//  CS247_iPad
//
//  Created by Clayton Mellina on 3/14/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "SceneCoreDataTableViewController.h"


@implementation SceneCoreDataTableViewController

@synthesize menu;

- (SceneCoreDataTableViewController *)initInManagedObjectContext:(NSManagedObjectContext *)context
{
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:context];
		request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
																						 ascending:YES
																						  selector:@selector(caseInsensitiveCompare:)]];
		request.fetchBatchSize = 20;
		
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
										   initWithFetchRequest:request
										   managedObjectContext:context
										   sectionNameKeyPath:nil
										   cacheName:nil];
		
		[request release];
		
		self.fetchedResultsController = frc;
		[frc release];
		
		self.titleKey = @"name";
	}
	return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
	[self.menu loadScene:managedObject];
	
	/*
	GraphViewController *gvc = [[GraphViewController alloc] initWithExercise:(Exercise *)managedObject inManagedObjectContext:self.fetchedResultsController.managedObjectContext]; 
	gvc.title = @"Graph";
	if (gvc.view.window == nil) {
		[self.navigationController pushViewController:gvc animated:YES];
	}
	 */
}

- (void)dealloc {
	[menu release];
	[super dealloc];
}


@end
