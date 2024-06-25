//
//  GameViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 19.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import GLKit
import OpenGLES
import CoreMotion



func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer {
    return UnsafeRawPointer(bitPattern: i)!
}

class ExpressViewController: GLKViewController , GLKViewControllerDelegate{
    
    var scene:Scene? = nil

    var motionManager : CMMotionManager?
    
    var waitForClick: Bool = false
    
    var level:Int = 0
    var lives:Int = 0
    var extraTimeRatio = 1.0
    var playstate:EPlayState = EPlayState.PLAYSTATE_PLAYING
    
    var lastTime:Float = 0.0
    var lastPosition:Float = 0.0
    
    
    var lastGravityX:Double = 0.0
    var lastGravityY:Double = 0.0
    var lastGravityZ:Double = 0.0
    var ax:Double = 0.0
    var ay:Double = 0.0
    var az:Double = -1.0
    var down:Bool = false
    var left:Bool = false
    var right:Bool = false
    var jump:Bool = false
    var tapJump = false
    var waitphase:Int = 0
    var lastTol:UInt = 0
    var lastabs:Double = 0.0
    var context: EAGLContext? = nil
    var xscale: GLfloat = 1
    var yscale: GLfloat = 1
    var viewPort: CGRect = UIScreen.main.bounds
    var locationTouch = CGPoint(x: 0, y: 0)
    var locationActive = false
    
    
    func setup(ilevel:Int, ilives:Int, iTimeRatio:Double){
        
        level = ilevel
        lives = ilives
        extraTimeRatio = iTimeRatio
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        let logScreenSize: CGRect = UIScreen.main.bounds
        let screenScale: Double = Double(UIScreen.main.scale)
        let screenSize: CGRect = CGRect(x: logScreenSize.origin.x , y:logScreenSize.origin.y, width:logScreenSize.size.width * CGFloat(screenScale), height: logScreenSize.size.height * CGFloat(screenScale))
        let yRatio = Double ( screenSize.height ) / SCREEN_HEIGHT
        xscale = GLfloat(yRatio  / screenScale )
        yscale = GLfloat(yRatio  / screenScale )
        viewPort = screenSize
        SCREEN_WIDTH = SCREEN_HEIGHT * Double( screenSize.width ) / Double ( screenSize.height )
    }
 
    
    deinit {
        self.tearDownGL()
        
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES1)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        self.setupGL()
        

