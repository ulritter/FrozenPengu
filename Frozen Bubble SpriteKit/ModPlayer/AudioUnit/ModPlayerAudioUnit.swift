//
//  ModPlayerUnit.swift
//  modplayer
//
//  Created by Nicolas Ramz - http://www.warpdesign.fr/ on 18/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation
import AVFoundation

let PaulaPeriods:Array<Float> = [
    856, 808, 762, 720, 678, 640, 604, 570, 538, 508, 480, 453,
    428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226,
    214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113];

var waveForms:Array<Array<Float>> = [[Float](repeating: 0.0, count: 64)];

// module channel struct
class Channel {
    var sample = -1
    var samplePos:Float = 0.0
    var period:Float = 0.0
    var volume:UInt8 = 64
    var slideTo = -1
    var slideSpeed = 0
    var delay = 0
    var vform:Float = 0.0
    var vdepth = 0
    var vspeed = 0
    var vpos = 0
    var loopInitiated = false
    var id = 0
    var cmd:UInt8 = 0
    var data:UInt8 = 0
    var done = false
    var off = false
    var loopStart = 0
    var loopCount = 0
    var loops = 0
    
    init(sample: Int = -1, samplePos: Float = 0.0, period:Float = 0.0, volume: UInt8 = 64, slideTo: Int = -1, slideSpeed: Int = 0, delay: Int = 0, vform: Float = 0.0, vdepth: Int = 0, vspeed: Int = 0, vpos:Int = 0, loopInitiated: Bool = false, id: Int = 0, cmd: UInt8 = 0, data: UInt8 = 0, done: Bool = false, off: Bool = false, loopStart: Int = 0, loopCount: Int = 0, loops: Int = 0) {
        self.sample = sample
        self.samplePos = samplePos
        self.period = period
        self.volume = volume
        self.slideSpeed = slideSpeed
        self.delay = delay
        self.vform = vform
        self.vdepth = vdepth
        self.vspeed = vspeed
        self.vpos = vpos
        self.loopInitiated = loopInitiated
        self.id = id
        self.cmd = cmd
        self.data = data
        self.done = done
        self.off = false
        self.loopStart = loopStart
        self.loopCount = loopCount
        self.loops = loops
    }
}

class Sample {
    var name: String = ""
    var length: UInt16 = 0
    var finetune: UInt8 = 0
    var volume: UInt8 = 0
    var repeatStart: UInt16 = 0
    var repeatLength: UInt16 = 0
    var data: Array<Float>? = nil
    
    init(name: String, length: UInt16, finetune: UInt8, volume: UInt8, repeatStart: UInt16, repeatLength: UInt16, data: Array<Float>?) {
        self.name = name
        self.length = length
        self.finetune = finetune
        self.volume = volume
        self.repeatStart = repeatStart
        self.repeatLength = repeatLength
        self.data = data
    }
}

class ModPlayerAudioUnit: CustomAudioUnit {
    var name = ""
    var samples: Array<Sample> = []
    var patterns: Array<Array<UInt8>> = []
    var positions: Array<UInt8> = []
    var songLength:UInt8 = 0
    var channels: Array<Channel> = [Channel](repeating: Channel(), count: 4)
    var maxSamples:UInt = 0
    // These are the default Mod speed/bpm
    var bpm = 125
    // number of ticks before playing next pattern row
    var speed = 6
    var speedUp = 1
    var position = 0
    var pattern:UInt8 = 0
    var row = 0
    var patternOffset = 0
    
    // samples to handle before generating a single tick (50hz)
    var samplesPerTick = 0
    var filledSamples = 0
    var ticks = 0
    var newTick = true
    var rowRepeat = 0
    var rowJump = -1
    var skipPattern = false
    var jumpPattern = -1

    var buffer:Data? = nil
    var started = false
    var ready = false
    
    // new for audioworklet
    var playing = false
    
    let patternLength = 1024
    
