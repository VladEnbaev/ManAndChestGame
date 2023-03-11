import Darwin
enum Movements{
    case left
    case right
    case up
    case down
}


enum Result{
    case ok
    case outOfRange
    case win
}

class Man {
    
    var face : String
    var position : (x: Int, y: Int)?

    init (face: String, positionX: Int, positionY: Int) {
        self.face = face
        if (1...Room.height).contains(positionY) && (1...Room.width).contains(positionX){
            self.position = (x: positionX, y: positionY)
        } else {
            self.position = nil
        }
    }
    
    func move(_ motion: Movements, andChest chest: Chest) -> (chestFlag: Result, manFlag: Result){
        var chestFlag : Result = .ok
        var manFlag : Result = .ok
        if position != nil{
            switch motion{
            case .down:
                position?.y -= 1
//                if chestFlag == false{
//                    position?.y += 1
//                }
            case .up:
                position?.y += 1
//                if chestFlag == false{
//                    position?.y -= 1
//                }
            case .right:
                position?.x += 1
//                if chestFlag == false{
//                    position?.x -= 1
//                }
            case .left:
                position?.x -= 1
//                if chestFlag == false{
//                    position?.x += 1
//                }
            }
        }
        chestFlag = chest.move(motion: motion, withMan: self)
        
        if chestFlag == .outOfRange{
            self.face = "😭"
        }
        
        if ((1...Room.height).contains(position!.y) && (1...Room.width).contains(position!.x)) == false{
            face = "💀"
            position = nil
            manFlag = .outOfRange
        }
        return (chestFlag: chestFlag, manFlag: manFlag)
    }
}



class Chest{
    
    var icon = "📦"
    
    var position : (x: Int, y: Int)? = (x: 1, y: 1) 
    
    init (positionX: Int, positionY: Int){
        if (2...Room.height-1).contains(positionY) && (2...Room.width-1).contains(positionX){
            self.position = (x: positionX, y: positionY)
            while (x: positionX, y: positionY) == Goal.position{
                self.position = (x: Int.random(in: 2...Room.width-1), y: Int.random(in: 2...Room.height-1))
            }
        } else {
            self.position = nil
        }
    }
    
    func move(motion: Movements, withMan man: Man) -> Result{
        
        if self.isNear(withMan: man){
            if position != nil{
                switch motion{
                case .down:
                    position?.y -= 1
                case .up:
                    position?.y += 1
                case .right:
                    position?.x += 1
                case .left:
                    position?.x -= 1
                }
            }
            if ((1...Room.height).contains(position!.y) && (1...Room.width).contains(position!.x)) == false{
                icon = "🔥"
                position = nil
                
                return .outOfRange
            }
        }
        if (position?.y == Goal.position.y) && (position?.x == Goal.position.x){
            Goal.icon = "🎁"
            position = nil
            
            return .win
            
        }
        return .ok
    }
    
    func isNear(withMan man: Man) -> Bool{
        if man.position != nil && position != nil{
            let xA = Double(man.position!.x)
            let yA = Double(man.position!.y)
            let xB = Double(position!.x)
            let yB = Double(position!.y)
            
            if sqrt(pow(xA - xB, 2) + pow(yA - yB, 2)) == 0{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

class Goal{
    static var position = (x: Int.random(in: 1...Room.width), y: Int.random(in: 1...Room.height))
    static var icon = "❌"
}

class Room {
    
    static var width  : Int = 6 // x
    static var height : Int = 6 // y
    var cellSymbol = "◽️"
    var previousPositionMan : (x: Int, y: Int)! // variable for save previous coordinates of Man. it's nil before setting value
    var previousPositionChest : (x: Int, y: Int)! // variable for save previous coordinates of Chest. it's nil before setting value
    var flag = true
    var drawing : [[String]] = Array(repeating: Array(repeating: "◽️", count: width), count: height)
    
    func updateRoom(man: Man, chest: Chest) -> Void{
//        let xChest = chest.position.x
//        let yChest = chest.position.y
        flag = true
        
        drawing = Array(repeating: Array(repeating: cellSymbol, count: Room.width), count: Room.height)
        drawing[Goal.position.y - 1][Goal.position.x - 1] = Goal.icon
        
        if let positionChest = chest.position{
            drawing[positionChest.y - 1][positionChest.x - 1] = chest.icon
            previousPositionChest = (x: positionChest.x - 1, y: positionChest.y - 1)
            
        } else {
            if previousPositionChest != nil{
                drawing[previousPositionChest.y][previousPositionChest.x] = chest.icon
            } else {
                flag = false
            }
        }
        
        if let positionMan = man.position{
            drawing[positionMan.y - 1][positionMan.x - 1] = man.face
            previousPositionMan = (x: positionMan.x - 1, y: positionMan.y - 1)
            
        } else {
            if previousPositionMan != nil{
                drawing[previousPositionMan.y][previousPositionMan.x] = man.face
            } else {
                flag = false
            }
        }
    }
    
    func isUpdated() -> Bool{
        return flag
    }
    
    
    func printRoom() -> Void {
        var line = ""
        let len = drawing.count
        
        for i in 0..<len{
            line += String(len - i)
            for j in 0..<drawing[len - i - 1].count {
                line += drawing[len - i - 1][j]
            }
            print(line)
            line = ""
        }
        
        line = " "
        for i in 0..<drawing[0].count {
            line += " \(i + 1)"
        }
        print(line)
    }
    
    func newWidth(_ widthNew: Int){
        Room.width = widthNew
    }
    
    func newHeight(_ heightNew: Int){
        Room.height = heightNew
    }
    func manWin() -> Void{
        self.cellSymbol = "🎁"
    }
    func manLost() -> Void{
        self.cellSymbol = "🔥"
    }
}


func NewGame(withChest chest: inout Chest, andMan man: Man) -> Void{
    Goal.position = (x: Int.random(in: 1...Room.width), y: Int.random(in: 1...Room.height))
    while man.position ?? (0, 0) == Goal.position{
        Goal.position = (x: Int.random(in: 1...Room.width), y: Int.random(in: 1...Room.height))
    }
    Goal.icon = "❌"
    var positionNew = (x: Int.random(in: 2...Room.width-1), y: Int.random(in: 2...Room.height-1))
    while positionNew == Goal.position || man.position ?? (0, 0) == positionNew{
        positionNew = (x: Int.random(in: 2...Room.width-1), y: Int.random(in: 2...Room.height-1))
    }
    chest.position = positionNew
}

func cleanConsole() -> Void{
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
}
