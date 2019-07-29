//
//  CYTViewController.h
//  Catalyst
//
//  Created by Julian Weiss on 4/28/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CYTBeatButton.h"
#import <AVFoundation/AVFoundation.h>

@interface CYTViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UIView *mainBackingView;
@property (weak, nonatomic) IBOutlet UIView *aboutBacking;

@property (weak, nonatomic) IBOutlet UINavigationBar *mainBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *aboutBar;

@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *catalystButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutWebsiteButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITextView *aboutText;

- (IBAction)aboutWebsiteButtonTapped:(id)sender;
- (IBAction)aboutButtonTapped:(id)sender;
- (IBAction)addButtonTapped:(id)sender;
- (IBAction)titleButtonTapped:(id)sender;

@end
