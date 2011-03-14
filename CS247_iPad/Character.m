// 
//  Character.m
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "Character.h"
#import <UIKit/UIKit.h>

@implementation Character 
@dynamic imageFile, name, time, defaultSize, animation, scene;

+ (Character *)characterForTouchImageView:(TouchImageView *)tiv inScene:(Scene *)sceneObj inManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"tiv ptr: %i  img ptr: %i", tiv, tiv.image);
	
	Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
	character.scene = sceneObj;
	character.name = @"";

	NSString *timestring = [NSString stringWithFormat:@"%f", ([[NSDate date] timeIntervalSince1970] * 1000000)];
	timestring = [[timestring componentsSeparatedByString:@"."] objectAtIndex:0];
	//NSLog(@"timestring: %@", timestring);
	NSString *filename = [NSString stringWithFormat:@"%@.jpg", timestring, nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPaths = [paths objectAtIndex:0];
	NSString *savePath = [docPaths stringByAppendingPathComponent:filename];
	
	NSLog(@"saving image at %@", savePath);
	
	NSData *imgData = UIImageJPEGRepresentation(tiv.image, 0.1);
	[imgData writeToFile:savePath atomically:YES];
	
	character.imageFile = savePath;
	//NSLog(@"saving bytes: %i", [character.imageFile length]);
	character.animation = [NSKeyedArchiver archivedDataWithRootObject:tiv.animationSequence];
	character.time = timestring;
	
	//save any changes
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error])
	{
		NSLog(@"Error! %@, %@", error, [error userInfo]);
		abort();
	}
	
	[p drain];
	
	return character;
	
}

@end
