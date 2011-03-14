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


+ (Scene *)sceneName:(NSString *)sceneName withBackground:(NSString *)bground inManagedObjectContext:(NSManagedObjectContext *)context {
	Scene *scene = nil;
	
	NSLog(@"creating scene: %@", sceneName);
	
	scene = [Scene sceneInManagedObjectContext:context];
	
	scene.name = sceneName;
	
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
	scene = [NSEntityDescription insertNewObjectForEntityForName:@"Scene" inManagedObjectContext:context];

	NSString *timestring = [NSString stringWithFormat:@"%f", ([[NSDate date] timeIntervalSince1970] * 1000000)];
	timestring = [[timestring componentsSeparatedByString:@"."] objectAtIndex:0];
	//NSLog(@"timestring: %@", timestring);
	NSString *filename = [NSString stringWithFormat:@"%@.aif", timestring, nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPaths = [paths objectAtIndex:0];
	NSString *savePath = [docPaths stringByAppendingPathComponent:filename];
	
	// get the narration.aif sound file
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	//NSURL *soundURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"narration.aif"]];
	NSString *soundPath = [cacheDirectory stringByAppendingPathComponent:@"narration.aif"];
	NSData *soundData = [NSData dataWithContentsOfFile:soundPath];
	
	NSLog(@"saving audio at %@", savePath);
	
	[soundData writeToFile:savePath atomically:YES];
	scene.audioFile = savePath;
	
	scene.time = timestring;
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
