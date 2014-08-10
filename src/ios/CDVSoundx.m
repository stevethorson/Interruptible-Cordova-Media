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

#import "CDVSoundx.h"

@implementation CDVSound (CDVSoundx)

- (void) myTest:(CDVInvokedUrlCommand*)command{
     NSString* mediaId = [command.arguments objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) withObject:mediaId name:AVAudioSessionInterruptionNotification object:nil];


    //jsString = [NSString stringWithFormat:@"%@(\"%@\",%d,%d);", @"cordova.require('window.Mediax.Mediax').logger", mediaId, MEDIA_STATE, MEDIA_END_INTERRUPT]
    //[self.commandDelegate evalJs:jsString]
    NSString* jsString = nil;
    NSString* theMessage = @"hurray hurray it worked";
    jsString = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage];
    [self.commandDelegate evalJs:jsString];
    
/*    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Responsetastic"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];*/


}


- (void) onAudioSessionEvent:(NSNotification *)notification withId:(NSString*)mediaId
{
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
   /* NSString* theMessage1 = [NSString stringWithFormat:@"%@: %@", @"Interruption notification name", notification.name];
    NSString* jsString1 = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage1];
    [self.commandDelegate evalJs:jsString1];*/



    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        /*NSString* theMessage2 = [NSString stringWithFormat:@"%@: %@", @"Interruption notification received", notification];
        NSString* jsString2 = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage2];
        [self.commandDelegate evalJs:jsString2];*/

        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSString* theMessage3 = @"Interruption began!";
            NSString* jsString3 = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage3];
            [self.commandDelegate evalJs:jsString3];


            NSString* jsString3B = [NSString stringWithFormat:@"%@(\"%@\",%d,%d);", @"window.Mediax.prototype.onStatus", mediaId, MEDIA_STATE, 5];
            [self.commandDelegate evalJs:jsString3B];
            

        //Or an End interruption
        } else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
            NSString* theMessage4 = @"Interruption ended!";
            NSString* jsString4 = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage4];
            [self.commandDelegate evalJs:jsString4];


            NSString* jsString4B = [NSString stringWithFormat:@"%@(\"%@\",%d,%d);", @"window.Mediax.prototype.onStatus", mediaId, MEDIA_STATE, 6];
            [self.commandDelegate evalJs:jsString4B];
            //Resume your audio
            //NSLog(@"Player status %i", self.player.status);
            // Resume playing the audio.
            //[self.player play];

        }
    }
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
            NSString* theMessage5 = @"audioPlayerEndInterruption";
            NSString* jsString5 = [NSString stringWithFormat:@"%@(\"%@\");", @"window.Mediax.prototype.logger", theMessage5];
            [self.commandDelegate evalJs:jsString5];
}


/*
- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {

}


- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
        message:@"End Interruption" delegate:self cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"OK", nil];
    [alert show];

    [player play];


    // CDVAudioPlayer* aPlayer = (CDVAudioPlayer*)player;
    // NSString* mediaId = aPlayer.mediaId;
    // CDVAudioFile* audioFile = [[self soundCache] objectForKey:mediaId];
    // NSString* jsString = nil;

    // if (audioFile != nil) {
    //     NSLog(@"Ended Interruption of playing audio sample '%@'", audioFile.resourcePath);
    // }
    // if (flag) {
    //     jsString = [NSString stringWithFormat:@"%@(\"%@\",%d,%d);", @"cordova.require('com.hybyr.mediax').onStatus", mediaId, MEDIA_STATE, MEDIA_END_INTERRUPT];
    // } else {
    //     jsString = [NSString stringWithFormat:@"%@(\"%@\",%d,%@);", @"cordova.require('com.hybyr.mediax').onStatus", mediaId, MEDIA_ERROR, [self createMediaErrorWithCode:MEDIA_ERR_DECODE message:nil]];
    // }

    // [self.commandDelegate evalJs:jsString];
}*/

@end
