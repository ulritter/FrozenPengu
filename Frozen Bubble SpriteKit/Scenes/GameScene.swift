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
                ScoreHelper.updateScoreTable(for: levelKey, with: numberOfShots, taking: Date.timeIntervalSinceReferenceDate-startTime)
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
    var autoshootTimer: TimeInterval = 0
    var autoshootWarningStage: Int = 0
    
    var shotCounter: Int = 0
    
    var theGrid = [GridCell]()
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
    
    
    init(size: CGSize,levelManagerDelegate: LevelManagerDelegate, modPlayerDelegate: ModPlayerDelegate) {
        super.init(size: size)
        self.levelManagerDelegate = levelManagerDelegate
        self.modPlayerDelegate = modPlayerDelegate
        self.levelKey = PrefsHelper.getSinglePlayerLevel()
        self.level = self.levelManagerDelegate.loadLevel(level: levelKey)
        self.isSoundOn = PrefsHelper.isSoundOn()
        self.isMusicOn = PrefsHelper.isMusicOn()
        self.bubbleType = PrefsHelper.getBubbleType()
        
//        if isMusicOn {
//            if !self.modPlayerDelegate.isMusicPlaying() {
//                self.modPlayerDelegate.audioStart()
//            }
//        } else {
//            if self.modPlayerDelegate.isMusicPlaying() {
//                self.modPlayerDelegate.audioPause()
//            }
//        }
        
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
        self.anchorPoint = CGPoint.zero
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.0)
        
        addPlayfield()
        getPropotionsAndPositions()
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
        addSwitchButton()
        addBackButton()
        startTime = Date.timeIntervalSinceReferenceDate
        numberOfShots = 0
        lastTouchPosition = CGPoint(x: frame.midX, y: frame.midY)

    }
    
    func getPropotionsAndPositions() {
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
        levelLabel.text = String(levelKey+1) // array index starts from 0 as always
        levelLabel.fontSize = 200.0
        levelLabel.scale(to: frame.size, width: true, multiplier: 0.05)
        levelLabel.position = CGPoint(x: levelLabelX, y: levelLabelY)
        levelLabel.fontColor = C.S.levelLabelFontColor
        
        levelLabel.zPosition = C.Z.panelZ
        addChild(levelLabel)
    }
    
    func addCompressor() {
        compressor = Compressor(with: playField.size, and: bubbleCellHeight*C.B.bubbleYModifier)
        compressor.position = CGPoint(x: frame.minX, y: physicsBoundsBottom+3+bubbleCellHeight*C.B.bubbleYModifier*12)
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
        return remainingBubbleColors[Int.random(in: 0..<remainingBubbleColors.count)]
    }
    
    func culateRemainingBubbleColors() {
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
    
    func addSwitchButton () {
        let switchButton = SpriteKitButton(buttonColor: UIColor.clear, buttonSize: CGSizeMake(bubbleCellWidth, launcherY-reserverBubbleY+bubbleCellHeight ),  action: switchLauncherBubbles, index: 0)
        switchButton.size = CGSizeMake(bubbleCellWidth*1.5, launcherY-reserverBubbleY+bubbleCellHeight )
        switchButton.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        switchButton.alpha = 0.5
        switchButton.position = CGPoint(x: launcherX, y: reserverBubbleY-bubbleCellHeight/2)
        switchButton.zPosition = C.Z.hudZ
        addChild(switchButton)
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
        if win {
            panel = SpriteKitButton(defaultButtonImage: C.S.winPanel, action: gotoScore, index: 0)
        } else {
            panel = SpriteKitButton(defaultButtonImage: C.S.losePanel, action: gotoGame, index: 0)
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
    

    func gotoMenu(_: Int) {
        sceneManagerDelegate?.presentMenuScene()
    }
    
    func gotoGame(_: Int) {
        sceneManagerDelegate?.presentGameScene()
    }
    
    func gotoScore(_: Int) {
        levelKey += 1
        PrefsHelper.setSinglePlayerLevel(to: levelKey)
        sceneManagerDelegate?.presentScoresScene()
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
                if unEven {
                    innerX = bubbleCellWidth*CGFloat(column)+bubbleCellWidth/2
                    innerY = bubbleCellHeight*C.B.bubbleYModifier*CGFloat(actRow)
                } else {
                    innerX = bubbleCellWidth*CGFloat(column)
                    innerY = bubbleCellHeight*C.B.bubbleYModifier*CGFloat(actRow)
                }
                gridCell.position = CGPoint(x: physicsBoundsLeft+innerX, y: physicsBoundsBottom+innerY+bubbleCellHeight/2)
                theGrid.append(gridCell)
            }
        }
    }

    
    func loadActualLevel() {
        // populate "theGrid" with actual level data
        var index = 0
        for row in 0...C.B.maxRows-1 {
            let actRow = C.B.maxRows - row - 1
            let unEven = actRow % 2 == 0
            let actMaxColumns = unEven ? C.B.maxColumns - 1 : C.B.maxColumns
            
            for _ in 0...actMaxColumns-1 {
                if index < level.count && (level[index] != C.B.emptyMarker) {
                    let bubble = Bubble(with: frame.size, as: level[index]+1)
                    PhysicsHelper.addPhysicsBody(to: bubble, with: C.S.bubbleName)
                    bubble.zPosition = C.Z.bubbleZ
                    bubble.scale(to: frame.size, width: true, multiplier: refBubbleScaler)
                    bubble.name = C.S.gridBubbleName
                    bubble.position = theGrid[index].position!
                    theGrid[index].bubble = bubble
                    addChild(bubble)
                }
                index += 1
            }
        }
        culateRemainingBubbleColors()
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
        if shotCounter > C.B.maxColumns-1 {
            pushCompressor()
        }
        autoshootTimer = 0
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
            if autoshootTimer > C.B.autoshootTriggerTime && autoshootWarningStage == 0 && gameState == .ready {
                autoshootWarningStage = 1
            }
            
            if autoshootWarningStage > 0 {
                if autoshootTimer > C.B.autoshootTriggerTime && autoshootWarningStage == 1 {
                    childNode(withName: C.S.hurryPanel)?.alpha = 1.0
                    if isSoundOn {
                        run(soundPlayer.hurrySound)
                    }
                    autoshootWarningStage += 1
                }
                if autoshootTimer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime && autoshootWarningStage == 2 {
                    fieldBlink()
                    autoshootWarningStage += 1
                }
                if autoshootTimer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*2.0 && autoshootWarningStage == 3 {
                    fieldBlink()
                    autoshootWarningStage += 1
                }
                if autoshootTimer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*3.0 && autoshootWarningStage == 4 {
                    fieldBlink()
                    autoshootWarningStage += 1
                }
                if autoshootTimer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*4.0 && autoshootWarningStage == 5 {
                    fieldBlink()
                    autoshootWarningStage += 1
                }
                if autoshootTimer > C.B.autoshootTriggerTime+C.B.autoshootDeltaTime*5.0  && autoshootWarningStage == 6 {
                    autoshootWarningStage = 0
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
                                 &&  (c.position.y <= gridCell.position!.y)/* don't dock on top of another bubble*/)
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
                                    if numberOfRemainingBubbles == 0 {
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
            autoshootTimer += dtCumulated
            autoshootHandler()
            dtCumulated=0
            handlePlayField()
        }
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

