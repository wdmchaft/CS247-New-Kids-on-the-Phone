//
//  GameKitCommunicatorViewController.m
//  CS247_iPhone
//
//  Created by Elliot Babchick on 2/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "GameKitCommunicatorViewController.h"

@implementation GameKitCommunicatorViewController

@synthesize mSession;


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
	mPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
	mPeers=[[NSMutableArray alloc] init];
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

- (IBAction)takeImageClicked:(id)sender {
	[self presentModalViewController:self.imagePicker animated:YES];
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
	NSString *txt=mTextField.text;
	
	GKSession* session = [[GKSession alloc] initWithSessionID:@"iPad" displayName:txt sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	NSLog(@"Connected from %@",peerID);
	
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
	
//	//Encode image
//	UIImage* testimg = [UIImage imageNamed:@"stealmic.png"];
//	NSData *imageData = UIImagePNGRepresentation(testimg);
//	
//	//Send how many chunks over
//	NSUInteger fiftyK = 51200;
//	NSUInteger chunkCount = (((NSUInteger)(imageData.length / fiftyK)) + ((imageData.length % fiftyK) == 0 ) ? 0 : 1))
//	NSString chunkCountStr = [NSString stringWithFormat:@"%d",chunkCount];
//	NSData* chunkCountData = [chunkCountStr dataUsingEncoding: NSASCIIStringEncoding];
//	[mSession sendData:[str dataUsingEncoding: NSASCIIStringEncoding] toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
//	
//	// Send chunks
//	NSData *dataToSend;
//	NSRange range = {0, 0};
//	for(NSUInteger i=0;i<srcData.length;i+=fiftyK){
//		range = {i,fiftyK};
//		dataToSend = [imageData subdataWithRange:range];
//		[mSession sendData:dataToSend toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
//	}
//	NSUInteger remainder = (imageData.length % fiftyK);
//	if (remainder != 0){
//		range = {imageData.length - remainder,remainder};
//		dataToSend = [imageData subdataWithRange:range];
//		[mSession sendData:dataToSend toPeers:mPeers withDataMode:GKSendDataReliable error:nil];
//	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    // Read the bytes in data and perform an application-specific action.
	
	NSString* aStr;
	aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"Received Data from %@",peer);
	mTextView.text=aStr;
	
	
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
	
}

#pragma mark ImagePicker stuff

- (UIImageView *)backgroundImageView
{
	if ([self.view.subviews count] && [[self.view.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]) {
		return (UIImageView *)[self.view.subviews objectAtIndex:0];
	} else {
		return nil;
	}
}


- (void)setBackgroundImage:(UIImage *)image
{
	UIImageView *backgroundImageView = self.backgroundImageView;
	if (!backgroundImageView) {
		backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		[self.view insertSubview:backgroundImageView atIndex:0];
		[backgroundImageView release];
	}
	backgroundImageView.image = image;
}		

- (UIImage *)backgroundImage
{
	return self.backgroundImageView.image;
}


- (UIImagePickerController *)imagePicker {
	if (!imagePicker) {
		imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} // defaults to photo library
		CFStringRef desired = kUTTypeImage;
		if ([[UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType] containsObject:desired]) {
			imagePicker.mediaTypes = [NSArray arrayWithObject:desired];
		}
		imagePicker.allowsEditing = YES;
	}
	return imagePicker;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (image) {
		self.backgroundImage = image;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark GameSessionDelegate stuff

/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	switch (state)
    {
        case GKPeerStateConnected:
		{
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",mTextView.text,@"Connected from peer ",peerID];
			mTextView.text= str;
			NSLog(@"%@",str);
			[mPeers addObject:peerID];
			break;
		}
        case GKPeerStateDisconnected:
		{
			[mPeers removeObject:peerID];
			
			NSString *str=[NSString stringWithFormat:@"%@\n%@%@",mTextView.text,@"DisConnected from peer ",peerID];
			mTextView.text= str;
			NSLog(@"%@",str);
			break;
		}
    }
}

@end