//
//  CYTBeatButton.m
//  Catalyst
//
//  Created by Julian Weiss on 4/28/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

#import "CYTBeatButton.h"
#include <stdlib.h>

@implementation CYTBeatButton

//When the user touches the beat-ball, save the touch location;
//makes it easy for the pan-recognizer in CYTViewController to
//smoothly make them move beneath a touch.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _velocity = CGPointZero;
    _startPoint = [[touches anyObject] locationInView:self];
}

//Creates a random identifier for each beat-ball, that will become
//its recording filename. Might want to shift this to more of a
//"database" system when saving Catalyst states comes into play.
//I had fun with the limits of the random number.
- (id)initWithFrame:(CGRect)frame{
    
    [self setAdjustsImageWhenHighlighted:YES];
    _identifier = arc4random() % 1000000;

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
