//
//  Effects.swift
//  modplayer
//
//  Created by Nico on 18/07/2019.
//  Copyright © 2019 Nico. All rights reserved.
//

import Foundation

struct Effects {
    static func execute(_ channel: Channel, _ module: ModPlayerAudioUnit) {
        switch(channel.cmd) {
        case 0x1:
            Effects._0x1(module, channel)
        case 0x2:
            Effects._0x2(module, channel)
        case 0x4:
            Effects._0x4(module, channel)
        case 0x5:
            Effects._0x5(module, channel)
        case 0x6:
            Effects._0x6(module, channel)
        case 0x9:
            Effects._0x9(module, channel)
        case 0xA:
            Effects._0xA(module, channel)
        case 0xB:
            Effects._0xB(module, channel)
        case 0xC:
            Effects._0xC(module, channel)
        case 0xD:
            Effects._0xD(module, channel)
        case 0xE0:
            Effects._0xE0(module, channel)
        case 0xE4:
            Effects._0xE4(module, channel)
        case 0xE6:
            Effects._0xE6(module, channel)
        case 0xE9:
            Effects._0xE9(module, channel)
        case 0xEA:
            Effects._0xEA(module, channel)
        case 0xEB:
            Effects._0xEB(module, channel)
        case 0xED:
            Effects._0xED(module, channel)
        case 0xEE:
            Effects._0xEE(module, channel)
        case 0xF:
            Effects._0xF(module, channel)
            
        default:
//            print("Effect not implemented: \(channel.cmd)")
            break

        }
    }
    