        let gr:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( ExpressViewController.onJumpTap ) )
        gr.numberOfTapsRequired = 1
        self.view.addGestureRecognizer( gr)
            
        let gr2:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector( ExpressViewController.onCancelTap ) )
        gr2.minimumPressDuration = 5
        self.view.addGestureRecognizer( gr2 )
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.preferredFramesPerSecond = Int ( FRAME_RATE )
        motionManager = CMMotionManager()
        motionManager?.accelerometerUpdateInterval = 1.0 / FRAME_RATE
        motionManager?.startAccelerometerUpdates()
        
        
        setupTextures()
        
        scene = Scene(level: level, lives: lives,extraTimeRatio: extraTimeRatio)
        
        waitForClick = false
        lastGravityX = 0.0
        lastGravityY = 0.0
        lastGravityZ = -1.0
        ax = 0.0
        ay = 0.0
        az = -1.0
        down = false
        left = false
        right = false
        jump = false
        tapJump = false
        waitphase = 0
        lastTol = 0
        lastabs = 1.0
        playstate = EPlayState.PLAYSTATE_PLAYING
        
        self.delegate = self
        
        scene?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        
        tearDowntextures()
        
        motionManager?.stopAccelerometerUpdates()
        motionManager = nil
        
        self.delegate = nil
    }
    
    func setupGL() {
        EAGLContext.setCurrent(self.context)
    }
    
    func tearDownGL() {
        EAGLContext.setCurrent(self.context)
        
    }
    
    func setupTextures() {
        
        glEnable(GLenum(GL_BLEND));
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glEnable(GLenum(GL_TEXTURE_2D));
        
    }
    
    func tearDowntextures() {
    
        glDisable(GLenum(GL_BLEND));
        glDisable(GLenum(GL_TEXTURE_2D));
    }
    
    func updateWithMotionManager() {
        
        //look at documentation chapter 3.1
        let ax2 = ax*ax
        let ay2 = ay*ay
        let az2 = az*az
        // absolute value of motion vector. 1 means no movement (one G)
        let abs = sqrt(ax2+ay2+az2);
        // history of last four values. bit=1, acceleration up or down
        lastTol &= 0xF
        
        if( abs<ACM_JUMP_TRESHOLD && abs>(2.0-ACM_JUMP_TRESHOLD) )
        {
            lastTol<<=1
            if ( !jump ) {
                
                let tanangle = tan(Double.pi/2.0-ACM_RECOGNIZING_ANGLE)
                //look at documation chapter 3.2
                down = (az < 0.0 && -az*tan(ACM_TOLERANCE_ANGLE) > sqrt(ax2+ay2))
                left = (ay < 0.0 && -ay*tanangle > sqrt(ax2+az2))
                right = (ay > 0.0 && ay*tanangle > sqrt(ax2+az2))
            }
            else {
                if ( waitphase==1 ) {
                    waitphase=2
                }
                else if ( waitphase==3 ) {
                    if ( jump ) {
                        
                        jump = ( abs - lastabs ) > 0.1 || ( abs - lastabs ) < -0.1
                        waitphase = jump ? waitphase : 0
                    }
                    else {
                        waitphase = 0
                    }
                }
            }
            if (lastTol==0) {
                jump = false
                waitphase=0
            }
            
        }
        else {
            lastTol<<=1
            lastTol+=1
            if ( waitphase==0 && !jump && abs>ACM_JUMP_TRESHOLD*1.2 ) {
            
                jump = ( abs - lastabs ) > 0.25
                waitphase = 1
            }
            else if ( waitphase==0 && !jump && abs<(2.0-ACM_JUMP_TRESHOLD*1.2) ) {
                
                jump = false
                waitphase = 1
            }
            else  if ( waitphase==2 && abs>ACM_JUMP_TRESHOLD ) {
                
                waitphase = 3
            }
            
        }

        
        lastGravityX=ax
        lastGravityY=ay
        lastGravityZ=az
        lastabs = abs
        
        
        
        if(left && right) {
            print("Accelerometer left and right")
            left=false
            right=false;
        }
        if(jump && down) {
            jump=false
            waitphase = 0
        }
        
        //if (level == 1) {
            jump = tapJump || jump
            tapJump = false
        //}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            let touch : UITouch! =  touches.first! as UITouch

            locationTouch = touch.location(in: self.view)

            locationActive = true
        }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch : UITouch! =  touches.first! as UITouch

        locationTouch = touch.location(in: self.view)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if touches.count == 0 {
            locationActive = false
            
        //}
        
    }
    
    func updateWithTouches() {
        
        
        if( playstate != EPlayState.PLAYSTATE_PLAYING)
        {
            for gr in self.view.gestureRecognizers! {
                gr.isEnabled = true
            }
        }
        else {
            for gr in self.view.gestureRecognizers! {
                gr.isEnabled = false
            }
        }
        
        if locationActive {
            
            if (locationTouch.x / self.view.frame.size.width)  < 0.3 {
                left = true
            }
            else {
                left = false
            }
            if (locationTouch.x / self.view.frame.size.width)  > 0.7 {
                right = true
            }
            else {
                right = false
            }
            if (locationTouch.y / self.view.frame.size.height)  < 0.5 {
                jump = true
                down = false
            }
            else {
                jump = false
                if !left && !right {
                    down = true
                }
            }
                
        }
        else {
            down = false
            jump = false
            left = false
            right = false
        }
        
    }
   
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        
        
        if ( motionManager == nil ) {
        
            return
        }
        let ad:CMAccelerometerData? = motionManager?.accelerometerData
        
        
        if (ad != nil) {
            
            
            ax = motionManager!.accelerometerData!.acceleration.x
            ay = motionManager!.accelerometerData!.acceleration.y
            az = motionManager!.accelerometerData!.acceleration.z
            
            if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft) {
                ax = -ax
                ay = -ay
            }
            
            updateWithMotionManager()
        }
        else {
            updateWithTouches()
        }
        
        
        
        playstate = (scene?.update(left: left, right: right, down: down, jump: jump))!
        
        
        if( playstate != EPlayState.PLAYSTATE_PLAYING)
        {
            if( waitForClick == false)
            {
                let gr:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( ExpressViewController.onFinishTap ) )
                self.view.addGestureRecognizer( gr)
                motionManager?.stopAccelerometerUpdates()
                waitForClick = true
            }
        }
 
    }
    
    @objc func onFinishTap() {
        
        print("GAME OVER")
        if((self.presentingViewController) != nil){
            let parent: StartViewController = self.presentingViewController as! StartViewController
            self.dismiss(animated: true, completion:
                {
                    parent.onExpressExit(points: (self.scene?.getPoints())!, win: self.playstate == EPlayState.PLAYSTATE_WIN )
                })

        }
    }
    
    @objc func onCancelTap() {
        
        print("GAME OVER")
        if((self.presentingViewController) != nil){
            let parent: StartViewController = self.presentingViewController as! StartViewController
            self.dismiss(animated: true, completion:
                {
                    parent.onExpressExit(points: (self.scene?.getPoints())!, win: self.playstate == EPlayState.PLAYSTATE_LOSE )
            })
            
        }
    }
    
    @objc func onJumpTap() {
        
        tapJump = true
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        glMatrixMode(GLenum(GL_MODELVIEW))                // zacatek modifikace projekcni matice
        glLoadIdentity()                                  // vymazani projekcni matice (=identita)
        glOrthof(0, GLfloat(screenSize.width) , 0, GLfloat(screenSize.height), -1, 1)
        
        glPushMatrix()
        glClearColor(0.502, 0.702, 1.0, 1)                // nastaveni mazaci barvy
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))          // vymazani bitovych rovin barvoveho bufferu
    
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
    
        glViewport(GLint( viewPort.origin.x ) , GLint( viewPort.origin.y ), GLsizei( viewPort.size.width ), GLsizei( viewPort.size.height ))
        glScalef( xscale   , yscale   , 1.0 )
        scene?.draw()
        glPopMatrix()
        glFlush()
    }
    
}
