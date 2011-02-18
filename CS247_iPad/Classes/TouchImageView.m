//
//  TouchImageView.m
//  MultiTouchDemo
//
//  Created by Jason Beaver on 5/29/08.
//  Copyright 2008 Apple Inc.. All rights reserved.
//

#import "TouchImageView.h"
#import "TouchImageView_Private.h"
#include <execinfo.h>
#include <stdio.h>

@implementation TouchImageView

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame] == nil) {
        return nil;
    }
	
	recording = NO;
	animationStep = 0;
    originalTransform = CGAffineTransformIdentity;
    touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = NO;

    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
	CGAffineTransform newTransform = CGAffineTransformConcat(originalTransform, incrementalTransform);
	if (recording) {
		NSDictionary *transDict = [self dictionaryForCGAffineTransform:newTransform];
		[self.animationSequence addObject:transDict];
	}
    self.transform = newTransform;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }

    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];

    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark Action Recording Code

- (void)startRecording {
	recording = YES;
	
	// clear an existing recording
	[animationSequence release];
	animationSequence = nil;
	
	// save current transform
	NSDictionary *transDict = [self dictionaryForCGAffineTransform:self.transform];
	[self.animationSequence addObject:transDict];
}


- (void)stopRecording {
	recording = NO;
}

- (void)startPlayback {
	self.transform = [self CGAffineTransformForDictionary:[self.animationSequence objectAtIndex:animationStep]];
	
	if ([self.animationSequence count] && animationStep < [self.animationSequence count]) {
		NSTimeInterval interval = [[[self.animationSequence objectAtIndex:animationStep + 1] objectForKey:@"timestamp"] doubleValue] - 
									[[[self.animationSequence objectAtIndex:animationStep] objectForKey:@"timestamp"] doubleValue];
		playbackTimer = [NSTimer scheduledTimerWithTimeInterval:interval
														 target:self
													   selector:@selector(handleTimer:)
													   userInfo:nil
														repeats:NO];
		animationStep++;
	}
}

- (void)stopPlayback {
	[playbackTimer invalidate];
	animationStep = 0;
}

- (void)handleTimer:(NSTimer *)timer {
	self.transform = [self CGAffineTransformForDictionary:[self.animationSequence objectAtIndex:animationStep]];
	if (animationStep != [self.animationSequence count] - 1) {
		NSTimeInterval interval = [[[self.animationSequence objectAtIndex:animationStep + 1] objectForKey:@"timestamp"] doubleValue] - 
		[[[self.animationSequence objectAtIndex:animationStep] objectForKey:@"timestamp"] doubleValue];
		NSLog(@"timer interval is %f", interval);
		playbackTimer = [NSTimer scheduledTimerWithTimeInterval:interval
														 target:self
													   selector:@selector(handleTimer:)
													   userInfo:nil
														repeats:NO];
		animationStep++;
	} else {
		[self stopPlayback];
	}
}

- (NSDictionary *)dictionaryForCGAffineTransform:(CGAffineTransform)trans {
	NSDictionary *transformDict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat:trans.a], @"a",
								   [NSNumber numberWithFloat:trans.b], @"b",
								   [NSNumber numberWithFloat:trans.c], @"c",
								   [NSNumber numberWithFloat:trans.d], @"d",
								   [NSNumber numberWithFloat:trans.tx], @"tx",
								   [NSNumber numberWithFloat:trans.ty], @"ty", 
								   [NSNumber numberWithDouble:(double)[[NSDate date] timeIntervalSince1970]], @"timestamp", nil];
	return transformDict;
}

- (CGAffineTransform)CGAffineTransformForDictionary:(NSDictionary *)transDict {
	CGAffineTransform trans = CGAffineTransformMake([[transDict objectForKey:@"a"] floatValue], 
													[[transDict objectForKey:@"b"] floatValue], 
													[[transDict objectForKey:@"c"] floatValue], 
													[[transDict objectForKey:@"d"] floatValue], 
													[[transDict objectForKey:@"tx"] floatValue], 
													[[transDict objectForKey:@"ty"] floatValue]);
	return trans;
}

- (NSMutableArray *)animationSequence {
	if (!animationSequence) {
		animationSequence = [[NSMutableArray alloc] init];
	}
	return animationSequence;
}

- (void)dealloc
{
    CFRelease(touchBeginPoints);
    
    [super dealloc];
}

@end
