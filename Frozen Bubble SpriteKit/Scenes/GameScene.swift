//
//  GameScene.swift
//  Frozen Bubble SpriteKit
//
//  Created by Uwe Ritter on 02.03.23.
//  Copyright © 2023 Uwe Ritter IT Beratung. All rights reserved.
//

// Main game engine

import SpriteKit

class GameScene: SKScene {
    
    var sceneAudio: SKAudioNode!
     
    enum GameState {
        case ready, ongoing, won, lost
    }
    
    var gameState: GameState = GameState.ready {
        // game state observer
        willSet {
            switch newValue {
            case .ready:
                break
            case .ongoing:
                penguin.animate(for: C.S.playAction)
            case .won:
                self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                ScoreHelper.updatePuzzleScoreTable(for: levelKey, with: numberOfShots, taking: Date.timeIntervalSinceReferenceDate-startTime)
                if isSoundOn {
                
                    run(soundPlayer.applauseSound)
                }
                penguin.animate(for: C.S.cheerAction)
                addGameEndPanel(win: true)
            case .lost:
                self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                fieldFreeze()
                if isSoundOn {
                    run(soundPlayer.nohSound)
                }
                if !isPuzzle {
                    ScoreHelper.updateArcadeScoreTable(with: numberOfShots, taking: Date.timeIntervalSinceReferenceDate-startTime)
                }
                penguin.animate(for: C.S.cryAction)
                addGameEndPanel(win: false)
            }
        }
    }
    var soundPlayer = SoundPlayer()
    var lastTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var dtCumulated: TimeInterval = 0
    var hurryTimer: TimeInterval = 0
    var startTime: TimeInterval!
    
    var shotCounter: Int = 0
    
    var theGrid = [GridCell]()
    var theAddonGrid = [GridCell]()
    var playField: SKSpriteNode!
    var penguin: Penguin!
    var compressor: Compressor!
    var leftBorder: SKSpriteNode!
    var rightBorder: SKSpriteNode!
    var bottomBorder: SKSpriteNode!
    
    var playFieldBottom: CGFloat!
    var fingerOnScreen = false
    
    var physicsBoundsRight: CGFloat!
    var physicsBoundsBottom: CGFloat!
    var physicsBoundsLeft: CGFloat!
    var physicsBoundsTop: CGFloat!
    var yTop: CGFloat!
    var reserverBubbleY: CGFloat!
    var lastReserveBubbleColorKey: Int!
    
    var bubbleCellWidth: CGFloat!
    var bubbleCellHeight: CGFloat!
    var initialCompressorPosition = C.B.maxRows
    
    var sceneManagerDelegate: SceneManagerDelegate?
    var sKPhysicsContactDelegate: SKPhysicsContactDelegate?
    var modPlayerDelegate: ModPlayerDelegate!
    
    var level: [Int]!
    var levelKey: Int!

    let refBubbleScaler = CGFloat(0.095)
    
    var launcher: Launcher!
    var launcherX: CGFloat!
    var launcherY: CGFloat!
    var levelLabelX: CGFloat!
    var levelLabelY: CGFloat!
    
    var isSoundOn: Bool!
    var isMusicOn: Bool!
    var bubbleType: String!
    var stroredLevelIndex: Int!
    var lastTouchPosition = CGPoint.zero
    
    var collisionReturnValue = CollisionReturnValue()
    var shotBubble: Bubble!
    var reserveBubble: Bubble!
    var remainingBubbleColors = [1,2,3,4,5,6,7,8]
    var levelManagerDelegate: LevelManagerDelegate!
    var numberOfShots = 0
    var isPuzzle = true
    var isLongLine = false
    var driftDivider = 0
    
    
    init(size: CGSize,levelManagerDelegate: LevelManagerDelegate, modPlayerDelegate: ModPlayerDelegate) {
        super.init(size: size)
        self.sceneAudio = SKAudioNode()
        self.levelManagerDelegate = levelManagerDelegate
        self.modPlayerDelegate = modPlayerDelegate
        self.levelKey = PrefsHelper.getSinglePlayerLevel()
        self.level = self.levelManagerDelegate.loadLevel(level: levelKey)
        self.isSoundOn = PrefsHelper.isSoundOn()
        self.isMusicOn = PrefsHelper.isMusicOn()
        self.bubbleType = PrefsHelper.getBubbleType()
        
        if isMusicOn {
                self.modPlayerDelegate.audioStart()
        } else {
                self.modPlayerDelegate.audioPause()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        isPuzzle = PrefsHelper.getGameMode() == C.S.puzzleText
        self.anchorPoint = CGPoint.zero
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.0)
        autoShoot.timer = 0
        autoShoot.stage = 0
        
        addPlayfield()
        setPropotionsAndPositions()
        addBorders()
        addPenguin()
        addCompressor()
        addLauncher()
        addLevelLabel()
        buildGrid()
        addHurryPanel()
        loadActualLevel()
        lastReserveBubbleColorKey = getRandomBubbleColorKey()
        addBubblePair()
        addBackButton()
        startTime = Date.timeIntervalSinceReferenceDate
        numberOfShots = 0
        lastTouchPosition = CGPoint(x: frame.midX, y: frame.midY)
        if !isPuzzle {
            addArcadeRowOnTop()
        }
    }
    
