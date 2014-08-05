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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView"
        message:@"My message" delegate:self cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {

}

- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
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
}

@end
