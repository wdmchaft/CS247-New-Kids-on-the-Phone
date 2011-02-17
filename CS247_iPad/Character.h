//
//  Character.h
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Character :  NSManagedObject  
{
}

- (NSNumber *)defaultSize;
- (void)setDefaultSize:(NSNumber *)value;

- (NSData *)image;
- (void)setImage:(NSData *)value;

- (NSString *)name;
- (void)setName:(NSString *)value;

- (NSNumber *)time;
- (void)setTime:(NSNumber *)value;

@end