    func setPropotionsAndPositions() {
        // get all proportions and positions for given device dimensions
        // determine bubble dimensions
        let refBubble = Bubble(with: frame.size, as: 1)
        refBubble.scale(to: playField.frame.size, width: true, multiplier: refBubbleScaler)
        bubbleCellWidth = refBubble.frame.width
        bubbleCellHeight = refBubble.frame.height
        
        let yScaler =  self.size.height / playField.size.height
        
        // get screen positions relative to proportions of original png images
        physicsBoundsLeft = playField.frame.maxX*0.15
        physicsBoundsBottom = self.frame.height*215/1024*yScaler
        launcherX = frame.midX
        launcherY = playFieldBottom+frame.maxY*0.1
        reserverBubbleY = playFieldBottom+(playField.frame.height-playField.frame.height*971/1024)
        physicsBoundsRight = physicsBoundsLeft + bubbleCellWidth*CGFloat(C.B.maxColumns)
        physicsBoundsTop = physicsBoundsBottom + bubbleCellHeight*CGFloat(C.B.maxRows)
        yTop = physicsBoundsBottom + bubbleCellHeight*C.B.bubbleYModifier*CGFloat(C.B.maxRows)
        levelLabelY = playFieldBottom+(playField.frame.height-playField.frame.height*970/1024)
        levelLabelX = self.frame.width*60/711
    }
    
    
    func addPlayfield() {
        playField = SKSpriteNode(imageNamed: C.S.playBackgroundName)
        playField.anchorPoint = CGPoint.zero
        
        let xSize = frame.size.width
        let ySize = (xSize / playField.size.width) * playField.size.height
        playField.size = CGSize(width: xSize, height: ySize)
        
        playFieldBottom = (self.frame.size.height-playField.frame.size.height)/2
        playField.position = CGPoint(x: 0.0, y: playFieldBottom)
        playField.zPosition = C.Z.farBGZ
        addChild(playField)
    }
    
    func addBorders() {
        let lO = CGPointMake(physicsBoundsLeft-bubbleCellWidth/2, 0.0)
        let lD = CGPointMake(physicsBoundsLeft-bubbleCellWidth/2, physicsBoundsTop)
        let bH = frame.size.height
        leftBorder = Line(origin: lO, destination: lD)
        PhysicsHelper.addPhysicsBody(to: leftBorder, using: leftBorder.position, height: bH, with: C.S.leftBorderName)
        leftBorder.zPosition = C.Z.objectZ
        leftBorder.anchorPoint = CGPoint.zero
        leftBorder.position = CGPointMake(physicsBoundsLeft-bubbleCellWidth/2, 0.0)
        addChild(leftBorder)
     
        let rO = CGPointMake(physicsBoundsRight-bubbleCellWidth/2, 0.0)
        let rD = CGPointMake(physicsBoundsRight-bubbleCellWidth/2, physicsBoundsTop)
        rightBorder = Line(origin: rO, destination: rD)
        PhysicsHelper.addPhysicsBody(to: rightBorder, using: rightBorder.position, height: bH, with: C.S.rightBorderName)
        rightBorder.zPosition = C.Z.objectZ
        rightBorder.anchorPoint = CGPoint.zero
        rightBorder.position = CGPointMake(physicsBoundsRight-bubbleCellWidth/2, 0.0)
        addChild(rightBorder)
    }
    
