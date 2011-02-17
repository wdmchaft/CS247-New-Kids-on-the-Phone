// 
//  Scene.m
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "Scene.h"

#import "Background.h"
#import "Character.h"

@implementation Scene 

@dynamic time;
@dynamic animation;
@dynamic audioFile;
@dynamic name;
@dynamic characters;
@dynamic background;


+ (Scene *)SceneWithBackground:(Background *)bground inManagedObjectContext:(NSManagedObjectContext *)context {
	Scene *scene = nil;
	
	
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	request.entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:context];
//	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", exerName];
//	
//	NSError *error = nil;
//	Scene = [[context executeFetchRequest:request error:&error] lastObject];
	
	scene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:context];
	scene.time = [[NSDate date] timeIntervalSince1970]];
	scene.background = bground;
	
	//save any changes
	if ([context hasChanges] && ![context save:&error])
	{
		NSLog(@"Error! %@, %@", error, [error userInfo]);
		abort();
	}
	return scene;
}



@end
