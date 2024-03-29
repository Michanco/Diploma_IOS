//
//  GameScene.swift
//  SuperMegaGame
//
//  Created by Michanco Slesarev on 21.03.2024.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!                               //создаём переменную отвечающую за анимацию на фоне
    var player:SKSpriteNode!                                    //создаём переменную отвечающую за корабль игрока
    var scoreLable: SKLabelNode!                                // создаём переменную для поля со счётом
    var score: Int = 0 {                                        // создаём переменную для хранения счёта
        didSet{
            scoreLable.text = " Score: \(score)"                // Прописываем отображение изменения счёта
        }
    }
    var gameTimer: Timer!                                       // создаём переменную отвечающую за интервал появления врагов
    var aliens = ["alien", "alien2", "alien3"]                  // создаём массив с именами изображений врагов
    
    let alienCategory:UInt32 = 0x1 << 1                         // создаём уникальные идентификаторы
    let bulletCategory:UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAccelerate: CGFloat = 0
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "Starfield")       //кладём в переменную анимацию фона
        starfield.position = CGPoint(x: 0, y: 1472)             // указываем координаты положения фона на экране
        starfield.advanceSimulationTime(10)                     // задаём сколько секунд с начала анимации пропустить
        self.addChild(starfield)                                // добавляем анимацию фона на экран
        
        starfield.zPosition = -1                                // задаём позицию фона по оси Z, отодвигаем фон на задний план
        
        player = SKSpriteNode(imageNamed: "shuttle")            //кладём в переменную изображения корабля игрока
        player.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 40)                //задаём позицию начального положения игрока
        //player.setScale(1.5)
        
        self.addChild(player)                                   // добавляем игрока на экран
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)      // задаём отсутствие гравитации
        self.physicsWorld.contactDelegate = self                // добавляем отслеживание взаимодействия между объектами
        
        scoreLable = SKLabelNode (text: " Score: 0")                                        // задаём начальное значение поля со счётом
        scoreLable.fontName = "AmericanTypewriter-Bold"                                     // задаём параметры текста
        scoreLable.fontSize = 36
        scoreLable.fontColor = UIColor.white
        scoreLable.position = CGPoint(x: self.frame.midX - 100, y: self.frame.maxY  - 100)  // задаём положение на экране
        
        self.addChild(scoreLable)                                                           //добавляем поле со счётом на экран
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)                                                             //инициализируем переменную
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!)                        // получаем данные от акселлерометра
        { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data {
                let acceleration = accelerometrData.acceleration
                self.xAccelerate =  CGFloat(acceleration.x) * 0.75 + self.xAccelerate * 0.25
            }
            
        }
        
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAccelerate * 50                //изменяем положение игрока на значение полученное от акселерометра
        
        if player.position.x < 0 - player.size.width / 2 {
            player.position.x = UIScreen.main.bounds.width + player.size.width / 2
        } else if player.position.x > UIScreen.main.bounds.width + player.size.width / 2{
            player.position.x = 0 - player.size.width
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var alienBody:SKPhysicsBody
        var bulletBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {                  // проверяем который из объектов враг а который выстрел
            bulletBody = contact.bodyA
            alienBody = contact.bodyB
        } else {
            bulletBody = contact.bodyB
            alienBody = contact.bodyA
        }
        
        if (alienBody.categoryBitMask & alienCategory) != 0 && (bulletBody.categoryBitMask & bulletCategory) != 0 {        // проверяем что соприкасаются именно объекты враг и выстрел
            collisionElements(bulletNode: bulletBody.node as! SKSpriteNode, alienNode: alienBody.node as! SKSpriteNode)
        }
        
        func collisionElements (bulletNode: SKSpriteNode, alienNode: SKSpriteNode){
            let explosion = SKEmitterNode(fileNamed: "Vzriv")   // кладём в переменную анимацию взрыва
            explosion?.position = alienNode.position            // задаём позицию
            self.addChild(explosion!)                           // длбавляем взрыв на сцену
            
            self.run(SKAction.playSoundFileNamed("vzriv", waitForCompletion: false))   // проигрываем звук взрыва
            
            bulletNode.removeFromParent()        // удаляем со сцены объект выстрел
            alienNode.removeFromParent()         // удаляем со сцены объект враг
            
            self.run(SKAction.wait(forDuration: 2)) {   //удаляем со сцены анимацию с задержкой 2 сек
                explosion?.removeFromParent()
            }
            
            score += 1
            
        }
    }
    
    
    
    @objc func addAlien(){                                       // описываем функцию создания врага
        aliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: aliens) as! [String]             // задаём случайный порядок элементов в массиве
        let alien = SKSpriteNode(imageNamed:  aliens[0])                                                    // создаём врага, передаём случайное имя изображения
        let randomPos = GKRandomDistribution(lowestValue: Int(0 + alien.size.width * 2),
                                             highestValue: Int(UIScreen.main.bounds.width - alien.size.width * 2))     // задаём интервал для рандома
        let pos = CGFloat(randomPos.nextInt())                                                              // создаём рандом для X позиции врага
        alien.position = CGPoint (x: pos, y: UIScreen.main.bounds.height + alien.size.height)                           // задаём координаты появления врага
        //alien.setScale(1.5 )
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)                                          //задаём границы взаимодействия с объектом врага
        alien.physicsBody?.isDynamic = true                                                                 //задаём возможность взаимодействия
        alien.physicsBody?.categoryBitMask = alienCategory                                                  // прописываем параметры проверки взаимодействий
        alien.physicsBody?.contactTestBitMask = bulletCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)                                                                                                    //добавляем врага на сцену
        
        let animDuration:TimeInterval = 6                                                                                       // задаём скорость движения врагов
        
        var actions = [SKAction]()                                                                                              // задаём массив активностей
        actions.append(SKAction.move(to: CGPoint(x: pos, y: 0 - alien.size.height),
                                     duration: animDuration))                                                                   // задаём параметры движения врага
        actions.append(SKAction.removeFromParent())                                                                             // задаём удаление врага при выходе за пределы экрана
        
        alien.run(SKAction.sequence(actions))                                                                                   // запускаем активности у объекта
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {    // задаём выстрел по нажатию на экране
        fireBullet()
    }
    
    func fireBullet(){
        self.run(SKAction.playSoundFileNamed("bullet", waitForCompletion: false )) //  проигрывем звук выстрела
        let bullet = SKSpriteNode(imageNamed: "torpedo")
        bullet.position = player.position
        bullet.position.y += player.size.height/2
        //bullet.setScale(2)

        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)           //задаём границы взаимодействия объекта выстрел
        bullet.physicsBody?.isDynamic = true                                                //задаём возможность взаимодействия
        bullet.physicsBody?.categoryBitMask = bulletCategory                                // прописываем параметры проверки взаимодействий
        bullet.physicsBody?.contactTestBitMask = alienCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)                                                                                           //добавляем выстрел на экран
        let animDuration:TimeInterval = 1                                                                               // задаём скорость движения врагов
        var actions = [SKAction]()                                                                                      // задаём "набор" активности
        actions.append(SKAction.move(to: CGPoint(x: player.position.x,
                                                 y: UIScreen.main.bounds.size.height + bullet.size.height), duration: animDuration))                               //задаём параметр движения выстрела
        actions.append(SKAction.removeFromParent())                                                                     // задаём удаление выстрела при прохождении экрана
        
        bullet.run(SKAction.sequence(actions))
        
      
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