    func addPenguin() {
        penguin = Penguin(imageNamed: C.S.penguinImageName)
        penguin.anchorPoint = CGPoint.zero
        penguin.scale(to: playField.frame.size, width: true, multiplier: 0.156)
        penguin.name = C.S.penguinName
        penguin.position = CGPoint(x: playField.frame.maxX*0.62, y: playField.frame.maxY*0.003)
        penguin.zPosition = C.Z.objectZ
        penguin.loadTextures()
        playField.addChild(penguin)
    }
    
    func addLevelLabel() {
        let levelLabel = SKLabelNode(fontNamed: C.S.gameFontName)
        if isPuzzle {
            levelLabel.text = String(levelKey+1) // array index starts from 0 as always
            levelLabel.fontSize = 200.0
            levelLabel.scale(to: frame.size, width: true, multiplier: 0.05)
        } else {
            levelLabel.text = String(C.S.arcadeText)
            levelLabel.fontSize = 200.0
            levelLabel.scale(to: frame.size, width: true, multiplier: 0.17)
        }
        levelLabel.position = CGPoint(x: levelLabelX, y: levelLabelY)
        levelLabel.fontColor = C.S.levelLabelFontColor
        
        levelLabel.zPosition = C.Z.panelZ
        addChild(levelLabel)
    }
    
    func addCompressor() {
        compressor = Compressor(with: playField.size, and: bubbleCellHeight*C.B.bubbleYModifier)
        let compressorY = physicsBoundsBottom+3+bubbleCellHeight*C.B.bubbleYModifier*CGFloat(C.B.maxRows)
        compressor.position = CGPoint(x: frame.minX, y: compressorY)
        compressor.zPosition = C.Z.compressorZ
        addChild(compressor)
    }
    
    func addLauncher () {
        launcher = Launcher(with: playField.size)
        launcher.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        launcher.scale(to: frame.size, width: false, multiplier: 0.2)
        launcher.position = CGPoint(x: launcherX, y: launcherY)
        launcher.zPosition = C.Z.objectZ
        addChild(launcher)
    }
    
    func addBubblePair() {
        self.childNode(withName: C.S.shotBubbleName)?.removeFromParent()
        self.childNode(withName: C.S.reserveBubbleName)?.removeFromParent()
        let reserveBubbleColorKey = getRandomBubbleColorKey()

        shotBubble = Bubble(with: frame.size, as: lastReserveBubbleColorKey!)
        shotBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
        shotBubble.position = CGPoint(x: launcherX, y: launcherY)
        shotBubble.zPosition = C.Z.bubbleZ
        shotBubble.name = C.S.shotBubbleName
        addChild(shotBubble)
        
        reserveBubble = Bubble(with: frame.size, as: reserveBubbleColorKey)
        reserveBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
        reserveBubble.position = CGPoint(x: launcherX, y: reserverBubbleY)
        reserveBubble.zPosition = C.Z.bubbleZ
        reserveBubble.name = C.S.reserveBubbleName
        addChild(reserveBubble)
        lastReserveBubbleColorKey = reserveBubbleColorKey
        culateRemainingBubbleColors()

    }
    
    func getRandomBubbleColorKey () -> Int {
        if isPuzzle {
            return remainingBubbleColors[Int.random(in: 0..<remainingBubbleColors.count)]
        } else {
            return remainingBubbleColors[Int.random(in: 0..<remainingBubbleColors.count-3)]
        }
    }
    
    func culateRemainingBubbleColors() {
        if isPuzzle {
            remainingBubbleColors.removeAll()
            for cell in theGrid {
                if cell.bubble != nil {
                    let c = cell.bubble!
                    if !(remainingBubbleColors.contains(c.bubbleColor)) {
                        remainingBubbleColors.append(c.bubbleColor)
                    }
                }
            }
        }
    }
    