    var mixingRate = Float(48000.0)
    var hack = 0
    
    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)
        
        buildTables()
    }
    
    func buildTables() {
        // Sin waveform
        // an amplitude of 64 is supposed to be enough
        for i in 0..<waveForms[0].count {
            waveForms[0][i] = 64.0 * sin(Float.pi * 2.0 * (Float(i) / 64.0));
        }
    }

    func resetProperties() {
        name = ""
        samples = []
        patterns = []
        positions = []
        songLength = 0
        channels = [Channel](repeating: Channel(), count: 4)
        maxSamples = 0
        // These are the default Mod speed/bpm
        bpm = 125
        // number of ticks before playing next pattern row
        speed = 6
        speedUp = 1
        position = 0
        pattern = 0
        row = 0
        
        // samples to handle before generating a single tick (50hz)
        samplesPerTick = 0
        filledSamples = 0
        ticks = 0
        newTick = true
        rowRepeat = 0
        rowJump = -1
        skipPattern = false
        jumpPattern = -1
        patternOffset = 0
        
        buffer = nil
        started = false
        ready = false
        
        // new for audioworklet
        playing = false
    }
    
    func resetSongValues() {
        self.started = false
        self.position = 0
        self.row = 0
        self.ticks = 0
        self.filledSamples = 0
        self.speed = 6
        self.newTick = true
        self.rowRepeat = 0
        self.rowJump = -1
        self.skipPattern = false
        self.jumpPattern = -1
        self.createChannels()
        self.decodeRow()
    }
    
    func prepareModule(buffer: Data) {
//        print("Decoding module data...")
        self.ready = false
        self.resetProperties()
        self.buffer = buffer;
        self.name = BinUtils.readAscii(&self.buffer!, 20)
        
        self.getInstruments()
        self.getPatternData()
        self.getSampleData()
        self.calcTickSpeed()
        self.createChannels()
        self.resetSongValues()
        self.ready = true
    }

    func detectMaxSamples() {
        // first modules were limited to 15 samples
        // later it was extended to 31 and the 'M.K.'
        // marker was added at offset 1080
        // new module format even use other markers
        // but we stick to good old ST/NT modules
        let str = BinUtils.readAscii(&self.buffer!, 4, 1080)
        self.maxSamples = str.contains("M.K.") ? 31 : 15;
        
        if (self.maxSamples == 15) {
            self.patternOffset = 1080 - 480
        } else {
            self.patternOffset = 1084
        }
    }
    
    func getPatternData() {
        // pattern data always starts at offset 950
        let offset = self.maxSamples == 15 ? 470 : 950;
        
        // const uint8buffer = new Uint8Array(this.buffer, offset);
        let uint8buffer = Array(Array(self.buffer!)[offset..<self.buffer!.count])
        self.songLength = uint8buffer[0]
        var position = 2
        var max:UInt8 = 0
        
        for i in 0..<self.songLength {
            let pos = uint8buffer[position + Int(i)]
            self.positions.append(pos);
            if pos > max {
                max = pos
            }
        }
        
        position = self.patternOffset
        
        for  _ in 0...max {
            // self.patterns.append(this.buffer.slice(position, position + this.patternLength));
            self.patterns.append(Array(Array(self.buffer!)[position..<position + self.patternLength]))
            position += self.patternLength;
        }
    }
    
    func getInstruments() {
        self.detectMaxSamples()
        self.samples = []
        // instruments data starts at offset 20
        var offset = 20
        let uint8buffer = Array(self.buffer!)
        let headerLength = 30

        for _ in 0..<self.maxSamples {
            let sample = Sample(
                name: BinUtils.readAscii(&self.buffer!, 22, offset),
                length: BinUtils.readWord(&self.buffer!, offset + 22) * 2,
                finetune: uint8buffer[offset + 24] & 0xF0,
                volume: uint8buffer[offset + 25],
                repeatStart: BinUtils.readWord(&self.buffer!, offset + 26) * 2,
                repeatLength: BinUtils.readWord(&self.buffer!, offset + 28) * 2,
                data: nil
            )

            if sample.finetune > 0 {
//                print("finetune")
            }

            // Existing mod players seem to play a sample only once if repeatLength is set to 2
            if sample.repeatLength == 2 {
                sample.repeatLength = 0
                // some modules seems to skip the first two bytes for length
                if sample.length == 2 {
                    sample.length = 0
                }
            }

            if sample.repeatLength > sample.length {
                sample.repeatLength = 0
                sample.repeatStart = 0
            }

            self.samples.append(sample);

            offset += headerLength;
        }
    }
    
    func getSampleData() {
        // samples start right after patterns
        var offset = self.patternOffset + self.patterns.count * self.patternLength
        
        for i in 0..<self.samples.count {
            let length = self.samples[i].length
            var data = [Float](repeating: 0.0, count: Int(length))
            let maxLength = (offset + Int(length)) > self.buffer!.count ? self.buffer!.count - offset : Int(length)
            let pcm = Array(Array(self.buffer!.map{Int8(bitPattern: $0)})[offset..<offset+maxLength])
            
            // convert integer 8bit PCM (-127...127) to float audio (-1.0...1.0)
            for j in 0..<length {
                data[Int(j)] = Float(pcm[Int(j)]) / 128.0;
            }
            
            self.samples[i].data = data
            
            offset += maxLength
            
//            print("sample \(i) length=\(self.samples[i].length)")
        }
    }

    func calcTickSpeed() {
        self.samplesPerTick = ((Int(self.mixingRate) * 60) / (self.bpm * self.speedUp)) / 24;
//        print("calcTickSpeed = \(self.samplesPerTick)")
    }

    func createChannels() {
        for i in 0..<self.channels.count {
            let channel = Channel(
                sample: -1,
                samplePos: 0,
                period: 0,
                volume: 64,
                slideTo: -1,
                slideSpeed: 0,
                delay: 0,
                vform: 0,
                vdepth: 0,
                vspeed: 0,
                vpos: 0,
                loopInitiated: false,
                id: i,
                cmd: 0,
                data: 0,
                done: false,
                loopStart: 0,
                loopCount: 0,
                loops: 0
            )
    
            self.channels[i] = channel
//            if (!this.channels[i]) {
//            this.channels[i] = channel;
//            } else {
//            Object.assign(this.channels[i], channel);
//            }
        }
    }

    func getNextPattern(_ updatePos: Bool = false) {
        if updatePos {
            self.position += 1
        }
        
        // Loop ? Use loop parameter
        if self.position > self.positions.count - 1 {
            print("Warning: last position reached, going back to 0")
            self.position = 0
        }
        
        for i in 0..<self.channels.count {
            self.channels[i].loopInitiated = false
        }
        
        self.pattern = self.positions[Int(self.position)]
        
//        print("** position \(self.position) pattern: \(self.pattern)");
    }
    
    func decodeRow() {
        if (!self.started) {
            self.started = true;
            self.getNextPattern();
        }
        
        let pattern = self.patterns[Int(self.pattern)]
        
        let data = Array(pattern[self.row * 16..<16 + self.row * 16])
        
        for i in 0..<self.channels.count {
            let offset = i * 4
            let period = Int(data[offset] & 0x0F) << 8 | Int(data[1 + offset])
            let sample = Int(Int(data[offset] & 0xF0 | data[2 + offset] >> 4) - 1)
            let cmd = data[2 + offset] & 0xF
            let cmdData = data[3 + offset]
            let channel = self.channels[i]
            
            channel.delay = 0
            
            // check for command
            if cmd != 0 {
                // extended command
                if cmd == 0xE {
                    // note.extcmd = note.data >> 4;
                    channel.cmd = 0xE0 + (cmdData >> 4)
                    channel.data = cmdData & 0x0F
                } else {
                    channel.cmd = cmd
                    channel.data = cmdData
                }
            } else {
                channel.cmd = 0
            }
            
            // check for new sample
            if sample > -1 {
                if channel.cmd != 0x3 && channel.cmd != 0x5 {
                    channel.samplePos = 0
                }
                channel.done = false
                channel.sample = Int(sample)
                channel.volume = self.samples[Int(sample)].volume
            }
            
            if period != 0 {
                channel.done = false
                // portamento will slide to the period, keep the previous one
                if channel.cmd != 0x3 && channel.cmd != 0x5 {
                    channel.period = Float(period)
                    channel.samplePos = 0
                } else {
                    channel.slideTo = Int(period)
                }
            }
        }
    }
    
    func executeEffect(_ channel: Channel) {
        Effects.execute(channel, self)
    }
    
    func tick() {
        if self.filledSamples > self.samplesPerTick {
            self.newTick = true
            self.ticks += 1
            self.filledSamples = 0
            if self.ticks > self.speed - 1 {
//                print("new tick: \(self.ticks)")
                self.ticks = 0
                
                if self.rowRepeat <= 0 {
                    self.row += 1
                }
                
                if self.row > 63 || self.skipPattern {
                    self.skipPattern = false
                    if self.jumpPattern > -1 {
                        self.position = self.jumpPattern
                        self.jumpPattern = -1
                        self.getNextPattern()
                    } else {
                        self.getNextPattern(true)
                    }
                }
                
                if self.rowJump > -1 {
                    self.row = self.rowJump
                    self.rowJump = -1
                }
                
                if self.row > 63 {
                    self.row = 0
                }
                
                self.decodeRow()
            }
        }
    }
    
    func play() {
        if (self.ready) {
//            print("Let's gooooo !!!")
            self.playing = true
        }
    }
    
    // audio mix callback: this is where all the magic happens
    override var renderBlock: AURenderBlock {
        get {
            return {
                (actionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
                timestamp: UnsafePointer<AudioTimeStamp>,
                frameCount: AVAudioFrameCount,
                outputBusNumber: NSInteger,
                outputBufferListPtr: UnsafeMutablePointer<AudioBufferList>,
                pullInputBlock: AURenderPullInputBlock?) -> AUAudioUnitStatus in
                
                let numBuffers = outputBufferListPtr.pointee.mNumberBuffers
                let ptr = outputBufferListPtr.pointee.mBuffers.mData?.assumingMemoryBound(to: Float.self)
                
                if self.ready && self.playing {
                    
                    // print("timeStamp: \(timestamp.pointee.mSampleTime) frameCount: \(frameCount)")
                    let length = frameCount
                    
                    for i in 0..<length {
                        var outputChannel = 0;
                        
                        // clear both channel frames
                        (ptr! + Int(i)).pointee = 0
                        if (numBuffers > 1) {
                            (ptr! + Int(i) + Int(length)).pointee = 0
                        }
                        
                        // playing speed test
                        self.tick()
                        
                        for chan in 0..<self.channels.count {
                            let channel = self.channels[chan]
                            // select left/right output depending on module channel:
                            // voices 0,3 go to left channel, 1,2 go to right channel
                            outputChannel = outputChannel ^ (chan & 1)
                            
                            // real devices seem to only have one buffer (eg. iPhone 7):
                            // mix everything in one buffer in that case
                            let bufferOffset = (numBuffers == 1 || outputChannel == 0) ? 0 : frameCount
                            
                            // TODO: check that no effect can be applied without a note
                            // otherwise that will have to be moved outside this loop
                            if self.newTick && channel.cmd != 0 {
                                self.executeEffect(channel)
                            }
                            
                            if !channel.off && channel.period != 0 && channel.sample > -1 && !channel.done && self.ticks >= channel.delay {
                                
                                let sample = self.samples[channel.sample]
                                
                                // actually mix audio
                                (ptr! + Int(i + bufferOffset)).pointee += (sample.data![Int(floor(channel.samplePos))] * Float(channel.volume)) / 64.0
                                
                                //>>>>>>speed
                                let sampleSpeed = 7093789.2 / ((channel.period * 2.0) * self.mixingRate)
                                
                                channel.samplePos += sampleSpeed
                                
                                // repeat samples
                                if !channel.done {
                                    if sample.repeatLength == 0 && sample.repeatStart == 0 {
                                        if UInt16(channel.samplePos) >= sample.length {
                                            channel.samplePos = 0
                                            channel.done = true
                                        }
                                    } else if UInt16(channel.samplePos) >= (sample.repeatStart + sample.repeatLength) {
                                        channel.samplePos = Float(sample.repeatStart)
                                    }
                                }
                            }
                        }
                        self.filledSamples += 1
                        self.newTick = false
                    }
                }
                
                self.hack += 1
                
                return noErr
            }
        }
    }
}
