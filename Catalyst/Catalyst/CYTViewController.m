//
//  CYTViewController.m
//  Catalyst
//
//  Created by Julian Weiss on 4/28/13.
//  Copyright (c) 2013 Julian Weiss. All rights reserved.
//

/*--- WWDC 2013 STUDENT SCHOLARSHIP APP ---*/

//The main Catalyst class. Catalyst was created by Julian "insanj" Weiss
//with help from Matt Weiss (testing and inspiration) and Stefan Mitev
//(graphical design). Made in just a few days, Catalyst is meant to represent
//an integration of my curiosity and interest with music and rhythm, and
//how it can go hand-in-hand with user interaction and programming. The
//overt simpliciy of Catalyst is meant to provoke creativity and imagination
//in the user. I hope that no future revisions of this app shake that
//mission statement. It's going to be incredible to see the different types
//of compositions that people make: from noise repeaters to vocal works
//to instrumental mixing to live song mashups.

#import "CYTViewController.h"

@interface CYTViewController ()

@end

float globalInterval;
NSTimer *globalTimer;
NSMutableArray *boxesArray;
NSMutableArray *recordings;
NSMutableArray *recordingIdentifiers;

BOOL didJustAnimate;
AVAudioRecorder *recorder;
NSMutableArray *players;

int sideSize;

@implementation CYTViewController


//When the main CYTViewController view loads, create a global timer object that fires
//every .0001 second, checking and updating the positions of the beat-balls, making
//Catalyst play the specific audio files for every recorded beat-ball. Also creates
//empty arrays for the "boxes"/beat-balls, audio players, and audio recordings. A
//"players" array is needed to retain the players in memory until they are done playing,
//so multiple sounds from the AVAudioPlayers can be heard at once. A future revision
//of Catalyst may shift to a different audio system (possibly with NSSounds) to
//allow for a less laggy and memory-consuming experience.
-(void)viewDidLoad{
    
    sideSize = 55;              //The length/width of the Beat-balls.
    globalInterval = .0001f;
    globalTimer = [NSTimer scheduledTimerWithTimeInterval:globalInterval target:self selector:@selector(runScheduledTask) userInfo:nil repeats:YES];
    
    boxesArray = [[NSMutableArray alloc] init];
    players = [[NSMutableArray alloc] init];
    recordings = [[NSMutableArray alloc] init];
    recordingIdentifiers = [[NSMutableArray alloc] init];
    
    [_aboutView setFrame:CGRectMake(_aboutView.frame.origin.x, _aboutView.frame.origin.y + 20, _aboutView.frame.size.width, _aboutView.frame.size.height)];
    [_mainBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-small.png"] forBarMetrics:UIBarMetricsDefault];
    [_aboutBar setBackgroundImage:[UIImage imageNamed:@"nav-bar-small.png"] forBarMetrics:UIBarMetricsDefault];
    
    [_aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_aboutWebsiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"plus-button-pressed.png"] forState:UIControlStateHighlighted];
    [_aboutButton setBackgroundImage:[UIImage imageNamed:@"about-button-pressed.png"] forState:UIControlStateHighlighted];
    
    UIImageView *logoBacking = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-logo.png"]];
    [logoBacking setFrame:CGRectMake([_mainBackingView center].x / 2, [_mainBackingView center].y / 2, 147, 84)];
     
    [_mainBackingView addSubview: logoBacking];
    [_mainBackingView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-texture.png"]]];
    [_aboutBacking setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"about-background.png"]]];
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.

}//end method

//When the main CYTViewController view unloads, delete all of the recordings from the
//iPhone, so as to conserve space. An option to "save" Catalyst beats will be implemented
//in a future version, with a partner save-file class that handles the data associated
//with saving positions, velocities, and recordings; this primative unload is the
//simplest way to deal with space consumption in the basic model of Catalyst.
- (void)viewDidUnload{
    for(AVAudioRecorder *r in recordings)
        [r deleteRecording];
}//end method

//The only values retained (I hate to use that word when using ARC) in Catalyst are
//the arrays that hold the necessary objects, and the booleans that prevent mishaps
//from the inside-out, all of which cannot be "recreated."
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}//end method

