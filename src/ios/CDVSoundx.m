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

- (void) myTest: (AVAudioPlayer *) player {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
        message:@"My message" delegate:self cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"OK", nil];
    [alert show];


}





- (void) onAudioSessionEvent: (NSNotification *) notification
{
    //Check the type of notification, especially if you are sending multiple AVAudioSession events here
    //NSLog(@"Interruption notification name %@", notification.name);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
        message:@"some interruption notification" delegate:self cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"OK", nil];
    [alert show];

    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        //NSLog(@"Interruption notification received %@!", notification);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
            message:@"INTERRUPTION NOTIFICATION RECEIVED" delegate:self cancelButtonTitle:@"Cancel"
            otherButtonTitles:@"OK", nil];
        [alert show];

        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            //NSLog(@"Interruption began!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
                message:@"INTERRUPTION BEGAN" delegate:self cancelButtonTitle:@"Cancel"
                otherButtonTitles:@"OK", nil];
            [alert show];

        } else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
            //NSLog(@"Interruption ended!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
                message:@"INTERRUPTION ENDED" delegate:self cancelButtonTitle:@"Cancel"
                otherButtonTitles:@"OK", nil];
            [alert show];
            //Resume your audio
            //NSLog(@"Player status %i", self.player.status);
            // Resume playing the audio.
            //[self.player play];

        }
    }
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
