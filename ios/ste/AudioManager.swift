//
//  AudioManager.swift
//  ste
//
//  Created by Zdeněk Skulínek on 18.11.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import OpenAL
import AudioToolbox

typealias ALCcontext = OpaquePointer
typealias ALCdevice = OpaquePointer



class AudioManager
{
    
    var openALDevice:ALCdevice
    var openALContext:ALCcontext
    static var DefaultManager:AudioManager? = nil
    static var ChildrensCount:Int = 0
    
    init()
    {
        openALDevice = alcOpenDevice(nil)
        let error:ALenum = alGetError()
        if (AL_NO_ERROR != error) {
            print("Error %d when attemping to open device", error)
        }
        openALContext = alcCreateContext(openALDevice, nil)
        alcMakeContextCurrent(openALContext)
        
    }
    
    class func createAudioManager() -> AudioManager
    {
        if(DefaultManager != nil)
        {
            ChildrensCount += 1
            return DefaultManager!
        }
        DefaultManager = AudioManager()
        ChildrensCount = 1
        return DefaultManager!
    }

    class func closeAudioManager()
    {
        ChildrensCount -= 1
        if(ChildrensCount == 0)
        {
            DefaultManager = nil
        }
    }
    
    deinit
    {
        alcDestroyContext(openALContext)
        alcCloseDevice(openALDevice)
    }

}
