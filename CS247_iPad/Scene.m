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
@dynamic audio;
@dynamic name;
@dynamic characters;
@dynamic background;


+ (Scene *)sceneWithBackground:(Background *)bground inManagedObjectContext:(NSManagedObjectContext *)context {
	Scene *scene = nil;
	
	
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	request.entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:context];
//	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", exerName];
//	
//	Scene = [[context executeFetchRequest:request error:&error] lastObject];
	

	scene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:context];
	scene.time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	scene.background = bground;
	
	//save any changes
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error])
	{
		NSLog(@"Error! %@, %@", error, [error userInfo]);
		abort();
	}
	return scene;
}

+ (Scene *)sceneInManagedObjectContext:(NSManagedObjectContext *)context {
	Scene *scene = nil;

	// get the narration.aif sound file
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	NSURL *soundURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"narration.aif"]];
	NSData *soundData = [NSData dataWithContentsOfURL:soundURL];
	scene.audio = soundData;
	
	scene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:context];
	scene.time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	scene.name = @"";
	
	//save any changes
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error])
	{
		NSLog(@"Error! %@, %@", error, [error userInfo]);
		abort();
	}
	return scene;
}



@end
