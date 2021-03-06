//
//  Scene.h
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Background;
@class Character;

@interface Scene :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSData * animation;
@property (nonatomic, retain) NSString * audioFile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* characters;
@property (nonatomic, retain) NSNumber* background;


+ (Scene *)sceneInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Scene *)sceneName:(NSString *)sceneName withBackground:(NSNumber *)bground inManagedObjectContext:(NSManagedObjectContext *)context;

@end


@interface Scene (CoreDataGeneratedAccessors)
- (void)addCharactersObject:(Character *)value;
- (void)removeCharactersObject:(Character *)value;
- (void)addCharacters:(NSSet *)value;
- (void)removeCharacters:(NSSet *)value;

@end

