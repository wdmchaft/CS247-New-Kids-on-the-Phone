    //
//  GameKitCommunicatorViewController.m
//  CS247_iPad
//
//  Created by Elliot Babchick on 2/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//


#import "GameKitCommunicatorViewController.h"
#import "TouchImageView.h"
#import "Character.h"
#import "Scene.h"
#import "MainMenuViewController.h"

@implementation GameKitCommunicatorViewController

@synthesize mSession, data, chunks, totalChunks, spinner, playbackmode, managedObjectContext;


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	mPicker=[[GKPeerPickerController alloc] init];
	mPicker.delegate=self;
	mPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	mPeers=[[NSMutableArray alloc] init];
	touchViews=[[NSMutableArray alloc] init];

	
	chunks = 0;
	spinner.hidden = TRUE;
	data = [[NSMutableData alloc] init];
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return(interfaceOrientation==UIInterfaceOrientationLandscapeRight);
 }
 

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[recorder release];
	[player	release];
	[recordURL release];
	[mPeers release];
    [super dealloc];
}

#pragma mark Events

-(IBAction) connectClicked:(id)sender{
	//Show the connector
	[mPicker show];
}

#pragma mark PeerPickerControllerDelegate stuff

/* Notifies delegate that a connection type was chosen by the user.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{
	if (type == GKPeerPickerConnectionTypeOnline) {
        picker.delegate = nil;
        [picker dismiss];
        [picker autorelease];
		// Implement your own internet user interface here.
    }
}

/* Notifies delegate that the connection type is requesting a GKSession object.
 
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	
	//UIApplication *app=[UIApplication sharedApplication];
	
	GKSession* session = [[GKSession alloc] initWithSessionID:@"iPad" displayName:@"FaceStory iPad" sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

- (BOOL)acceptConnectionFromPeer:(NSString *)peerID error:(NSError **)error {
	return YES;	
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	NSLog(@"Connected from %@",peerID);
	background.hidden = NO;
	background.alpha = 0;

	
	// Use a retaining property to take ownership of the session.
    self.mSession = session;
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
	// Start your game.
	MainMenuViewController* menu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
	menu.gk = self;
	menu.managedObjectContext = self.managedObjectContext;
	[self presentModalViewController:menu animated:YES];
	[menu release];
	//[UIView animateWithDuration:1 animations:^{ background.alpha = 1; recButton.alpha = 1;connectButton.alpha= 0;} completion:^(BOOL finished) { connectButton.hidden = YES; }];

	
}

-(void)backgroundPicked:(int) backgroundnum{
	backgroundNumber = backgroundnum;
	switch (backgroundnum) {
		case 0:
			background.image = [UIImage imageNamed:@"castle.png"];
			break;
		case 1:
			background.image = [UIImage imageNamed:@"ocean_bg.png"];
			break;
		case 2:
			background.image = [UIImage imageNamed:@"space-bg.png"];
			break;
		case 3:
			background.image = [UIImage imageNamed:@"sunny-field-bg.png"];
			break;	
		default:
			break;
	}
	connectButton.alpha= 0;
	[UIView animateWithDuration:1 animations:^{ background.alpha = 1; recButton.alpha = 1; homeButton.alpha = 1;} completion:^(BOOL finished) { connectButton.hidden = YES; }];
	
}
-(IBAction) sendData:(id)sender{
	
	NSString *str=@"Hello World";
	[mSession sendData:[str dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
}

- (void) receiveData:(NSData *)receivedData fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	// Dont exceed 10 images currently on the screen
	if ([touchViews count] >= 10) {
		return;
	}
	

	
    // Read the bytes in data and perform an application-specific action.
	if (chunks == 0) {
		NSString* chunkCountStr = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
		NSUInteger chunkCount = [chunkCountStr intValue];
		NSLog(@"Received Data from %@ #%d %@",peer, chunkCount, chunkCountStr);
		if (chunkCount > 0) {
			if (data) {
				[data release];
				data = nil;
			}
			data = [[NSMutableData alloc] init];
			chunks = 1;
			totalChunks = chunkCount;
			spinner.hidden = FALSE;
		}
	} else {
		NSLog(@"%d", chunks);
		chunks++;
		[data appendData:receivedData];
		if (chunks == totalChunks + 1){
			NSLog(@"GOT IMG!");
			chunks = 0;
			spinner.hidden = TRUE;
			// Can't add pics when recording
			if (recordmode) {
				return;
			}
			trashButton.alpha = 1;
			NSLog(@"received bytes: %i", [data length]);
			UIImage *receivedimg = [UIImage imageWithData:data];
			[data release]; data = nil;
			CGRect imageRect = CGRectMake(40.0, 10.0, 200, 0.0);
			imageRect.size.height = 200 * receivedimg.size.height / receivedimg.size.width;
			TouchImageView *touchImageView = [[TouchImageView alloc] initWithFrame:imageRect];
			touchImageView.viewController = self;
			touchImageView.image = receivedimg;
			touchImageView.center = CGPointMake(160.0, 230.0);
			[self.view insertSubview:touchImageView belowSubview:recButton];
			[touchViews addObject:touchImageView];
			[touchImageView release];
		}
	}
}
-(void)removeImg:(id)imgview{
	[touchViews removeObjectIdenticalTo:imgview];
}

#pragma mark Animations

- (void)countThree {
	dimView.alpha = 0.8;
	countdownLabel.alpha = 0;	
	countdownLabel.text	= @"3";
	[UIView animateWithDuration:.5
					 animations:^{ countdownLabel.alpha = 1;}
					 completion:^(BOOL finished){
						 NSTimer *playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
																				   target:self
																				 selector:@selector(countTwo:)
																				 userInfo:nil
																				  repeats:NO];
					 }
	 ];
}

- (void)countTwo:(NSTimer *)timer {
	countdownLabel.alpha = 0;	
	countdownLabel.text	= @"2";
	[UIView animateWithDuration:.5
					 animations:^{ countdownLabel.alpha = 1;}
					 completion:^(BOOL finished){
						 NSTimer *playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
																				   target:self
																				 selector:@selector(countOne:)
																				 userInfo:nil
																				  repeats:NO];
					 }
	 ];
}

- (void)countOne:(NSTimer *)timer {
	countdownLabel.alpha = 0;	
	countdownLabel.text	= @"1";
	[UIView animateWithDuration:.5
					 animations:^{ countdownLabel.alpha = 1;}
					 completion:^(BOOL finished){
						 NSTimer *playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
																				   target:self
																				 selector:@selector(startRecording:)
																				 userInfo:nil
																				  repeats:NO];
					 }
	 ];
}

#pragma mark UI methods

- (void)clearTouchViews {
	for (TouchImageView *tiv in touchViews) {
		[tiv removeFromSuperview];
		[self removeImg:tiv];
	}
}

- (void)startRecording:(NSTimer *)timer {
	recordmode = true;
	
	dimView.alpha = 0;
	countdownLabel.alpha = 0;
	
	for(TouchImageView* tview in touchViews){
		[tview startRecording];
	}
	
	[recordURL release];
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	recordURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"narration.aif"]];
	[recordURL retain];
	
	if (!recorder) recorder = [[AVAudioRecorder alloc] initWithURL:recordURL settings:nil error:NULL];
	[recorder record];
	
	[UIView animateWithDuration:.2 animations:^{ stopButton.alpha = 1; recButton.alpha= 0; playButton.alpha = 0; rewindButton.alpha = 0; homeButton.alpha = 0; saveButton.alpha = 0;}];
	
}

-(IBAction) trashHit:(id)sender {
	NSLog(@"yes");
}
-(IBAction) homeClicked:(id)sender {
	MainMenuViewController* menu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
	menu.gk = self;
	menu.managedObjectContext = self.managedObjectContext;
    [self presentModalViewController:menu animated:YES];
	[menu release];
}
-(IBAction) recButtonPressed:(id)sender{
	[self countThree];
}

-(IBAction) playButtonPressed:(id)sender{
	if (playbackmode){
		playbackmode = false;	
		[playButton setImage:[UIImage imageNamed:@"play-active.png"] forState:UIControlStateNormal];
		for(TouchImageView* tview in touchViews){
			[tview stopPlayback];
		}
		[player stop];
		return;
	}
	playbackmode = true;	
	[playButton setImage:[UIImage imageNamed:@"stop-active.png"] forState:UIControlStateNormal];
	
	for(TouchImageView* tview in touchViews){
		[tview startPlayback];
	}
	if (player) [player release];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordURL error:NULL];
	[player play];
	[UIView animateWithDuration:.5 animations:^{ recButton.alpha = 0;}];
}


-(void)playbackEnded {
	self.playbackmode = false;
    [playButton setImage:[UIImage imageNamed:@"play-active.png"] forState:UIControlStateNormal];
	[UIView animateWithDuration:.5 animations:^{ recButton.alpha = 1;}];
}

-(IBAction) stopButtonPressed:(id)sender{
	recordmode = false;
	for(TouchImageView* tview in touchViews){
		[tview stopRecording];
	}
	[recorder stop];
	[UIView animateWithDuration:.5 animations:^{ recButton.alpha = 1; playButton.alpha = 1; rewindButton.alpha = 1; stopButton.alpha= 0; homeButton.alpha = 1; saveButton.alpha = 1;}];
	
}

- (IBAction) rewindButtonPressed:(id)sender{
	if (playbackmode){
		playbackmode = false;	
		[playButton setImage:[UIImage imageNamed:@"play-active.png"] forState:UIControlStateNormal];
		for(TouchImageView* tview in touchViews){
			[tview stopPlayback];
		}
		[player stop];
	}
	for (TouchImageView* tview in touchViews){
	  tview.transform = [tview CGAffineTransformForDictionary:[tview.animationSequence objectAtIndex:0]];	
	}
}

- (IBAction)saveButtonPressed:(id)sender {
	[UIView animateWithDuration:.5 animations:^{ sceneNameView.alpha = 1; }];
	[sceneName becomeFirstResponder];
}

- (IBAction)sceneNameButtonPressed:(id)sender {
	NSString *sceneNameText = sceneName.text;
	[sceneName resignFirstResponder];
	[UIView animateWithDuration:.5 animations:^{ sceneNameView.alpha = 0; }];
	sceneName.text = @"";
	[self saveRecording:sceneNameText];
}

- (void)saveRecording:(NSString *)name {
	
	//Scene *scene = [Scene sceneInManagedObjectContext:managedObjectContext];
	Scene *scene = [Scene sceneName:name withBackground:[NSNumber numberWithInt:backgroundNumber] inManagedObjectContext:managedObjectContext];
	
	for (int i = 0; i < [touchViews count]; i++) {
		TouchImageView *touchView = [touchViews objectAtIndex:i];
		Character *character = [Character characterForTouchImageView:touchView inScene:scene inManagedObjectContext:managedObjectContext];
	}
	
	NSLog(@"successfully saved scene");
}

- (void)loadScene:(NSManagedObject *)sceneObj {
	[self clearTouchViews];
	
	Scene *scene = (Scene *)sceneObj;
	
	//load background image
	[self backgroundPicked:[scene.background intValue]];
	
	// load audio from scene
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	//NSURL *soundURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"narration.aif"]];
	NSString *soundPath = [cacheDirectory stringByAppendingPathComponent:@"narration.aif"];
	NSLog(@"loading scene: %@", scene.name);
	NSLog(@"loading audio at %@", scene.audioFile);
	NSData *audioData = [NSData dataWithContentsOfFile:scene.audioFile];
	[audioData writeToFile:soundPath atomically:YES];
	recordURL = [[NSURL alloc] initWithString:soundPath];
	
	// get the characters in the scene
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Character" inManagedObjectContext:managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"scene = %@", scene];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
																					 ascending:YES]];
	request.fetchBatchSize = 20;
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
									   initWithFetchRequest:request
									   managedObjectContext:managedObjectContext
									   sectionNameKeyPath:nil
									   cacheName:nil];
	[request release];
	
	NSError *error = nil;
	BOOL success = [frc performFetch:&error];
	if (success) {
		for (int i = 0; i < [frc.fetchedObjects count]; i++) {
			Character *character = [frc.fetchedObjects objectAtIndex:i];
			TouchImageView *tiv = [[TouchImageView alloc] initWithCharacter:character];
			//[character release];
			tiv.viewController = self;
			[self.view insertSubview:tiv belowSubview:recButton];
			[touchViews addObject:tiv];
			//[tiv release];
		}
	}
	
	[frc release];
	[UIView animateWithDuration:.2 animations:^{recButton.alpha = 1; playButton.alpha = 1; rewindButton.alpha = 1; trashButton.alpha = 1;}];
	
}

- (IBAction)loadRecording {
	
	NSError *error = nil;
	
	// get a scene
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Scene" inManagedObjectContext:managedObjectContext];	
	Scene *scene = [[managedObjectContext executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	// load audio from scene
	NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
	//NSURL *soundURL = [NSURL URLWithString:[cacheDirectory stringByAppendingPathComponent:@"narration.aif"]];
	NSString *soundPath = [cacheDirectory stringByAppendingPathComponent:@"narration.aif"];
	NSLog(@"loading scene: %@", scene.name);
	NSLog(@"loading audio at %@", scene.audioFile);
	NSData *audioData = [NSData dataWithContentsOfFile:scene.audioFile];
	[audioData writeToFile:soundPath atomically:YES];
	recordURL = [[NSURL alloc] initWithString:soundPath];
	
	// get the characters in the scene
	request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Character" inManagedObjectContext:managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"scene = %@", scene];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time"
																					 ascending:YES]];
	request.fetchBatchSize = 20;
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc]
									   initWithFetchRequest:request
									   managedObjectContext:managedObjectContext
									   sectionNameKeyPath:nil
									   cacheName:nil];
	[request release];
	
	BOOL success = [frc performFetch:&error];
	if (success) {
		for (int i = 0; i < [frc.fetchedObjects count]; i++) {
			Character *character = [frc.fetchedObjects objectAtIndex:i];
			TouchImageView *tiv = [[TouchImageView alloc] initWithCharacter:character];
			//[character release];
			tiv.viewController = self;
			[self.view insertSubview:tiv belowSubview:recButton];
			[touchViews addObject:tiv];
			//[tiv release];
		}
	}
	
	[frc release];
	[UIView animateWithDuration:.2 animations:^{recButton.alpha = 1; playButton.alpha = 1; rewindButton.alpha = 1; trashButton.alpha = 1;}];
}

#pragma mark GameSessionDelegate stuff

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	
}

/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	switch (state)
    {
        case GKPeerStateConnected:
		{
			NSLog(@"Peerstateconnected");
			[mPeers addObject:peerID];
			break;
		}
        case GKPeerStateDisconnected:
		{
			[mPeers removeObject:peerID];
			background.hidden = YES;
			connectButton.alpha = 1;
			connectButton.hidden = NO;
			NSLog(@"PeerstateDISconnected");
			break;
		}
    }
}

@end