#pragma mark Timer

//The method that is called whenever the global timer fires. The basic framework for this
//function is to run through the array that holds every beat-ball, check to see if it's
//hitting any of the boundaries of the iPhone screen, and accordingly adjust velocity/location
//and play any recorded sounds. It also allows for the user to just create works of
//nauseating art by flicking the beat-balls around the screen (without recording anything)
//freely.
- (void)runScheduledTask {

    if(boxesArray != nil && [boxesArray count] >= 1){
        for(CYTBeatButton *box in boxesArray){
            CGPoint currCenter = box.frame.origin;
            float deltaX = currCenter.x + (box.velocity.x * globalInterval);
            float deltaY = currCenter.y + (box.velocity.y * globalInterval);

            float yLowerBound = _mainBackingView.frame.origin.y - 45;           //Lower and Upper, here, represent
            float yUpperBound = _mainBackingView.frame.size.height - sideSize;        //the smallest values in the X- and
            float xLowerBound = _mainBackingView.frame.origin.x;                //Y- directions, not the location
            float xUpperBound = _mainBackingView.frame.size.width - sideSize;         //of the edges.
            
            
            //If the next location for the beat-ball is beyond one of the boundaries of the screen...
            if(deltaX < xLowerBound || deltaX > xUpperBound || deltaY < yLowerBound || deltaY > yUpperBound){
                
                if(deltaX < xLowerBound || deltaX > xUpperBound)
                    [box setVelocity:CGPointMake(-[box velocity].x, [box velocity].y)];
                
                if(deltaY < yLowerBound || deltaY > yUpperBound)
                    [box setVelocity:CGPointMake([box velocity].x, -[box velocity].y)];
                
                if(deltaX < xLowerBound)
                    deltaX = xLowerBound + 1;           //Adds a 1-pixel buffer to the edges;
                if(deltaX > xUpperBound)                //frequently the beat-balls would exceed
                    deltaX = xUpperBound - 1;           //the edges of the screen, getting momentarily
                if(deltaY < yLowerBound)                //stuck (slowing down the application
                    deltaY = yLowerBound + 1;           //considerably). Also allows the user to run
                if(deltaY > yUpperBound)                //their beat-balls against the sides, making
                    deltaY = yUpperBound - 1;           //interesting repeat-effects.
                
                box.isHittingEdge = YES;
                
                //Plays a saved AVAudioRecorder file using an AVAudioPlayer. Reads directly from the
                //saved file, instead of storing the file in an array (or some other form of memory).
                if(box.hasRecording && ![recorder isRecording]){
                    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);     //Ascertain the Documents directory path,
                    NSString *dir = [paths objectAtIndex:0];                                                              //and create a pathname for the saved
                    NSString *filename = [NSString stringWithFormat:@"%i", [box identifier]];                             //recording that is associated with the
                    NSString *recorderFilePath = [dir stringByAppendingPathComponent:filename];                           //current beat-ball.
                                    
                    [self playWithURL:[NSURL fileURLWithPath:recorderFilePath]];
                }
            }//end boundary if
            
            else
                box.isHittingEdge = NO;

            [box setFrame:CGRectMake(deltaX, deltaY, box.frame.size.width, box.frame.size.height)];
        }//end for
    }//end if

}//end method

#pragma mark Audio handling

//A tidy method that plays the audio object stored at the given filepath, and
//saves the AVAudioPlayer in the players array, so that it may be used
//concurrently with other AVAudioPlayers.
-(void)playWithURL:(NSURL *)filepath{
        AVAudioPlayer *player;
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:filepath error:&error];
        player.delegate = self;
        [player prepareToPlay];
        [player play];
    
        [players addObject:player];
}//end method