    func switchLauncherBubbles(_: Int) {
        
        let b1 = self.childNode(withName: C.S.shotBubbleName) as! Bubble
        let b2 = self.childNode(withName: C.S.reserveBubbleName) as! Bubble
        let b1Color = b1.getColor()
        let b2Color = b2.getColor()
        b1.removeFromParent()
        b2.removeFromParent()

        shotBubble = Bubble(with: frame.size, as: b2Color)
        shotBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
        shotBubble.position = CGPoint(x: launcherX, y: launcherY)
        shotBubble.zPosition = C.Z.bubbleZ
        shotBubble.name = C.S.shotBubbleName
        addChild(shotBubble)
        
        reserveBubble = Bubble(with: frame.size, as: b1Color)
        reserveBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
        reserveBubble.position = CGPoint(x: launcherX, y: reserverBubbleY)
        reserveBubble.zPosition = C.Z.bubbleZ
        reserveBubble.name = C.S.reserveBubbleName
        addChild(reserveBubble)
        lastReserveBubbleColorKey = b1Color
        if isSoundOn {
            run(soundPlayer.whipSound)
        }
    }
    
    func addBackButton() {
        let backButton = SpriteKitButton(defaultButtonImage: C.S.backButton, action: gotoMenu, index: 0)
        backButton.scale(to: frame.size, width: false, multiplier: 0.07)
        backButton.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        backButton.setScale(0.55)
        backButton.position = CGPoint(x: frame.maxX-frame.maxX*0.061, y: frame.maxY*0.028)
        backButton.zPosition = C.Z.hudZ
        playField.addChild(backButton)
    }
    
    func addGameEndPanel(win: Bool) {
        var panel: SpriteKitButton!
        if win && isPuzzle {
            panel = SpriteKitButton(defaultButtonImage: C.S.winPanel, action: gotoPuzzleScore, index: 0)
        } else {
            if isPuzzle {
                panel = SpriteKitButton(defaultButtonImage: C.S.losePanel, action: gotoGame, index: 0)
            } else {
                panel = SpriteKitButton(defaultButtonImage: C.S.losePanel, action: gotoArcadeScore, index: 0)
            }
        }
        panel.scale(to: frame.size, width: true, multiplier: 1.0)
        panel.position = CGPoint(x: frame.midX, y: frame.midY)
        panel.zPosition = C.Z.panelZ
        addChild(panel)
    }
    
    func addHurryPanel() {
        let panel = SKSpriteNode(imageNamed: C.S.hurryPanel)
        panel.scale(to: frame.size, width: true, multiplier: 1.0)
        panel.position = CGPoint(x: frame.midX, y: frame.midY)
        panel.zPosition = C.Z.panelZ
        panel.name = C.S.hurryPanel
        panel.alpha = 0.0
        addChild(panel)
    }
    
    func buildGrid() {
        // create a one dimensional array describing a two domensional grid by
        // assigning the position on the screen relative to the actual screen size
        theGrid.removeAll()
        var gridCell = GridCell()

        var innerX: CGFloat
        var innerY: CGFloat
        for row in 0...C.B.maxRows-1 {
            // coordinates is bottom to top
            // grid is top to bottom
            // does not really matter but needs to be kept in mind
            let actRow = C.B.maxRows - 1 - row
            let unEven = actRow % 2 == 0
            let actMaxColumns = unEven ? C.B.maxColumns - 1 : C.B.maxColumns
            
            for column in 0...actMaxColumns-1 {
                innerY = bubbleCellHeight*C.B.bubbleYModifier*CGFloat(actRow)
                if unEven {
                    innerX = bubbleCellWidth*CGFloat(column)+bubbleCellWidth/2
                } else {
                    innerX = bubbleCellWidth*CGFloat(column)
                }
                gridCell.position = CGPoint(x: physicsBoundsLeft+innerX, y: physicsBoundsBottom+innerY+bubbleCellHeight/2)
                theGrid.append(gridCell)
            }
        }
    }

    
    func loadActualLevel() {
        // populate "theGrid" with actual level data if in puzzle mode
        // or load the first half of the grid with random bubbles when
        // in Arcade mode
        var index = 0
        var rows = 0
        if isPuzzle {
            rows = C.B.maxRows-1
        } else {
            rows = C.B.maxRows/2-1
        }
        
        for row in 0...rows {
            let actRow = C.B.maxRows - row - 1
            let unEven = actRow % 2 == 0
            let actMaxColumns = unEven ? C.B.maxColumns - 1 : C.B.maxColumns
            
            for _ in 0...actMaxColumns-1 {
                if (index < level.count && (level[index] != C.B.emptyMarker)) || !isPuzzle {
                    var bubble: Bubble!
                    if isPuzzle {
                        bubble = Bubble(with: frame.size, as: level[index]+1)
                    } else {
                        bubble = Bubble(with: frame.size, as: getRandomBubbleColorKey())
                    }
                    PhysicsHelper.addPhysicsBody(to: bubble, with: C.S.bubbleName)
                    bubble.zPosition = C.Z.bubbleZ
                    bubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
                    bubble.name = C.S.gridBubbleName
                    bubble.position = theGrid[index].position!
                    theGrid[index].bubble = bubble
                    addChild(theGrid[index].bubble!)
                }
                index += 1
            }
        }
        culateRemainingBubbleColors()
    }
    
