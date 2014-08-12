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


- (void) startListeningForAudioSessionEvent:(CDVInvokedUrlCommand*)command{
    NSString* mediaId = [command.arguments objectAtIndex:0];

    //allow audio to START in background mode. Otherwise it must be playing when app enters background.
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

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
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mediaId;
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopListeningForAudioSessionEvent:(CDVInvokedUrlCommand*)command{
    //[[NSNotificationCenter defaultCenter] removeObserver:observer]
    //where observer is the value that was returned from adding it. That may mean you have to store it in an instance variable rather than a local
}

@end