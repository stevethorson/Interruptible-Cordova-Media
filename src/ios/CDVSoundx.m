/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "AppDelegate.h"
#import "CDVSoundx.h"

@implementation CDVSound (CDVSoundx)

@synthesize soundCache, avSession;

- (void)startPlayingAudiox:(CDVInvokedUrlCommand*)command
{
    //Need to call Media's startPlayingAudio first and then call: 
    //look into swizzling to do this? or just copy the code from cordova

    NSString* callbackId = command.callbackId;

#pragma unused(callbackId)
    NSString* mediaId = [command.arguments objectAtIndex:0];
    NSString* resourcePath = [command.arguments objectAtIndex:1];
    NSDictionary* options = [command.arguments objectAtIndex:2 withDefault:nil];

    BOOL bError = NO;
    NSString* jsString = nil;

    CDVAudioFile* audioFile = [self audioFileForResource:resourcePath withId:mediaId doValidation:YES forRecording:NO];
    if ((audioFile != nil) && (audioFile.resourceURL != nil)) {
        if (audioFile.player == nil) {
            bError = [self prepareToPlay:audioFile withId:mediaId];
        }
        if (!bError) {
            // audioFile.player != nil  or player was successfully created
            // get the audioSession and set the category to allow Playing when device is locked or ring/silent switch engaged
            if ([self hasAudioSession]) {
                NSError* __autoreleasing err = nil;
                NSNumber* playAudioWhenScreenIsLocked = [options objectForKey:@"playAudioWhenScreenIsLocked"];
                BOOL bPlayAudioWhenScreenIsLocked = YES;
                if (playAudioWhenScreenIsLocked != nil) {
                    bPlayAudioWhenScreenIsLocked = [playAudioWhenScreenIsLocked boolValue];
                }

                NSString* sessionCategory = bPlayAudioWhenScreenIsLocked ? AVAudioSessionCategoryPlayback : AVAudioSessionCategorySoloAmbient;
//////////////////////////////////               
//STEVETHORSON ADDED WITHOPTIONS//
//////////////////////////////////
                [self.avSession setCategory:sessionCategory withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&err];
                if (![self.avSession setActive:YES error:&err]) {
                    // other audio with higher priority that does not allow mixing could cause this to fail
                    NSLog(@"Unable to play audio: %@", [err localizedFailureReason]);
                    bError = YES;
                }
            }
            if (!bError) {
                NSLog(@"Playing audio sample '%@'", audioFile.resourcePath);
                NSNumber* loopOption = [options objectForKey:@"numberOfLoops"];
                NSInteger numberOfLoops = 0;
                if (loopOption != nil) {
                    numberOfLoops = [loopOption intValue] - 1;
                }
                audioFile.player.numberOfLoops = numberOfLoops;
                if (audioFile.player.isPlaying) {
                    [audioFile.player stop];
                    audioFile.player.currentTime = 0;
                }
                if (audioFile.volume != nil) {
                    audioFile.player.volume = [audioFile.volume floatValue];
                }

                [audioFile.player play];
                double position = round(audioFile.player.duration * 1000) / 1000;
                jsString = [NSString stringWithFormat:@"%@(\"%@\",%d,%.3f);\n%@(\"%@\",%d,%d);", @"cordova.require('org.apache.cordova.media.Media').onStatus", mediaId, MEDIA_DURATION, position, @"cordova.require('org.apache.cordova.media.Media').onStatus", mediaId, MEDIA_STATE, MEDIA_RUNNING];
                [self.commandDelegate evalJs:jsString];
            }
        }
        if (bError) {
            /*  I don't see a problem playing previously recorded audio so removing this section - BG
            NSError* error;
            // try loading it one more time, in case the file was recorded previously
            audioFile.player = [[ AVAudioPlayer alloc ] initWithContentsOfURL:audioFile.resourceURL error:&error];
            if (error != nil) {
                NSLog(@"Failed to initialize AVAudioPlayer: %@\n", error);
                audioFile.player = nil;
            } else {
                NSLog(@"Playing audio sample '%@'", audioFile.resourcePath);
                audioFile.player.numberOfLoops = numberOfLoops;
                [audioFile.player play];
            } */
            // error creating the session or player
            // jsString = [NSString stringWithFormat: @"%@(\"%@\",%d,%d);", @"cordova.require('org.apache.cordova.media.Media').onStatus", mediaId, MEDIA_ERROR,  MEDIA_ERR_NONE_SUPPORTED];
            jsString = [NSString stringWithFormat:@"%@(\"%@\",%d,%@);", @"cordova.require('org.apache.cordova.media.Media').onStatus", mediaId, MEDIA_ERROR, [self createMediaErrorWithCode:MEDIA_ERR_NONE_SUPPORTED message:nil]];
            [self.commandDelegate evalJs:jsString];
        }
    }
    // else audioFile was nil - error already returned from audioFile for resource
    return;









/*

    // Modifying Playback Mixing Behavior, allow playing music in other apps
     AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
             error:&setCategoryError]) {
        // handle error
    }
*/
}

- (void) startListeningForAudioSessionEvent:(CDVInvokedUrlCommand*)command{




    NSString* mediaId = [command.arguments objectAtIndex:0];

    //listen for audio session interruption[command.arguments objectAtIndex:0]
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:AVAudioSessionInterruptionNotification
                                                                    object:nil
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *notification){
        if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {

            //Check to see if it was a Begin interruption
            if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
                NSString* jsString1 = [NSString stringWithFormat:@"%@('%@','%@');", @"window.Mediax.prototype.interruptionBegan", @"Interruption began!", mediaId];
                [self.commandDelegate evalJs:jsString1];

            //or End interruption
            } else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
                NSString* jsString2 = [NSString stringWithFormat:@"%@('%@','%@');", @"window.Mediax.prototype.interruptionEnded", @"Interruption ended!", mediaId];
                [self.commandDelegate evalJs:jsString2];
            }
        }
    }];

    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mediaId];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) startRemoteControlAudio:(CDVInvokedUrlCommand*)command{
    /*  
    Possible Concern
    http://stackoverflow.com/questions/3456435/ios-4-remote-controls-for-background-audio
    To get complete control of remote controls for your app (whether it's in foreground or background) you need to call beginReceivingRemoteControlEvents in application:didFinishLaunchingWithOptions:, but that's not all. Your UIApplicationDelegate starts to receive remote control events after your app tells iOS that it's playing a track - by setting MPNowPlayingInfoCenter nowPlayingInfo property.
    */
    //allow audio to START while app is in background mode. Otherwise it must be playing when app enters background.
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //[self becomeFirstResponder];
  //  MainClass *appDelegate = (MainClass *)[[UIApplication sharedApplication] delegate];
   // [appDelegate.viewController someMethod];

}

- (void) endRemoteControlAudio:(CDVInvokedUrlCommand*)command{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//    [[[UIApplication sharedApplication] delegate] performSelector:@selector(resignFirstResponder)];
}

- (void) stopListeningForAudioSessionEvent:(CDVInvokedUrlCommand*)command{

    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];

    //must release observer when done with it
    //[[NSNotificationCenter defaultCenter] removeObserver:observer]
    //where observer is the value that was returned from adding it. That may mean you have to store it in an instance variable rather than a local
}

@end