    func addArcadeRowOnTop() {
        var gridCell = GridCell()
        let numberOfColumns = isLongLine ? C.B.maxColumns : C.B.maxColumns-1
        let nextRowIndex = isLongLine ? C.B.maxColumns-1 : C.B.maxColumns
        theAddonGrid.removeAll()
        for index in 0...numberOfColumns-1 {
            gridCell.position = theGrid[nextRowIndex+index].position!
            let newY = gridCell.position!.y+bubbleCellHeight*C.B.bubbleYModifier*2
            gridCell.position!.y = newY
            let bubble = Bubble(with: frame.size, as: getRandomBubbleColorKey())
            bubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
            bubble.position = gridCell.position!
            bubble.name = C.S.gridBubbleName
            PhysicsHelper.addPhysicsBody(to: bubble, with: C.S.bubbleName)
            bubble.zPosition = C.Z.bubbleZ
            gridCell.bubble = bubble
            theAddonGrid.append(gridCell)
            addChild(gridCell.bubble!)
        }
        isLongLine = !isLongLine
    }
    
    func closestEmptyCell(point: CGPoint) -> Int {
        // get the position of the closest empty cell
        // which can be used for docking
        var oldDistance = CGFloat(Int.max)
        var snapIndex = Int.max

        for (index, gridCell) in theGrid.enumerated() {
            let testPoint = gridCell.position!
            let distance = TrigonometryHelper.distance(testPoint, point)
            if (distance < oldDistance) && gridCell.bubble == nil && distance < bubbleCellWidth {
                oldDistance = distance
                snapIndex = index
            }
        }
        return snapIndex
    }
    

    func shootBubble(to touchPos: CGPoint) {
        // shoot a bubble towards a point, push
        // the compressor everey n shots, and
        // reset the autoshoot timer
        shotCounter += 1
        childNode(withName: C.S.hurryPanel)?.alpha = 0.0
        if (shotCounter > C.B.maxColumns-1) && isPuzzle {
            pushCompressor()
        }
        autoShoot.timer = 0
        if gameState != .lost {
            let polePositionBubble = self.childNode(withName: C.S.shotBubbleName) as! Bubble
            let shotBubble = Bubble(with: frame.size, as: polePositionBubble.getColor())
            shotBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
            shotBubble.position = CGPoint(x: launcherX, y: launcherY)
            shotBubble.zPosition = C.Z.bubbleZ
            PhysicsHelper.addPhysicsBody(to: shotBubble, with: C.S.bubbleName)
            shotBubble.physicsBody!.categoryBitMask = C.P.shootBubbleCategory
            shotBubble.name = C.S.flyingBubbleName
            addChild(shotBubble)
            shotBubble.shoot(from: CGPointMake(launcherX, launcherY), to: touchPos)
            if isSoundOn {
                run(soundPlayer.launchSound)
            }
        }
    }
    
    func rotateLauncher(pos: CGPoint) {
        // rotate the launcher sprite towards a point
        let normalY = launcherY!
        if pos.y >= physicsBoundsBottom {
            
            let deltaY = pos.y - normalY
            let deltaX = pos.x - frame.midX
            launcher.rotate(dX: deltaX, dY: deltaY)
        }
    }
    
    func pushCompressor () {
        // push the compressor one grid row downwards and adjust
        // the coordinates in "theGrid" accordingly
        shotCounter = 0
        if initialCompressorPosition > 0 {
            initialCompressorPosition -= 1
            compressor.down()
            compressor.position = CGPoint(x: frame.minX, y: physicsBoundsBottom+3+bubbleCellHeight*C.B.bubbleYModifier*CGFloat(initialCompressorPosition))
            
            for index in 0..<theGrid.count {
                theGrid[index].position!.y = theGrid[index].position!.y-bubbleCellHeight*C.B.bubbleYModifier
                if theGrid[index].bubble != nil {
                    let c = theGrid[index].bubble! as Bubble
                    c.position.y = c.position.y-bubbleCellHeight*C.B.bubbleYModifier
                    if c.position.y < physicsBoundsBottom+bubbleCellHeight/4 {
                        self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                        gameState = .lost
                        break
                    }
                }
            }
            if isSoundOn {
                run(soundPlayer.newRootSoloSound)
            }
        }
    }
    
