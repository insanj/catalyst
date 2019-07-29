//
//  CYTViewController.h
//  Catalyst
//
//  Created by Julian Weiss on 4/27/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYTViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *mainNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *mainBackingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonTapped:(id)sender;
- (IBAction)titleButtonTapped:(id)sender;

- (IBAction)buttonWasTapped:(id)sender;
- (void)createBeatButton;

@end
