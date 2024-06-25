//
//  AudioRailItem.swift
//  ste
//
//  Created by Zdeněk Skulínek on 20.01.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import OpenAL

class AudioRailItem : AudioItem
{
    var stopSoundBuffers:Array<ALuint> = []
    
    enum State {
        case BeforePlaying
        case PlayingLoop
        case PlayingFirst
        case PlayingLast
        case PostPlaying
    }
    
    var state:State = State.BeforePlaying
    
    init(fileName:String, stopSoundFileName:String)
    {
        super.init(fileName: fileName)
        load(fileName: stopSoundFileName, buffers: &stopSoundBuffers)
    }
    
    override func play()
    {
        switch state {
        case .BeforePlaying:
            state = .PlayingLoop
            super.play()
            break
        case .PlayingLoop:
            super.play()
            break
        case .PlayingFirst:
            state = .PlayingLoop
            super.play()
            break
        case .PlayingLast:
            super.stop()
            repeat {
                var buffer:ALuint = 0
                var val:ALint = -1
                alGetSourcei(outputSource, AL_BUFFERS_PROCESSED, &val)
                if (val <= 0) {
                    break
                }
                alSourceUnqueueBuffers(outputSource, 1, &buffer)
                let error1 = alGetError()
                if (error1 != AL_NO_ERROR) {
                    return
                }
                
            }
            while (true)
            alSourceQueueBuffers(outputSource, ALsizei(outputBuffers.count), UnsafeMutablePointer(mutating: outputBuffers))
            state = .PlayingLoop
            super.play()
            break
        case .PostPlaying:
            repeat {
                var buffer:ALuint = 0
                var val:ALint = -1
                alGetSourcei(outputSource, AL_BUFFERS_PROCESSED, &val)
                if (val <= 0) {
                    break
                }
                alSourceUnqueueBuffers(outputSource, 1, &buffer)
                let error1 = alGetError()
                if (error1 != AL_NO_ERROR) {
                    return
                }
                
            }
            while (true)
            alSourceQueueBuffers(outputSource, ALsizei(outputBuffers.count), UnsafeMutablePointer(mutating: outputBuffers))
            state = .PlayingLoop
            super.play()
            break
        }
        
    }
    
    override func stop()
    {
        state = .PostPlaying
        super.stop()
        var val:ALint = -1
        alGetSourcei(outputSource, AL_BUFFERS_PROCESSED, &val)
        if (val > 0) {
            var buffers:Array<ALuint> = []
            buffers.removeAll()
            buffers.reserveCapacity(stopSoundBuffers.count)
            for _:Int in 0..<stopSoundBuffers.count {
                buffers.append(ALuint(UINT32_MAX))
            }
            alSourceUnqueueBuffers(outputSource, val, UnsafeMutablePointer(mutating: buffers))
            let error1 = alGetError()
            if (error1 != AL_NO_ERROR) {
                print("An error occurred when attempting to alSourceUnqueueBuffers reilitem")
            }
        }
    }
    
    func playStop()
    {
        if (state == .PlayingLoop)
        {
            state = State.PlayingFirst
        }
    }
    
    
    override func update()
    {
        var buffer:ALuint = 0
        var val:ALint = -1
        repeat {
            alGetSourcei(outputSource, AL_BUFFERS_PROCESSED, &val)
            if (val <= 0) {
                return
            }
            alSourceUnqueueBuffers(outputSource, 1, &buffer)
            let error1 = alGetError()
            if (error1 != AL_NO_ERROR) {
                return
            }
            switch state
            {
            case State.PlayingLoop:
                alSourceQueueBuffers(outputSource, 1, &buffer)
                let error2 = alGetError()
                if (error2 != AL_NO_ERROR) {
                    return
                }
                alGetSourcei(outputSource, AL_SOURCE_STATE, &val)
                if (val != AL_PLAYING) {
                    
                    alSourcePlay(outputSource)
                }
                break
            case .PlayingFirst:
                if (outputBuffers[outputBuffers.count-1] == buffer) {
                    state = .PlayingLast
                    alSourceQueueBuffers(outputSource, ALsizei(stopSoundBuffers.count), UnsafeMutablePointer(mutating: stopSoundBuffers))
                }
                else {
                    alSourceQueueBuffers(outputSource, 1, &buffer)
                    let error2 = alGetError()
                    if (error2 != AL_NO_ERROR) {
                        return
                    }
                    alGetSourcei(outputSource, AL_SOURCE_STATE, &val)
                    if (val != AL_PLAYING) {
                        
                        alSourcePlay(outputSource)
                    }
                }
                break
            case .PlayingLast:
                if (stopSoundBuffers[stopSoundBuffers.count-1] == buffer) {
                    state = .PostPlaying
                }
                break
            case .BeforePlaying:
                break
            case .PostPlaying:
                break
            }
            
        }
        while (true)
        
    }
    
    deinit
    {
        
        stop()
        alDeleteBuffers(ALsizei(stopSoundBuffers.count), UnsafeMutablePointer(mutating: stopSoundBuffers))
    }
}
