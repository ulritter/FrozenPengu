//
//  ModPlayerController.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 17.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//
//  Original modplayer code by:
//
//  Nico on 16/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

class ModPlayer {

    let audioEngine = AVAudioEngine()
    var myAUNode: AVAudioUnit?        =  nil
    // Do any additional setup after loading the view.
    let mixer = AVAudioMixerNode()
    var playing = false
    var audioVolume: Float!
    var myURL: URL!

    init() {
        self.audioVolume = 0.25
        self.audioSetup()
        self.audioPrepare()

    }
    func loadData(fileName: String) {

        // panic
        if fileName != "" {
            if let path = Bundle.main.path(forResource: fileName, ofType: "mod") {
                myURL = URL(filePath: path)
                do {
                    let data = try Data(contentsOf: myURL)
                    let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)  // AVAudioFormat

                    audioEngine.mainMixerNode.outputVolume = audioVolume
                    sampleRateHz = Double(outputFormat.sampleRate)
                    (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).mixingRate = Float(sampleRateHz)
                    (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).prepareModule(buffer: data)
//                    print("Set mixingRate to \(sampleRateHz)")

                } catch {
                    print("oops")
                }
            } else {
                print ("file loading failed")
            }

        }
    }

    func audioSetup() {
//        print("audioSetup()")
        let sess = AVAudioSession.sharedInstance()
        try! sess.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)))
        do {
//            print("Attempt to set sampleRate to 48khz")
            try sess.setPreferredSampleRate(48000.0)
//            print("sampleRate was set to \(sess.sampleRate)")
            sampleRateHz    = 48000.0
        } catch {
            // for Simulator and old devices
//            print("Falling back to 44khz")
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

//        print("registerSubclass")
        // MyV3AudioUnit5.self
        AUAudioUnit.registerSubclass(ModPlayerAudioUnit.self,
                                     as:        compDesc,
                                     name:      "ModPlayerAudioUnit",   // "My3AudioUnit5" my AUAudioUnit subclass
            version:   1 )

        let outFormat = audioEngine.outputNode.outputFormat(forBus: 0)

//        print("intantiate")
        AVAudioUnit.instantiate(with: compDesc,
                                options: .init(rawValue: 0)) { (audiounit, error) in

//                                    print("completed: \(audiounit) \(error)")
                                    self.myAUNode = audiounit   // save AVAudioUnit
//                                    print("completed 1")
                                    self.audioEngine.attach(audiounit!)
//                                    print("completed 2")
                                    self.audioEngine.connect(audiounit!,
                                                              to: self.audioEngine.mainMixerNode,
                                                              format: outFormat)
        }
//        print("end audioSetup")
    }

    func audioPrepare() {
//        print("audioPrepare()")
//        let bus0 : AVAudioNodeBus   =  0    // output of the inputNode
//        let inputNode   =  audioEngine!.inputNode
//        let inputFormat =  inputNode.outputFormat(forBus: bus0)

        let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)  // AVAudioFormat
        sampleRateHz = Double(outputFormat.sampleRate)

        audioEngine.connect(audioEngine.mainMixerNode,
        to: audioEngine.outputNode,
        format: outputFormat)

        audioEngine.prepare()

//        if (displayTimer == nil) {
//        displayTimer = CADisplayLink(target: self,
//        selector: #selector(self.updateView) )
//        displayTimer.preferredFramesPerSecond = 60  // 60 Hz
//        displayTimer.add(to: RunLoop.current,
//        forMode: RunLoop.Mode.common )
//        }
    }

    func audioStart() {
        do {
            try audioEngine.start()
            // self.myInfoLabel1.text = "engine started"
            // toneCount = 44100 / 2
            playing = true
            (myAUNode?.auAudioUnit as! ModPlayerAudioUnit).play()
//            print("engine started")
        } catch let error as NSError {
            // self.myInfoLabel1.text = (error.localizedDescription)
            print("error: \(error.localizedDescription)")
        }
    }

    func audioPause() {
            audioEngine.pause()
            playing = false
    }
    
    func audioStop() {
            audioEngine.stop()
            playing = false
    }
    
    func audioVolume(to volume: Float) {
        audioEngine.mainMixerNode.outputVolume = volume
    }
}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

