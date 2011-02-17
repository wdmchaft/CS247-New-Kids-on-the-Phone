// 
//  Character.m
//  CS247_iPad
//
//  Created by Clayton Mellina on 2/16/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "Character.h"


@implementation Character 

- (NSNumber *)defaultSize 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey:@"defaultSize"];
    tmpValue = [self primitiveValueForKey:@"defaultSize"];
    [self didAccessValueForKey:@"defaultSize"];
    
    return tmpValue;
}

- (void)setDefaultSize:(NSNumber *)value 
{
    [self willChangeValueForKey:@"defaultSize"];
    [self setPrimitiveValue:value forKey:@"defaultSize"];
    [self didChangeValueForKey:@"defaultSize"];
}

- (NSData *)image 
{
    NSData * tmpValue;
    
    [self willAccessValueForKey:@"image"];
    tmpValue = [self primitiveValueForKey:@"image"];
    [self didAccessValueForKey:@"image"];
    
    return tmpValue;
}

- (void)setImage:(NSData *)value 
{
    [self willChangeValueForKey:@"image"];
    [self setPrimitiveValue:value forKey:@"image"];
    [self didChangeValueForKey:@"image"];
}

- (NSString *)name 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey:@"name"];
    tmpValue = [self primitiveValueForKey:@"name"];
    [self didAccessValueForKey:@"name"];
    
    return tmpValue;
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:value forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}

- (NSNumber *)time 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey:@"time"];
    tmpValue = [self primitiveValueForKey:@"time"];
    [self didAccessValueForKey:@"time"];
    
    return tmpValue;
}

- (void)setTime:(NSNumber *)value 
{
    [self willChangeValueForKey:@"time"];
    [self setPrimitiveValue:value forKey:@"time"];
    [self didChangeValueForKey:@"time"];
}

@end
