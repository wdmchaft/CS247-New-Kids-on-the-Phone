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
	Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
	character.scene = sceneObj;
	character.name = @"";
	
	NSString *timestring = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] stringValue];
	NSString *filename = [NSString stringWithFormat:@"%s.jpg", timestring, nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPaths = [paths objectAtIndex:0];
	NSString *savePath = [docPaths stringByAppendingPathComponent:filename];
	
	[UIImageJPEGRepresentation(tiv.image, 0.3) writeToFile:savePath atomically:YES];
	
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
	return character;
	
}

@end
