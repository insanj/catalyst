//
//  CYTAppDelegate.h
//  Catalyst
//
//  Created by Julian Weiss on 4/27/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYTViewController;

@interface CYTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CYTViewController *viewController;

@end
