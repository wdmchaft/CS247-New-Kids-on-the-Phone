//
//  TouchImageView.h
//  MultiTouchDemo
//
//  Created by Jason Beaver on 5/29/08.
//  Copyright 2008 Apple Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameKitCommunicatorViewController.h"

@interface TouchImageView : UIImageView {
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
	GameKitCommunicatorViewController *viewController;
	BOOL recording;
	NSMutableArray *animationSequence;
	NSDictionary *initialState;
	NSTimer *playbackTimer;
	int animationStep;
}

@property (readonly) NSMutableArray *animationSequence;
@property (nonatomic, retain)   	GameKitCommunicatorViewController *viewController;

		   
- (void)startRecording;
- (void)startPlayback;
- (void)stopPlayback;
- (void)stopRecording;
- (NSDictionary *)dictionaryForCGAffineTransform:(CGAffineTransform)trans;
- (CGAffineTransform)CGAffineTransformForDictionary:(NSDictionary *)transDict;

@end
