//: Create by Pedro Moter

import SpriteKit
import PlaygroundSupport
class Scene: SKScene, SKPhysicsContactDelegate{
    
    struct category{
        static let ground : UInt32 = 0x1<<0;
        static let ball : UInt32 = 0x1<<1;
           static let enemy : UInt32 = 0x1<<2;
    
    }

    func getRandomColor() -> UIColor{
        switch(Int(drand48()*10)){
        case 1: return UIColor.purple;
        case 2: return UIColor.blue;
        case 3: return UIColor.brown;
        case 4: return UIColor.cyan;
        case 5: return UIColor.yellow;
        case 6: return UIColor.blue;
        case 7: return UIColor.green;
        case 8: return UIColor.red;
        case 9: return UIColor.white;
        case 10: return UIColor.orange;
        default: return UIColor.purple;
        }

    }
    var CantGen = false;
    var deleted = 0.0;
    

    //define enemy and create
    func createEnemy(){
        if (CantGen) {return};
        let queue = DispatchQueue.global()
        queue.async {
        var enemy = SKSpriteNode(color: self.getRandomColor(), size: CGSize(width: 100, height: 500));
   
        enemy.name="enemy";
            
            //generate random dimensions
        enemy.size = CGSize(width: CGFloat((drand48()*1000)+100), height: CGFloat((drand48()*1000)+100));
            let eMov = SKAction.moveTo(x: -(enemy.size.width), duration: 3-(2.5*self.deleted)/100);
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size);
            enemy.physicsBody?.isDynamic = false;
        if(drand48() < 0.5){
            //spawn on bottom
            //generate random height
        
            enemy.position = CGPoint(x: 1500 + drand48()*100, y:Double(enemy.size.height+CGFloat(drand48()*100)));
        }else{
            //spawn on top
            enemy.position = CGPoint(x: 1500 + drand48()*100, y: Double(1920-enemy.size.height/2));
        }
        
        
        func completion() -> Void{
            let queue = DispatchQueue.global()
            queue.async {

            print("Delete completion")
            self.createEnemy();
            enemy.removeFromParent();
            }
        }
        
        enemy.run(eMov, completion: completion);
        
        self.addChild(enemy);
            //self.createEnemy();
    }
        
        
    }
    func reset(){
        self.CantGen = false;
        self.deleted = 0.0;
        enumerateChildNodes(withName: "*") { node, _ in
            node.removeFromParent();
        
    }
        let ball = SKSpriteNode(color: self.getRandomColor(), size: CGSize(width: 50, height: 50))
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody?.categoryBitMask = category.ball
        ball.physicsBody?.collisionBitMask = category.ground | category.enemy;
        ball.physicsBody?.contactTestBitMask = category.ground | category.enemy;
        ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        ball.position = CGPoint(x: (self.size.width/2)-200 , y: 1000)
        ball.name = "ball";
        self.addChild(ball)
        
     
        
        
        for _ in 1...5{
            createEnemy();
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            //print("Touch")
            let location = touch.location(in: self)
            let touchedNode = atPoint(location);
            if(self.CantGen == true){
                //reset the game
                self.reset();
                return;
            }
            if(touchedNode.name=="enemy"){
                let queue = DispatchQueue.global()
                self.deleted+=1;
                
                queue.async {
                    
                    //print("Delete completion")
                    self.createEnemy();
                    touchedNode.removeFromParent();
                    
                }
              
            }

        }
        }
    
    
    override func didMove(to view: SKView) {
        //configure background
        self.CantGen  = true;
        let title = SKLabelNode(fontNamed: "Chalkduster")
        title.text = "NodeRemove()"
        title.fontSize = 90
        title.fontColor = SKColor.white
        title.position = CGPoint(x: 540, y: 1000)
        title.name = "title"
        self.addChild(title)
        let desc = SKLabelNode(fontNamed: "Chalkduster")
        desc.text = "Click the blocks and save the square!"
        desc.fontSize = 50
        desc.fontColor = SKColor.white
        desc.position = CGPoint(x: 540, y: 800)
        desc.name = "desc"
        self.addChild(desc)
        let st = SKLabelNode(fontNamed: "Chalkduster")
        st.text = "Click anywhere to start!"
        st.fontSize = 50
        st.fontColor = SKColor.green
        st.position = CGPoint(x: 540, y: 600)
        st.name = "st"
        self.addChild(st)
        //show Explanation
        
        let tks = SKLabelNode(fontNamed: "Chalkduster")
        tks.text = "Thanks for playing. Made by Pedro Moter"
        tks.fontSize = 40
        tks.fontColor = SKColor.white
        tks.position = CGPoint(x: 540,y: 400)
        tks.name = "tks"
        self.addChild(tks)
        
        self.size = CGSize(width:1080, height: 1920 );
        self.backgroundColor = UIColor.white;
        self.physicsWorld.contactDelegate = self;
      self.backgroundColor = UIColor.black;
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -100)
        let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
      
        
        sceneBound.friction = 0
        sceneBound.restitution = 1
        self.physicsBody = sceneBound

        //define enemy
        
       
        
      
        
        let ball = SKSpriteNode(color: self.getRandomColor(), size: CGSize(width: 50, height: 50))
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody!.allowsRotation = false
     ball.physicsBody?.categoryBitMask = category.ball
        ball.physicsBody?.collisionBitMask = category.ground | category.enemy;
        ball.physicsBody?.contactTestBitMask = category.ground | category.enemy;
       ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        ball.position = CGPoint(x: (self.size.width/2)-200 , y: 1000)
        ball.name = "ball";
        self.addChild(ball)
    
        for _ in 1...5{
            createEnemy();
        }

        
    }
    
    
    func die(){

        enumerateChildNodes(withName: "ball") { node, _ in
            node.removeFromParent();
        }
        self.CantGen  = true;
        let lose = SKLabelNode(fontNamed: "Chalkduster")
        lose.text = "You Lose!"
        lose.fontSize = 99
        lose.fontColor = SKColor.red
        lose.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        lose.name = "lose"
        self.addChild(lose)
        
        let retry = SKLabelNode(fontNamed: "Chalkduster")
        retry.text = "Click anywhere to retry."
        retry.fontSize = 65
        retry.fontColor = SKColor.blue
        retry.position = CGPoint(x: self.frame.midX, y: self.frame.midY-500)
        retry.name = "retry"
        self.addChild(retry)
        
        let tks = SKLabelNode(fontNamed: "Chalkduster")
        tks.text = "Thanks for playing. Made by Pedro Moter"
        tks.fontSize = 40
        tks.fontColor = SKColor.white
        tks.position = CGPoint(x: self.frame.midX, y: self.frame.midY-700)
        tks.name = "tks"
        self.addChild(tks)
        
        let counter = SKLabelNode(fontNamed: "Chalkduster")
        counter.text = "Your Score: "+String(Int(self.deleted));
        counter.fontSize = 65
        counter.fontColor = SKColor.green
        counter.position = CGPoint(x: self.frame.midX, y: self.frame.midY+200);
        counter.name = "counter"
        self.addChild(counter)
   
        }
            
    
        

    func didBegin(_ contact: SKPhysicsContact) {
        let b1 = contact.bodyA.node
        let b2 = contact.bodyB.node
    
        if(b1?.name == "enemy" || b2?.name == "enemy" ){
        //print("Colission");
            die();
        }
    }
    

}


let scene = Scene();
scene.scaleMode = .aspectFit;
print("Begin");




let view =  SKView(frame: CGRect(x:0,y:0,width:960,height:540));
view.showsFPS = true;


view.presentScene(scene);
PlaygroundPage.current.liveView = view;
