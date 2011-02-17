//
//  GameKitCommunicatorViewController.h
//  CS247_iPhone
//
//  Created by Elliot Babchick on 2/9/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface GameKitCommunicatorViewController : UIViewController <GKPeerPickerControllerDelegate,GKSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	GKPeerPickerController *mPicker;
	GKSession *mSession;
	IBOutlet UITextField *mTextField;
	IBOutlet UITextView *mTextView;
	NSMutableArray *mPeers;
	
	UIImagePickerController *imagePicker;
}

-(IBAction) connectClicked:(id)sender;
-(IBAction) sendData:(id)sender;
- (IBAction)takeImageClicked:(id)sender;
@property (retain) GKSession *mSession;

@property (readonly) UIImagePickerController *imagePicker;
@property (retain) UIImage *backgroundImage;

- (unsigned char *)bitmapFromImage:(UIImage *)image;

@end