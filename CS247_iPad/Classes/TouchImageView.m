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
#import "Character.h"

@implementation TouchImageView

@synthesize viewController, poppedup, pop;

- (id)initWithCharacter:(Character *)character {
		
	UIImage *img = [UIImage imageWithContentsOfFile:character.imageFile];
	NSLog(@"loading image at %@", character.imageFile);
	CGRect imageRect = CGRectMake(40.0, 10.0, 200, 0.0);
	imageRect.size.height = 200 * img.size.height / img.size.width;
	self = [[TouchImageView alloc] initWithFrame:imageRect];
	if (self) {
		self.image = img;
		self.center = CGPointMake(160.0, 230.0);
		animationSequence = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:character.animation];
		[animationSequence retain];
		self.transform = [self CGAffineTransformForDictionary:[animationSequence objectAtIndex:0]];
	}
	return self;
}

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
//	UILongPressGestureRecognizer* gest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture)];
//	[self addGestureRecognizer:gest];
	self.poppedup = NO;
    return self;
}
- (void)handleGesture{
	if(!self.poppedup){
		
	CGRect contentRect = CGRectMake(0, 0, 200, 40);
	UIButton *source = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[source addTarget:self action:@selector(remove) forControlEvents:UIControlEventAllEvents];
	source.frame = contentRect;
    [source setTitle:@"Delete" forState:UIControlStateNormal];
	source.titleLabel.textColor = [UIColor redColor];
	
	UIViewController* popoverContent = [[UIViewController alloc] init];
	popoverContent.view = source;
	
	popoverContent.contentSizeForViewInPopover = contentRect.size;
	
	UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	self.pop = popoverController;
	[popoverController presentPopoverFromRect:[self frame]
									   inView:self.superview
					 permittedArrowDirections:UIPopoverArrowDirectionAny
									 animated:YES];
	
	[popoverContent release];	
	poppedup = YES;	
	}
}

-(void) remove {
	[self.pop dismissPopoverAnimated:NO]; 
	[self.viewController removeImg:self];
	[self retain];
	[self removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.poppedup = NO;
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

	//Trash Check!
	UITouch *touch = [touches anyObject];	
    CGPoint location = [touch locationInView:self.superview];
	NSLog(@"%f , %f " , location.x, location.y);
	if (location.x > 942 && location.x < (947+95) && location.y > 650 && location.y < (664+104)) {
		NSLog(@"BAM!");
		NSLog(@"a: %f b: %f c: %f d:%f tx: %f ty: %f ", self.transform.a, self.transform.b, self.transform.c, self.transform.d, self.transform.tx, self.transform.ty);
		CGAffineTransform shrink = CGAffineTransformMake(0.2356, 0.000730, -0.000730, 0.235612, 792.394958, 441.212341);
		[UIView animateWithDuration:.5
						 animations:^{ self.transform = shrink;}
						 completion:^(BOOL finished){
							 [self.viewController removeImg:self];
							 [self removeFromSuperview];
						}
		 ];
		
		return;
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
		//NSLog(@"timer interval is %f", interval);
		playbackTimer = [NSTimer scheduledTimerWithTimeInterval:interval
														 target:self
													   selector:@selector(handleTimer:)
													   userInfo:nil
														repeats:NO];
		animationStep++;
	} else {
		[self stopPlayback];
		[viewController playbackEnded];
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
    
	
	[animationSequence release];
	[initialState release];
	[pop release];
	
	
    [super dealloc];
}

@end