    func driftDownAndHandlePlayfield () {
        // push the compressor one grid row downwards and adjust
        // the coordinates in "theGrid" accordingly
        driftDivider += 1
        handlePlayField()
        if driftDivider > 4 {
            driftDivider = 0
            let delta = 0.6
            
            for index in 0..<theAddonGrid.count {
                theAddonGrid[index].position!.y = theAddonGrid[index].position!.y-delta
                let c = theAddonGrid[index].bubble! as Bubble
                c.position.y = c.position.y-delta
            }
            for index in 0..<theGrid.count {
                theGrid[index].position!.y = theGrid[index].position!.y-delta
                if theGrid[index].bubble != nil {
                    let c = theGrid[index].bubble! as Bubble
                    c.position.y = c.position.y-delta
                    if c.position.y < physicsBoundsBottom+bubbleCellHeight/4 {
                        self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                        gameState = .lost
                        return
                    }
                }
            }
            handlePlayField()
            if theAddonGrid[0].position!.y < yTop {
                let offSet = theAddonGrid.count
                
                for i in 0..<theGrid.count {
                    let index = theGrid.count-1-i
                    let targetIndex = index-offSet
                    if targetIndex >= 0 {
                        theGrid[index] = theGrid[targetIndex]
                    }
                }
                for i in 0..<theAddonGrid.count {
                    theGrid[i] = theAddonGrid[i]
                }
                addArcadeRowOnTop()
                handlePlayField()
            }
           
        }
        
    }
    
    func fieldBlink() {
        // let all bubbles blink by toggling the texture
        for child in self.children {
        if child is Bubble {
            let c = child as! Bubble
                c.blink()
            }
        }
    }
    
    func fieldFreeze() {
        // let all bubbles freeze by switching the texture
        for child in self.children {
        if child is Bubble {
            let c = child as! Bubble
                c.setTexture(textureKey: 1)
            }
        }
    }
    
    func autoshootHandler() {
        // handle autoshoot warnings / actions
        if gameState == .ready {
            if  autoShoot.timer > C.B.autoshootTriggerTime && autoShoot.stage == 0 && gameState == .ready {
                autoShoot.stage = 1
            }
            
            if autoShoot.stage > 0 {
                if  autoShoot.timer > C.B.autoshootTriggerTime && autoShoot.stage == 1 {
                    childNode(withName: C.S.hurryPanel)?.alpha = 1.0
                    if isSoundOn {
                        run(soundPlayer.hurrySound)
                    }
                    autoShoot.stage += 1
                }
                if  autoShoot.timer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime && autoShoot.stage == 2 {
                    childNode(withName: C.S.hurryPanel)?.alpha = 0.0
                    autoShoot.stage += 1
                }
                if  autoShoot.timer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*2.0 && autoShoot.stage == 3 {
                    fieldBlink()
                    autoShoot.stage += 1
                }
                if  autoShoot.timer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*3.0 && autoShoot.stage == 4 {
                    fieldBlink()
                    autoShoot.stage += 1
                }
                if  autoShoot.timer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*4.0 && autoShoot.stage == 5 {
                    fieldBlink()
                    autoShoot.stage += 1
                }
                if  autoShoot.timer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*5.0  && autoShoot.stage == 6 {
                    autoShoot.stage = 0
                    shootBubble(to: lastTouchPosition)
                }
            }
        }
    }
    