//Gets rid of the audio players when they're done with their job. Would be reeeeeally
//bad if they stayed in the array forever. The stuff of nightmares.
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [players removeObject:player];
}//end method


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//A method that handles recording audio with AVAudioRecorders; provoked when the
//user taps on the beat-box.
- (void)startRecording:(CYTBeatButton *)sentBox {
    if([sentBox hasRecording]){
        int indexOfRecording = [recordingIdentifiers indexOfObject:[NSNumber numberWithInt:sentBox.identifier]];
        [[recordings objectAtIndex:indexOfRecording] deleteRecording];
        [recordings removeObjectAtIndex:indexOfRecording];
        [recordingIdentifiers removeObjectAtIndex:indexOfRecording];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%i", [sentBox identifier]];
    
    NSString *recorderFilePath = [dir stringByAppendingPathComponent:filename];
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    [settings setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];          //Creates an NSMutableDictionary to hold the record settings: 
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];                        //Apple Lossless, sample rate to 44100 Hz, recording on 1
    [settings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];                          //channels, bit-depth 16, non-big endian format, non-floating
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];                        //point.
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:recorderFilePath] settings:settings error:nil];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
}//end method

//Stops the current AVAudioRecorder from recording, and saves the recoding
//in the recordings array. The file is saved as a part of the startRecording
//method, so the only need here is to finalize the deal.
- (void)stopRecording:(CYTBeatButton *)sentBox {
   
    sentBox.hasRecording = YES;
    [recorder stop];
    [recordings addObject:recorder];
    [recordingIdentifiers addObject:[NSNumber numberWithInt:sentBox.identifier]];
}//end method


#pragma mark Navigation touches

//When the "about" navigation button is tapped, slide the main UIView down to reveal
//the About Catalyst view. Should be modified to support horizontal orientations for
//full release, although allowing for multiple orientations doesn't really add anything
//to the experiance (same amount of screen space at every angle).
- (IBAction)aboutButtonTapped:(id)sender {
    if(!didJustAnimate){
        didJustAnimate = YES;
        [_addButton setEnabled:NO];
        [_aboutButton setTitle:@"Hide" forState:UIControlStateNormal];
        
        //Animates out the main view. I really enjoy this UIView animation effect,
        //will look into making it "bounce" when shifted down.
        [self.view.superview insertSubview:_aboutView belowSubview:_mainView];
        [UIView animateWithDuration:0.27 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                                 [_mainView setFrame:CGRectMake(0, _aboutText.frame.size.height + 60, _mainView.frame.size.width, _mainView.frame.size.height)];
                        }
                         completion:nil];
    }
    
    else{
        didJustAnimate = NO;
        [_addButton setEnabled:YES];
        [_aboutButton setTitle:@"About" forState:UIControlStateNormal];

        [UIView animateWithDuration:0.27 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             [_mainView setFrame:CGRectMake(0, 20, _mainView.frame.size.width, _mainView.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             [_aboutView removeFromSuperview];
                         }];
    }
}//end method

//Launches a UIActionSheet with Beat-ball options when the "Catalyst" logo
//is tapped. Originally was a simple tap-once to freeze, tap-twice to clear
//system, but it was clear that that would cause a lot of unwanted deletions.
- (IBAction)titleButtonTapped:(id)sender {
    UIActionSheet *optionsSheet = [[UIActionSheet alloc] initWithTitle:@"Beat-ball Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Freeze", @"Clear", nil];
    optionsSheet.destructiveButtonIndex = 1;
    [optionsSheet showInView:self.view.superview];
}//end method


//The method that controls Action Sheet taps: freezes or clears all Beat-balls. For
//a period of time there was a somewhat common crash with the clear button, that was
//cryptically tied to memory management. It seems that some code cleaning and optimization
//has done away with it, but the mere fact that it could exist has me uneasy-- might want
//to re-add more booleans that check to see if the schedule method is being called.
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        for(CYTBeatButton *currBox in boxesArray)
            currBox.velocity = CGPointZero;
    }
    
    else if(buttonIndex == 1){
        [self clearBoxes];
    }
}//end method

//Clears all beat-balls, stopping the recordings, removing the objects from the _mainView and
//from memory, and deleting all the recordings in the Documents directory of the app.
-(void)clearBoxes{
    globalTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(isDoneClearing) userInfo:nil repeats:NO];
    
    for(AVAudioPlayer *p in players)
        [p stop];
        
    [players removeAllObjects];
    for(CYTBeatButton *currBox in boxesArray)
        [currBox removeFromSuperview];
        
    [boxesArray removeAllObjects];
    for(AVAudioRecorder *r in recordings)
        [r deleteRecording];
    
    [recordings removeAllObjects];
    [recordingIdentifiers removeAllObjects];
    [globalTimer fire];
}//end method

