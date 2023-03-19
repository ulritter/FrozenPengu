//
//  MyAudioUnit.swift
//  modplayer
//
//  Created by Nico on 16/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation
import AVFoundation

var sampleRateHz = 48000.0
//var testFrequency = 880.0
var testFrequency = 600.0
//var testVolume = 0.1
var testVolume = 1.0
var toneCount = 0

class CustomAudioUnit: AUAudioUnit {
    // @interface
    var outputBusArray: AUAudioUnitBusArray?

    // @implementation
    // let myAudioBufferist: AudioBufferList?
    var my_pcmBuffer:AVAudioPCMBuffer?
    var outputBus:AUAudioUnitBus?
    var myAudioBufferList:AudioBufferList?
    static var ph = 0.0

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)
       
        let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRateHz, channels: 2)
        outputBus = try AUAudioUnitBus(format: defaultFormat!)
        outputBusArray = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus!])

        self.maximumFramesToRender = 512

//        print("end init")
    }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        my_pcmBuffer = AVAudioPCMBuffer(pcmFormat: outputBus!.format, frameCapacity: 4096)
        myAudioBufferList = my_pcmBuffer!.audioBufferList.pointee
    }

    override func deallocateRenderResources() {
        super.deallocateRenderResources()
    }

    override var outputBusses: AUAudioUnitBusArray {
        get {
            return outputBusArray!
        }
    }
}
