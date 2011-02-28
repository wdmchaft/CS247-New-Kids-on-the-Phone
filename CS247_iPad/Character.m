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
@dynamic image, name, time, defaultSize, animation, scene;

+ (Character *)characterForTouchImageView:(TouchImageView *)tiv inScene:(Scene *)sceneObj inManagedObjectContext:(NSManagedObjectContext *)context {
	Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:context];
	character.scene = sceneObj;
	character.name = @"";
	character.image = UIImagePNGRepresentation(tiv.image);
	character.animation = [NSKeyedArchiver archivedDataWithRootObject:tiv.animationSequence];
	character.time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
	
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
