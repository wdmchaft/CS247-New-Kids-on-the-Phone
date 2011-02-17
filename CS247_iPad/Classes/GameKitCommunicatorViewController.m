    //
//  GameKitCommunicatorViewController.m
//  CS247_iPad
//
//  Created by Elliot Babchick on 2/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//


#import "GameKitCommunicatorViewController.h"

@implementation GameKitCommunicatorViewController

@synthesize mSession, data, chunks, totalChunks, spinner;


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
	
	chunks = 0;
	spinner.hidden = TRUE;
	data = [[NSMutableData alloc] init];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	NSLog(@"Connected from %@",peerID);
	connectButton.hidden = YES;
	
	
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
	
}

-(IBAction) sendData:(id)sender{
	
	NSString *str=@"Hello World";
	[mSession sendData:[str dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
}

- (void) receiveData:(NSData *)receivedData fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    // Read the bytes in data and perform an application-specific action.
	if (chunks == 0) {
		NSString* chunkCountStr = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
		NSUInteger chunkCount = [chunkCountStr intValue];
		NSLog(@"Received Data from %@ #%d %@",peer, chunkCount, chunkCountStr);
		if (chunkCount > 0) {
			[data dealloc];
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
			UIImage *receivedimg = [UIImage imageWithData:data];
			CGRect imageRect = CGRectMake(40.0, 10.0, 200, 0.0);
			imageRect.size.height = 200 * receivedimg.size.height / receivedimg.size.width;
			TouchImageView *touchImageView = [[TouchImageView alloc] initWithFrame:imageRect];
			touchImageView.image = receivedimg;
			touchImageView.center = CGPointMake(160.0, 230.0);
			[self.view addSubview:touchImageView];
			[touchImageView release];
		}
	}
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	
}

#pragma mark GameSessionDelegate stuff

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
			
			NSLog(@"PeerstateDISconnected");
			break;
		}
    }
}

@end