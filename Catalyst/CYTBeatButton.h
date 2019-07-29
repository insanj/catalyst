//
//  CYTBeatButton.h
//  Catalyst
//
//  Created by Julian Weiss on 4/28/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYTViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CYTBeatButton : UIButton

@property (strong, nonatomic) UIViewController *tapDetectorView;

@property (readwrite, nonatomic) CGPoint startPoint;
@property (readwrite, nonatomic) CGPoint velocity;

@property (readwrite, nonatomic) BOOL isHittingEdge;
@property (readwrite, nonatomic) BOOL hasRecording;
@property (readwrite, nonatomic) BOOL isRecording;

@property (readwrite, nonatomic) int identifier;

@end
