//
//  ModPlayerController.swift
//  Frozen Bubble SpriteKit
//
//  Adapted by Uwe Ritter on 17.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//
//  Original modplayer code by:
//
//  Nicolas Ramz - http://www.warpdesign.fr/ on 16/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

class ModPlayer {

    let audioEngine = AVAudioEngine()
    var myAUNode: AVAudioUnit?        =  nil
    let mixer = AVAudioMixerNode()
    var playing = false
    var audioVolume: Float!
    var oldAudioVolume: Float!
    var myURL: URL!

    init() {
        self.oldAudioVolume = audioEngine.mainMixerNode.outputVolume
        self.audioSetup()
        self.audioPrepare()
        self.audioVolume = 0.25

    }
    func loadData(fileName: String) {

        // panic
        if fileName != "" {
            if let path = Bundle.main.path(forResource: fileName, ofType: "mod") {
                myURL = URL(filePath: path)
                do {
                    let data = try Data(contentsOf: myURL)
                    let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)  // AVAudioFormat
                    sampleRateHz = Double(outputFormat.sampleRate)
                    (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).mixingRate = Float(sampleRateHz)
                    (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).prepareModule(buffer: data)

                } catch {
                    print("oops")
                }
            } else {
                print ("file loading failed")
            }

        }
    }

    func audioSetup() {
        let sess = AVAudioSession.sharedInstance()
        do {
            try sess.setPreferredSampleRate(48000.0)
            sampleRateHz    = 48000.0
        } catch {
            // for Simulator and old devices)
            sampleRateHz    = 44100.0
        }
        do {
            let duration = 1.00 * (256.0/48000.0)
            try sess.setPreferredIOBufferDuration(duration)   // 256 samples
        } catch {
            print("Could not setPreferredIOBufferDuration")
        }

        try! sess.setActive(true)

        let myUnitType = kAudioUnitType_Generator
        let mySubType : OSType = 1

        let compDesc = AudioComponentDescription(componentType:     myUnitType,
                                                 componentSubType:  mySubType,
                                                 componentManufacturer: 0x666f6f20, // 4 hex byte OSType 'foo '
            componentFlags:        0,
            componentFlagsMask:    0 )
        
        AUAudioUnit.registerSubclass(ModPlayerAudioUnit.self,
                                     as:        compDesc,
                                     name:      "ModPlayerAudioUnit",   // "My3AudioUnit5" my AUAudioUnit subclass
            version:   1 )

        let outFormat = audioEngine.outputNode.outputFormat(forBus: 0)

        AVAudioUnit.instantiate(with: compDesc,
                                options: .init(rawValue: 0)) { (audiounit, error) in
                                    self.myAUNode = audiounit   // save AVAudioUnit
                                    self.audioEngine.attach(audiounit!)
                                    self.audioEngine.connect(audiounit!,
                                                              to: self.audioEngine.mainMixerNode,
                                                              format: outFormat)
        }

    }

    func audioPrepare() {


        let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)  // AVAudioFormat
        sampleRateHz = Double(outputFormat.sampleRate)

        audioEngine.connect(audioEngine.mainMixerNode,
        to: audioEngine.outputNode,
        format: outputFormat)

        audioEngine.prepare()
    }

    func audioStart() {
        do {
            try audioEngine.start()

            playing = true
            (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).play()

        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

    func audioPause() {
            audioEngine.pause()
            playing = false
    }
    
    func audioStop() {
            audioEngine.stop()
            audioEngine.mainMixerNode.outputVolume = oldAudioVolume
            playing = false
    }
    
    func audioVolume(to volume: Float) {
        audioEngine.mainMixerNode.outputVolume = volume
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