    func handlePlayField() {
        if gameState != .won && gameState != .lost {
            gameState = .ready
            for child in self.children {
                if child is Bubble {
                    let c = child as! Bubble
                    if c.isFlying() {
                        gameState = .ongoing
                    }
                    if c.position.y < playFieldBottom {
                        c.removeFromParent()
                    }
                    if c.name == C.S.flyingBubbleName {
                        // check if we can dock somewhere
                        // we don't use physics body for docking due to timing issues (both balls would bounce)
                        // but rather check the grid coordinates
                        for (_, gridCell) in theGrid.enumerated() {
                            if  (((TrigonometryHelper.distance(gridCell.position!, c.position) < bubbleCellWidth*0.9) && (gridCell.bubble != nil)
                                 && (c.position.y <= gridCell.position!.y)/* don't dock on top of another bubble*/)
                                || ((gridCell.bubble == nil) && (c.position.y > theGrid[0].position!.y)
                                    && (TrigonometryHelper.distance(gridCell.position!, c.position) < bubbleCellWidth)))
                            {
                                gameState = .ready
                                let dockingBubble = Bubble(with: frame.size, as: c.getColor())
                                dockingBubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
                                dockingBubble.zPosition = C.Z.bubbleZ
                                PhysicsHelper.addPhysicsBody(to: dockingBubble, with: C.S.bubbleName)
                                dockingBubble.name = C.S.gridBubbleName
                                let gridIndex = closestEmptyCell(point: c.position)
                                c.removeFromParent()
                                if gridIndex < theGrid.count {
                                    if theGrid[gridIndex].position!.y < physicsBoundsBottom-bubbleCellWidth/4 {
                                        self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                                        gameState = .lost
                                        break
                                    }
                                    theGrid[gridIndex].bubble = dockingBubble
                                    dockingBubble.position = theGrid[gridIndex].position!
                                    addChild(dockingBubble)
                                   
                                    collisionReturnValue = CollisionHelper.ckeckGrid(grid: &theGrid, at: gridIndex)
                                    
                                    let numberOfRemainingBubbles = collisionReturnValue.bubblesLeft
                                    if isSoundOn {
                                        if collisionReturnValue.didDrop {
                                            run(soundPlayer.destroyGroupdSound)
                                        } else {
                                            run(soundPlayer.stickSound)
                                        }
                                    }
                                    if (numberOfRemainingBubbles == 0) && isPuzzle {
                                        gameState = .won
                                    }
                                } else {
                                    //we are past "theGrid" size and haven't found an empty grid position
                                    self.childNode(withName: C.S.flyingBubbleName)?.removeFromParent()
                                    gameState = .lost
                                }
                                break
                            }
                        }
                    }
                }
            }
        }
    }

    func isSwitchTouch(at pos: CGPoint) -> Bool {
        if ((pos.x > launcherX-bubbleCellWidth) && pos.x < (launcherX+bubbleCellWidth)) &&
            ((pos.y > playFieldBottom) && (pos.y < physicsBoundsBottom)) {
          return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        if let touch = touches.first {
            let touchPos = touch.location(in: self)

            if (touchPos.y >= physicsBoundsBottom) {
                if gameState == .ready {

                    lastTouchPosition = touchPos
                    gameState = .ongoing
                    rotateLauncher(pos: touchPos)
                    shootBubble(to: touchPos)
                    addBubblePair()
                    numberOfShots += 1
                }
            } else if isSwitchTouch(at: touchPos) {
                switchLauncherBubbles(0)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastTime > 0 {
            dt = currentTime - lastTime
            dtCumulated += dt
        }
        lastTime = currentTime
        if dtCumulated > 0.005 {
            autoShoot.timer += dtCumulated
            autoshootHandler()
            dtCumulated=0
            if !isPuzzle && gameState != .lost {
                driftDownAndHandlePlayfield()
            } else {
                handlePlayField()
            }
        }
    }
    
    func gotoMenu(_: Int) {
        sceneManagerDelegate?.presentMenuScene()
    }
    
    func gotoGame(_: Int) {
        sceneManagerDelegate?.presentGameScene()
    }
    
    func gotoPuzzleScore(_: Int) {
        levelKey += 1
        PrefsHelper.setSinglePlayerLevel(to: levelKey)
        sceneManagerDelegate?.presentPuzzleScoresScene()
    }
    
    func gotoArcadeScore(_: Int) {
        sceneManagerDelegate?.presentArcadeScoresScene()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
                switch contactMask {
                case C.P.shootBubbleCategory | C.P.leftBorderCategory:
                    if isSoundOn {
                        run(soundPlayer.reboundSound)
                    }
                case C.P.shootBubbleCategory | C.P.rightBorderCategory:
                    if isSoundOn {
                        run(soundPlayer.reboundSound)
                    }
                case C.P.shootBubbleCategory | C.P.topCategory:
                    break
                default:
                    break
                }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
}

