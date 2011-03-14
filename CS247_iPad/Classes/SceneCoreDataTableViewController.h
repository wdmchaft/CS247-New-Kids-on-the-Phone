//
//  SceneCoreDataTableViewController.h
//  CS247_iPad
//
//  Created by Clayton Mellina on 3/14/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"


@interface SceneCoreDataTableViewController : CoreDataTableViewController {

}

- initInManagedObjectContext:(NSManagedObjectContext *)context;

@end
