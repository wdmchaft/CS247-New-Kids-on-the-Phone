//
//  TouchImageView.h
//  MultiTouchDemo
//
//  Created by Jason Beaver on 5/29/08.
//  Copyright 2008 Apple Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKitCommunicatorViewController.h"

@class Character;

@interface TouchImageView : UIImageView <UIGestureRecognizerDelegate> {
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
	GameKitCommunicatorViewController *viewController;
	BOOL recording;
	NSMutableArray *animationSequence;
	NSDictionary *initialState;
	NSTimer *playbackTimer;
	int animationStep;
	BOOL poppedup;
	UIPopoverController* pop;
}

@property (readonly) NSMutableArray *animationSequence;
@property (nonatomic, retain)   	GameKitCommunicatorViewController *viewController;
@property (nonatomic,retain) 	UIPopoverController* pop;
@property BOOL poppedup;
		   
- (void)startRecording;
- (void)startPlayback;
- (void)stopPlayback;
- (void)stopRecording;
- (NSDictionary *)dictionaryForCGAffineTransform:(CGAffineTransform)trans;
- (CGAffineTransform)CGAffineTransformForDictionary:(NSDictionary *)transDict;

- (id)initWithCharacter:(Character *)character;

@end
