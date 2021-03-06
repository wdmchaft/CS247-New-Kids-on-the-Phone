//
//  GameKitCommunicatorViewController.h
//  CS247_iPad
//
//  Created by Elliot Babchick on 2/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import <CoreData/CoreData.h>

@interface GameKitCommunicatorViewController : UIViewController<GKPeerPickerControllerDelegate,GKSessionDelegate> {
	GKPeerPickerController *mPicker;
	GKSession *mSession;
	IBOutlet UIButton *connectButton;
	IBOutlet UIButton *recButton;
	IBOutlet UIButton *stopButton;
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *rewindButton;
	IBOutlet UIButton *trashButton;
	IBOutlet UIButton *homeButton;
	IBOutlet UIButton *saveButton;
	IBOutlet UITextField *sceneName;
	IBOutlet UIView *sceneNameView;


	IBOutlet UIView *dimView;
	IBOutlet UILabel *countdownLabel;
	
	bool playbackmode;
	bool recordmode;

	AVAudioPlayer *player;
	AVAudioRecorder *recorder;
	NSURL *recordURL;

	int backgroundNumber;
	IBOutlet UIImageView *background;
	IBOutlet UIActivityIndicatorView *spinner;
	NSMutableArray *mPeers;
	NSMutableArray *touchViews;
	NSUInteger chunks;
	NSUInteger totalChunks;
	NSMutableData *data;
	
	NSManagedObjectContext *managedObjectContext;
}

-(IBAction) connectClicked:(id)sender;
-(IBAction) homeClicked:(id)sender;

-(IBAction) recButtonPressed:(id)sender;
-(IBAction) rewindButtonPressed:(id)sender;
-(IBAction) playButtonPressed:(id)sender;
-(IBAction) stopButtonPressed:(id)sender;
-(IBAction) sendData:(id)sender;
-(IBAction)loadRecording;
-(IBAction) trashHit:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)sceneNameButtonPressed:(id)sender;
-(void) saveRecording:(NSString *)name;
- (void)clearTouchViews;
-(void)removeImg:(id)imgview;
- (void)loadScene:(NSManagedObject *)scene;

-(void)playbackEnded;
-(void)startRecording:(NSTimer *)timer;
-(void)countThree;
-(void)countTwo:(NSTimer *)timer;
-(void)countOne:(NSTimer *)timer;

@property (retain) GKSession *mSession;
@property bool playbackmode;
@property (retain) NSMutableData *data;
@property NSUInteger chunks;
@property NSUInteger totalChunks;
@property (retain) UIActivityIndicatorView *spinner;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end