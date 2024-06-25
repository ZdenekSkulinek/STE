//
//  AudioItem.swift
//  ste
//
//  Created by Zdeněk Skulínek on 18.11.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//
// created by afconvert -f 'caff' -d LEI16  -b 44100 hit.wav

import Foundation
import OpenAL
import AudioToolbox

let segmentLength:Int = 1024

class AudioItem
{
    var audioManager:AudioManager
    var outputSource:ALuint = 0
    var outputBuffers:Array<ALuint> = []

    init(fileName:String)
    {
        audioManager = AudioManager.createAudioManager()
        alGenSources(1, &outputSource)
        alSourcef(outputSource, AL_PITCH, 1.0)
        alSourcef(outputSource, AL_GAIN, 1.0)
        
        load(fileName: fileName, buffers: &outputBuffers)
    }
    
    
    func load(fileName:String, buffers:inout Array<ALuint> )
    {
        let filePathUrl = Bundle.main.url(forResource: fileName, withExtension: "caf")
        let filePathCfUrl:CFURL = filePathUrl! as CFURL
        var audioFile : AudioFileID? = nil
        let openResult:OSStatus = AudioFileOpenURL(filePathCfUrl, AudioFilePermissions.readPermission, 0, &audioFile)
        if (0 != openResult) {
            print("An error occurred when attempting to open the audio file %@: %ld", filePathUrl!.absoluteString, openResult)
            AudioFileClose(audioFile!)
            return
        }
        var fileSizeInBytes:UInt64 = 0
        var propSize:UInt32 = UInt32(MemoryLayout.size(ofValue: fileSizeInBytes))
        let getSizeResult:OSStatus = AudioFileGetProperty(audioFile!, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes)
        if (0 != getSizeResult) {
            print("An error occurred when attempting to determine the size of audio file %@: %ld", filePathUrl!.absoluteString, getSizeResult)
            AudioFileClose(audioFile!)
            return
        }
        var bytesRead:UInt32 = UInt32(fileSizeInBytes)
        let audioDataPtr = malloc(Int(bytesRead))
        if (audioDataPtr == nil) {
            print("Memory out")
            AudioFileClose(audioFile!)
            return
        }
        let audioData = audioDataPtr!
        let readBytesResult:OSStatus = AudioFileReadBytes(audioFile!, false, 0, &bytesRead, audioData)
        AudioFileClose(audioFile!)
        if (0 != readBytesResult) {
            print("An error occurred when attempting to read data from audio file %@: %ld", filePathUrl!.absoluteString, readBytesResult)
            free(audioData)
        }
        let iBlockLength = 2 * 2 * segmentLength
        let iSegments = (Int(bytesRead) + iBlockLength - 2 * 2 ) / iBlockLength
        buffers.removeAll()
        buffers.reserveCapacity(iSegments)
        for _:Int in 0..<iSegments {
            buffers.append(ALuint(UINT32_MAX))
        }
        alGenBuffers(ALsizei(iSegments), UnsafeMutablePointer(mutating: buffers))
        let error1 = alGetError()
        if (error1 != AL_NO_ERROR) {
            free(audioData)
            return
        }
        for i:Int in 0..<iSegments {
            var j:Int = i
            while (j > 0 && buffers[j-1] > buffers[j]) {
                let tmp:ALuint = buffers[j]
                buffers[j] = buffers[j-1]
                buffers[j-1] = tmp
                j -= 1
            }
        }
        let iRestBytes:Int = Int(bytesRead) - (iSegments-1) * iBlockLength
        for i:Int in 0..<(iSegments-1) {
            alBufferData(buffers[i], AL_FORMAT_STEREO16, audioData + i*iBlockLength, ALsizei(iBlockLength), 48000)
        }
        alBufferData(buffers[iSegments-1], AL_FORMAT_STEREO16, audioData + (iSegments-1)*iBlockLength, ALsizei(iRestBytes), 48000)
        free(audioData)
    }
    
    
    func play()
    {
        alSourceQueueBuffers(outputSource, ALsizei(outputBuffers.count), UnsafeMutablePointer(mutating: outputBuffers))
        alSourcePlay(outputSource)
    }
    
    func stop()
    {
        //bug in openAl, ned only wait for sound finish, stop does not work
        //alSourceStop(outputSource)
        var val:ALint = -1
        repeat{
            usleep(20000)
            alGetSourcei(outputSource, AL_SOURCE_STATE, &val)
        }
        while(val == AL_PLAYING)
        alGetSourcei(outputSource, AL_BUFFERS_PROCESSED, &val)
        if (val > 0) {
            var buffers:Array<ALuint> = []
            buffers.removeAll()
            buffers.reserveCapacity(outputBuffers.count)
            for _:Int in 0..<outputBuffers.count {
                buffers.append(ALuint(UINT32_MAX))
            }
            alSourceUnqueueBuffers(outputSource, val > ALint(outputBuffers.count) ? ALint(outputBuffers.count) : val , UnsafeMutablePointer(mutating: buffers))
            let error1 = alGetError()
            if (error1 != AL_NO_ERROR) {
                print("An error occurred when attempting to alSourceUnqueueBuffers item")
            }
        }
    }
    
    
    func update()
    {
        
    }
    
    deinit
    {
        stop()
        alDeleteBuffers(ALsizei(outputBuffers.count), UnsafeMutablePointer(mutating: outputBuffers))
        alDeleteSources(1, &outputSource)
        AudioManager.closeAudioManager()
    }
}