-(void)isDoneClearing{
    globalTimer = [NSTimer scheduledTimerWithTimeInterval:globalInterval target:self selector:@selector(runScheduledTask) userInfo:nil repeats:YES];
}

//When the "about" title is tapped in the about view, launch Safari with my website!
- (IBAction)aboutWebsiteButtonTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.insanj.com/"]];
}

//Add beat-ball objects with tap and pan gestures. The gesture-recognizers are supremly helpful for
//calculating velocity and position. Unfortunately, they make it annoying to stop the beat-balls
//from moving when the user is holding onto them. Adds the new beat-ball to the boxes array and to
//the _mainView, and sets its image to the beautiful icon crafted by my graphical designer.
- (IBAction)addButtonTapped:(id)sender{
    CYTBeatButton *box = [[CYTBeatButton alloc] initWithFrame:CGRectMake(_mainBackingView.frame.origin.x, _mainBackingView.frame.origin.y - 45, sideSize, sideSize)];
    [box setAdjustsImageWhenHighlighted:YES];
    [box setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
    [box setBackgroundImage:[UIImage imageNamed:@"white-shadow.png"] forState:UIControlStateHighlighted];

    [box addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)]];
    [box addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)]];
    
    [boxesArray addObject:box];
    [_mainBackingView addSubview:box];
}

#pragma mark Gestures

//When the user "pans" across the beat-balls, move them along with their finger. Also makes user
//the user doesn't push it off of the stage, and allows for cool effects with the edges. Sets
//the flick-velocity that's used in the scheduling method.
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer{
    
    CYTBeatButton *box = (CYTBeatButton *)panRecognizer.view;
    CGPoint startPoint = box.startPoint;
        
    CGPoint newPoint = [panRecognizer locationInView:_mainBackingView];
    newPoint.x -= startPoint.x;
    newPoint.y -= startPoint.y;
    
    float yLowerBound = _mainBackingView.frame.origin.y - 45;
    float yUpperBound = _mainBackingView.frame.size.height - sideSize;
    float xLowerBound = _mainBackingView.frame.origin.x;
    float xUpperBound = _mainBackingView.frame.size.width - sideSize;
    
    if(newPoint.x < xLowerBound)
        newPoint.x = xLowerBound;
    
    else if(newPoint.x > xUpperBound)
        newPoint.x = xUpperBound;
    
    if(newPoint.y < yLowerBound)
        newPoint.y = yLowerBound;
    
    else if(newPoint.y > yUpperBound)
        newPoint.y = yUpperBound;
    
    CGRect movedFrame = box.frame;
    movedFrame.origin = newPoint;
    [box setFrame:movedFrame];
    
    box.velocity = [panRecognizer velocityInView:_mainBackingView];
}

//Records or saves recordings when the beat-balls are tapped. Changes the image
//to reflect the change in state.
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer{
    CYTBeatButton *box = (CYTBeatButton *)tapRecognizer.view;
    
    if([recorder isRecording] && [box isRecording]){
        [self stopRecording:box];
        
        [box setBackgroundImage:[UIImage imageNamed:@"blue.png"] forState:UIControlStateNormal];
        [box setBackgroundImage:[UIImage imageNamed:@"blue-shadow.png"] forState:UIControlStateHighlighted];

        box.isRecording = NO;
    }
    
    else if(![recorder isRecording]){
        [self startRecording:box];
        
        [box setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        [box setBackgroundImage:[UIImage imageNamed:@"red-shadow.png"] forState:UIControlStateHighlighted];
        
        box.isRecording = YES;
    }
    
    /*
    else{
        //Makes sure to let the user know if they're trying to record
        //two beat-balls simultaneously. Disabled because deemed
        //unnecessary for this release.
        UIColor *prevColor = [box backgroundColor];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             [box setBackgroundColor:[UIColor orangeColor]];
                         }
                         completion:^(BOOL completion){
                             [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^(void) {
                                                  [box setBackgroundColor:prevColor];
                                              } completion:nil];
                         }];
    }*/
}

@end