    /**
     * Slide up
     */
    static func _0x1(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks != 0 {
            channel.period -= Float(channel.data)
            
            if channel.period < 113 {
                channel.period = 113
            }
        }
    }
    /**
     * Slide down
     */
    static func _0x2(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks != 0 {
            channel.period += Float(channel.data)
            
            if channel.period > 856 {
                channel.period = 856
            }
        }
    }
    /**
     * Portamento (slide to note)
     */
    static func _0x3(_ module: ModPlayerAudioUnit, _ channel: Channel, _ doNotInit: Bool = false) {
        // zero tick: init effect
        if module.ticks == 0{
            if !doNotInit && channel.data != 0 {
                channel.slideSpeed = Int(channel.data)
            }
            // channel.slideTo = channel.period;
        } else if channel.slideTo != 0 && module.ticks != 0 {
            if channel.period < Float(channel.slideTo) {
                channel.period += Float(channel.slideSpeed)
                if channel.period > Float(channel.slideTo) {
                    channel.period = Float(channel.slideTo)
                }
            } else if channel.period > Float(channel.slideTo) {
                channel.period -= Float(channel.slideSpeed)
                if channel.period < Float(channel.slideTo) {
                    channel.period = Float(channel.slideTo)
                }
            }
        } else {
            print("portamento + volume slide: keeping previous values")
        }
    }
    /**
     * Vibrato
     */
    static func _0x4(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        // TODO: finish vibrato
        if module.ticks == 0 {
            let depth = channel.data & 0x0f
            let speed = (channel.data & 0xf0) >> 4
            
            // use previous values if speed or depth isn't set
            if speed > 0 && depth > 0 {
                channel.vdepth = Int(depth)
                channel.vspeed = Int(speed)
            }
            
            // new note: reset vibrato position if retriggered is set
            if channel.vform > 3 {
                channel.vpos = 0;
            }
        }
        
        // get current waveform table
        let table = waveForms[Int(channel.vform) & 0x3]
        // alter the note's period
        channel.period += Float((channel.vdepth * Int(table[channel.vpos]))) / 63.0
        
        // advance vpos at each tick
        channel.vpos += channel.vspeed;
        // wrap around
        if (channel.vpos > 63) {
            channel.vpos = channel.vpos - 64;
        }
    }
    /**
     * Volume Slide + Portamento (keep previous one)
     */
    static func _0x5(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        // perform portamento
        Effects._0x3(module, channel)
        // then volume slide
        Effects._0xA(module, channel)
    }
    /**
     * Volume Slide + Vibrato (keep previous)
     */
    static func _0x6(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        // perform vibrato
        Effects._0x4(module, channel)
        // then volume slide
        Effects._0xA(module, channel)
    }
    /**
     * set sample startOffset
     */
    static func _0x9(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            channel.samplePos = Float(channel.data) * 256.0
            // does it happen on next line ?
            // channel.done = true;
        }
    }
    /**
     * Volume slide: happens every non-zero tick
     */
    static func _0xA(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        // do not execute effect on tick 0
        if module.ticks != 0 {
            let x = channel.data >> 4
            let y = channel.data & 0x0F
            
            if y == 0 {
                channel.volume += x
            } else if x == 0 {
                if channel.volume >= y {
                    channel.volume -= y
                } else {
                    channel.volume = 0
                }
            }
            
            if channel.volume > 63 {
                channel.volume = 63
            } else if channel.volume <= 0 {
                channel.volume = 0
            }
        }
    }
    /**
     * Position Jump
     */
    static func _0xB(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if channel.data >= 0 && channel.data <= module.patterns.count - 1 {
            module.skipPattern = true
            module.jumpPattern = Int(channel.data)
            module.rowJump = 0
        }
    }
    /**
     * Set channel volume
     */
    static func _0xC(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            channel.volume = channel.data
            if channel.volume > 63 {
                channel.volume = 63
            }
        }
    }
    /**
     * Row jump
     */
    static func _0xD(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            module.rowJump = Int(((channel.data & 0xf0) >> 4) * 10 + (channel.data & 0x0f))
            module.skipPattern = true
        }
    }
    /**
     * Toggle low-pass filter
     */
    static func _0xE0(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
//            print("need to toggle lowPass")// , !!channel.data);
            // Module.toggleLowPass(!!channel.data);
        }
    }
    /**
     * Set Vibrato waveform + retrigger
     */
    static func _0xE4(_ module: ModPlayerAudioUnit, _ channel: Channel) {
//        print("Effect 0xE4 not implemented yet")
        if module.ticks == 0{
            // channel.vform = //
        }
    }
    /**
     * Loop pattern
     */
    static func _0xE6(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            // called with 0: this is the loop start point
            if channel.data == 0 {
                if !channel.loopInitiated {
                    channel.loopInitiated = true
                    channel.loopStart = module.row
                    channel.loopCount = 0
                } else {
                    if channel.loops == channel.loopCount {
                        channel.loopInitiated = false
                    }
                }
            } else if channel.loopInitiated {
                module.rowJump = channel.loopStart
                if channel.loopCount == 0 {
                    // init loop count
                    channel.loopCount = Int(channel.data)
                    channel.loops = 1
                } else {
                    channel.loops += 1
                }
            }
        }
    }
    /**
     * Retrigger note every xxxx ticks
     */
    static func _0xE9(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if ((module.ticks + 1) % Int(channel.data)) == 0 {
//            print("retriggering note! \(module.ticks + 1)")
            // should we use repeat pos (if specified) instead ?)
            channel.samplePos = 0
            channel.done = false
        }
    }
    /**
     * Add to volume
     */
    static func _0xEA(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            channel.volume += channel.data
            if channel.volume > 63 {
                channel.volume = 63
            }
        }
    }
    /**
     * Decrease volume
     */
    static func _0xEB(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            if channel.volume >= channel.data {
                channel.volume -= channel.data
            } else {
                channel.volume = 0
            }
//            channel.volume -= channel.data
//            if channel.volume < 0 {
//                channel.volume = 0
//            }
        }
    }
    /**
     * Delay sample start
     */
    static func _0xED(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            channel.delay = Int(channel.data)
        }
    }
    /**
     * Repeat Row
     */
    static func _0xEE(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            if module.rowRepeat == 0 {
                module.rowRepeat = Int(channel.data)
//                print("setting repeat to \(module.rowRepeat)")
            } else if module.rowRepeat != 0 {
                module.rowRepeat -= 1
            }
        }
    }
    /**
     *
     * Change playback speed
     */
    static func _0xF(_ module: ModPlayerAudioUnit, _ channel: Channel) {
        if module.ticks == 0 {
            if channel.data < 32 {
                module.speed = Int(channel.data)
            } else {
                module.bpm = Int(channel.data)
                module.calcTickSpeed()
            }
        }
    }
}
