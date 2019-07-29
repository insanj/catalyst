//
//  CYTViewController.m
//  Catalyst
//
//  Created by Julian Weiss on 4/27/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import "CYTViewController.h"

@interface CYTViewController ()
@end

NSMutableArray *createButtonsArray;
NSMutableArray *createBeatButtonArray;
CGRect topLeftCornerButtonFrame;
CGRect bottomRightCornerButtonFrame;
BOOL overlayShowing;

@implementation CYTViewController

- (void)viewDidLoad{
    
    createBeatButtonArray = [[NSMutableArray alloc] init];
    createButtonsArray = [[NSMutableArray alloc] initWithCapacity:(8*6)];
    for (int height = 0; height < 8; height++){
        for (int width = 0; width < 6; width++){
            UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(11+(51*width), 8+(51*height), 43, 43)];
            [newButton setBackgroundColor:[UIColor whiteColor]];
            //[newButton setShowsTouchWhenHighlighted:YES];
            [newButton addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchDown];
            
            [createButtonsArray addObject:newButton];
        }
    }//end for
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)titleButtonTapped:(id)sender {
    
    overlayShowing = FALSE;
    for(UIButton *currButton in createButtonsArray)
        [currButton removeFromSuperview];
    
    for(UIButton *currButton in createBeatButtonArray)
        [_mainBackingView addSubview:currButton];
    
    [_addButton setEnabled:TRUE];

    /*
    int numberOfButtonsHorizontal = (int) abs(topLeftCornerButtonFrame.origin.x - bottomRightCornerButtonFrame.origin.x) / 43;
    int numberOfButtonsVertical = (int) abs(topLeftCornerButtonFrame.origin.y - bottomRightCornerButtonFrame.origin.y) / 43;
    
    CGRect combinedButtonFrame = CGRectMake(100, 100, numberOfButtonsHorizontal * 43, numberOfButtonsVertical * 43);
    UIButton *combinedButton = [[UIButton alloc] initWithFrame:combinedButtonFrame];
    [combinedButton setShowsTouchWhenHighlighted:YES];
    
    NSLog(@"combined:%@", combinedButton);
    [beatButtonsArray addObject:combinedButton];
    
    for(UIButton *currButton in beatButtonsArray)
        [_mainBackingView addSubview:currButton];
    
    
    for(UIButton *currButton in createButtonsArray)
        [currButton removeFromSuperview];
        
    for(UIButton *currButton in beatButtonsArray)
        [currButton removeFromSuperview];
    
    firstTappedButtonFrame = CGRectZero;
    secondTappedButtonFrame = CGRectZero;
    createButtonsArray = [[NSMutableArray alloc] init];
    beatButtonsArray = [[NSMutableArray alloc] init];*/

}

- (IBAction)addButtonTapped:(id)sender {
    
    overlayShowing = TRUE;
    for(UIButton *currButton in createButtonsArray)
        [_mainBackingView addSubview:currButton];
    
    for(UIButton *currButton in createBeatButtonArray)
        [_mainBackingView addSubview:currButton];
    
    [_addButton setEnabled:FALSE];
}//end method
             
- (IBAction)buttonWasTapped:(id)sender {
    
    UIButton *tappedButton = sender;
    
    if(![createBeatButtonArray containsObject:tappedButton]){
        NSLog(@"yo");
        [createBeatButtonArray addObject:tappedButton];
        [tappedButton setBackgroundColor:[UIColor blackColor]];
    }
    
    else{
        NSLog(@"oy");
        [createBeatButtonArray removeObject:tappedButton];
        [tappedButton setBackgroundColor:[UIColor whiteColor]];

        if(!overlayShowing)
            [tappedButton removeFromSuperview];
    }
        
    /*
    if(CGRectIsEmpty(topLeftCornerButtonFrame))
        topLeftCornerButtonFrame = tappedButton.frame;
    if(CGRectIsEmpty(bottomRightCornerButtonFrame))
        bottomRightCornerButtonFrame = tappedButton.frame;

    
    if((tappedButton.frame.origin.x < topLeftCornerButtonFrame.origin.x) || (tappedButton.frame.origin.x == topLeftCornerButtonFrame.origin.x))
        if((tappedButton.frame.origin.y < topLeftCornerButtonFrame.origin.y) || (tappedButton.frame.origin.y == topLeftCornerButtonFrame.origin.y))
            topLeftCornerButtonFrame = tappedButton.frame;
    
    if((tappedButton.frame.origin.x > bottomRightCornerButtonFrame.origin.x) || (tappedButton.frame.origin.x == bottomRightCornerButtonFrame.origin.x))
        if((tappedButton.frame.origin.y > bottomRightCornerButtonFrame.origin.y) || (tappedButton.frame.origin.y == bottomRightCornerButtonFrame.origin.y))
            bottomRightCornerButtonFrame = tappedButton.frame;
    
    
    UIButton *tappedButton = sender;
    if(CGRectIsEmpty(firstTappedButtonFrame))
        firstTappedButtonFrame = [tappedButton frame];
    
    else{
        secondTappedButtonFrame = [tappedButton frame];
        
        for(UIButton *currButton in createButtonsArray)
            [currButton removeFromSuperview];
        
        [self createBeatButton];
    }*/
}//end method

- (void)createBeatButton{
    
    /*
    int numberOfButtonsHorizontal = (int) abs(secondTappedButtonFrame.origin.x - firstTappedButtonFrame.origin.x) / 43;
    int numberOfButtonsVertical = (int) abs(secondTappedButtonFrame.origin.y - firstTappedButtonFrame.origin.y) / 43;
    
    float compositeX = (firstTappedButtonFrame.origin.x + secondTappedButtonFrame.origin.x) / 2;
    float compositeY = (firstTappedButtonFrame.origin.y + secondTappedButtonFrame.origin.y) / 2;
    float compositeWidth = 43 * numberOfButtonsHorizontal;
    float compositeHeight = 43 * numberOfButtonsVertical;
    
    NSLog(@"in create beat button:");
    NSLog(@"firsttappedbuttonframe-- x:%f, y%f, width:%f, height:%f", firstTappedButtonFrame.origin.x, firstTappedButtonFrame.origin.y, firstTappedButtonFrame.size.width, firstTappedButtonFrame.size.height);
    NSLog(@"secondtappedbuttonframe-- x:%f, y:%f, width:%f, height:%f", secondTappedButtonFrame.origin.x, secondTappedButtonFrame.origin.y, secondTappedButtonFrame.size.width, secondTappedButtonFrame.size.height);
    NSLog(@"composites-- x:%f, y:%f, width:%f, height:%f", compositeX, compositeY, compositeWidth, compositeHeight);
    NSLog(@"numberofhorizontal: %i", numberOfButtonsHorizontal);
    NSLog(@"numberofvertical: %i", numberOfButtonsVertical);

    
    CGRect compositeRect = CGRectMake(compositeX, compositeY, compositeWidth, compositeHeight);
    UIButton *compositeButton = [[UIButton alloc] initWithFrame:compositeRect];
    
    [compositeButton setBackgroundColor:[UIColor blackColor]];
    [compositeButton setShowsTouchWhenHighlighted:YES];

    [beatButtonsArray addObject:compositeButton];
    for(UIButton *currButton in beatButtonsArray)
        [_mainBackingView addSubview:currButton];
    
    firstTappedButtonFrame = CGRectZero;
    secondTappedButtonFrame = CGRectZero;
     */
}

@end
