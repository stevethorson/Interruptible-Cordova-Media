/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var argscheck = require('cordova/argscheck'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec');

var mediaObjects = {};

/**
 * This class provides access to the device media, interfaces to both sound and video
 *
 * @constructor
 * @param src                   The file name or url to play
 * @param successCallback       The callback to be called when the file is done playing or recording.
 *                                  successCallback()
 * @param errorCallback         The callback to be called if there is an error.
 *                                  errorCallback(int errorCode) - OPTIONAL
 * @param statusCallback        The callback to be called when media status has changed.
 *                                  statusCallback(int statusCode) - OPTIONAL
 */
var Mediax = function(src, successCallback, errorCallback, statusCallback) {
    argscheck.checkArgs('SFFF', 'Media', arguments);
    this.id = utils.createUUID();
    mediaObjects[this.id] = this;
    this.src = src;
    this.successCallback = successCallback;
    this.errorCallback = errorCallback;
    this.statusCallback = statusCallback;
    this._duration = -1;
    this._position = -1;
    exec(null, this.errorCallback, "Media", "create", [this.id, this.src]);
};

// Media messages
Mediax.MEDIA_STATE = 1;
Mediax.MEDIA_DURATION = 2;
Mediax.MEDIA_POSITION = 3;
Mediax.MEDIA_ERROR = 9;

// Media states
Mediax.MEDIA_NONE = 0;
Mediax.MEDIA_STARTING = 1;
Mediax.MEDIA_RUNNING = 2;
Mediax.MEDIA_PAUSED = 3;
Mediax.MEDIA_STOPPED = 4;
Mediax.MEDIA_END_INTERRUPT = 5;

Mediax.MEDIA_MSG = ["None", "Starting", "Running", "Paused", "Stopped", "End Interrupt"];

// "static" function to return existing objs.
Mediax.get = function(id) {
    return mediaObjects[id];
};

/**
 * Start or resume playing audio file.
 */
Mediax.prototype.play = function(options) {
    alert('test play');
    exec(null, null, "Media", "startPlayingAudio", [this.id, this.src, options]);
};

/**
 * Stop playing audio file.
 */
Mediax.prototype.stop = function() {
    var me = this;
    exec(function() {
        me._position = 0;
    }, this.errorCallback, "Media", "stopPlayingAudio", [this.id]);
};

/**
 * Seek or jump to a new time in the track..
 */
Mediax.prototype.seekTo = function(milliseconds) {
    var me = this;
    exec(function(p) {
        me._position = p;
    }, this.errorCallback, "Media", "seekToAudio", [this.id, milliseconds]);
};

/**
 * Pause playing audio file.
 */
Mediax.prototype.pause = function() {
    exec(null, this.errorCallback, "Media", "pausePlayingAudio", [this.id]);
};

/**
 * Get duration of an audio file.
 * The duration is only set for audio that is playing, paused or stopped.
 *
 * @return      duration or -1 if not known.
 */
Mediax.prototype.getDuration = function() {
    return this._duration;
};

/**
 * Get position of audio.
 */
Mediax.prototype.getCurrentPosition = function(success, fail) {
    var me = this;
    exec(function(p) {
        me._position = p;
        success(p);
    }, fail, "Media", "getCurrentPositionAudio", [this.id]);
};

/**
 * Start recording audio file.
 */
Mediax.prototype.startRecord = function() {
    exec(null, this.errorCallback, "Media", "startRecordingAudio", [this.id, this.src]);
};

/**
 * Stop recording audio file.
 */
Mediax.prototype.stopRecord = function() {
    exec(null, this.errorCallback, "Media", "stopRecordingAudio", [this.id]);
};

/**
 * Release the resources.
 */
Mediax.prototype.release = function() {
    exec(null, this.errorCallback, "Media", "release", [this.id]);
};

/**
 * Adjust the volume.
 */
Mediax.prototype.setVolume = function(volume) {
    exec(null, null, "Media", "setVolume", [this.id, volume]);
};

/**
 * Audio has status update.
 * PRIVATE
 *
 * @param id            The media object id (string)
 * @param msgType       The 'type' of update this is
 * @param value         Use of value is determined by the msgType
 */
Mediax.onStatus = function(id, msgType, value) {

    var media = mediaObjects[id];

    if(media) {
        switch(msgType) {
            case Mediax.MEDIA_STATE :
                mediax.statusCallback && mediax.statusCallback(value);
                if(value == Mediax.MEDIA_STOPPED) {
                    mediax.successCallback && mediax.successCallback();
                }
             //   if(value == Mediax.MEDIA_START_INTERRUPT){
             //       alert("Start Interuption");
             //   }
                if(value == Mediax.MEDIA_END_INTERRUPT){
                    alert("End Interuption");
                }
                break;
            case Mediax.MEDIA_DURATION :
                mediax._duration = value;
                break;
            case Mediax.MEDIA_ERROR :
                mediax.errorCallback && mediax.errorCallback(value);
                break;
            case Mediax.MEDIA_POSITION :
                mediax._position = Number(value);
                break;
            default :
                console.error && console.error("Unhandled Mediax.onStatus :: " + msgType);
                break;
        }
    }
    else {
         console.error && console.error("Received Mediax.onStatus callback for unknown media :: " + id);
    }

};

module.exports = Mediax;
