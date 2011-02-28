//
//  Character.h
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TouchImageView.h"
#import "Scene.h"

@interface Character :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData *animation;
@property (nonatomic, retain) NSNumber *defaultSize;
@property (nonatomic, retain) NSData *image;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSManagedObject *scene;

+ (Character *)characterForTouchImageView:(TouchImageView *)tiv inScene:(Scene *)sceneObj inManagedObjectContext:(NSManagedObjectContext *)context;

@end
