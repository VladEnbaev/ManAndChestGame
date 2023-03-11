import Darwin

var Room1 = Room()
var Man1 = Man(face: "?", positionX: 0, positionY: 0)
var Chest1 = Chest(positionX: Int.random(in: 2...Room.width - 1), positionY: Int.random(in: 2...Room.height - 1))

var presentsCount = 0
let maxPresentsCount = 7
var errorMessage = ""
var newGameMessage = ""
var flagChooseCoordinates = true
var flagMainGame = false
var flagNewGame = true
var face = ""

while true{
    print("choose man's face: 1.😡, 2.🤓, 3.😎, 4.🥸, 5.🙂, 6😈")
    print("enter number of face")
    let faceDict = [1: "😡", 2: "🤓", 3: "😎", 4: "🥸" , 5: "🙂", 6: "😈"]
    let faceNumber = readLine()
    if let faceNum = Int(faceNumber!){
        if let symbol = faceDict[faceNum]{
            face = symbol
            break
        } else {
            print("not such number in list")
        }
    } else {
        print("enter integer number")
    }
}


while flagChooseCoordinates{
    print("enter man's start X coordinates:")
    let startX = readLine()

    print("enter man's start Y coordinates:")
    let startY = readLine()

    if let x = Int(startX!), let y = Int(startY!){
        Man1 = Man(face: face, positionX: x, positionY: y)
        while (x == Chest1.position?.x && y == Chest1.position?.y){
            Chest1.position = (x: Int.random(in: 2...Room.width - 1), y: Int.random(in: 2...Room.height - 1))
        }
        while (x == Goal.position.x && y == Goal.position.y){
            Goal.position = (x: Int.random(in: 1...Room.width), y: Int.random(in: 1...Room.height))
        }
        
        Room1.updateRoom(man: Man1, chest: Chest1)
        if Room1.isUpdated(){
            flagChooseCoordinates = false
            break
        } else {
            print("enter correct coordinates")
        }
    } else {
        print("enter integer value")
    }
}

cleanConsole()
print("")
print("Move the box(📦) to the cross(❌) and get a present(🎁)")
print("You need to collect \(maxPresentsCount) presents")
print("")
print("enter 'end' if you want to end the game")
print("")
print("Enter 'ok' if you understand the rules")
while true{
    if readLine()! == "ok"{
        flagMainGame = true
        break
    } else {
        print("Enter 'ok'")
    }
}


while flagMainGame{
    
    cleanConsole()
    print("🎁x\(presentsCount)/\(maxPresentsCount)")
    Room1.printRoom()
    print(errorMessage)
    if !newGameMessage.isEmpty{
        print(newGameMessage)
        newGameMessage = ""
    } else {
        print("where do you want to go?")
        print("WASD 'w' - up, 'a' - left, 's' - down, 'd' - right. Enter letter.")
    }
    
    let stringMove = readLine()
    var move : Movements? = nil
    
    switch stringMove! {
    case "w" :
        move = .up
    case "a":
        move = .left
    case "s":
        move = .down
    case "d":
        move = .right
    case "":
        break
    case "end":
        flagMainGame = false
        break
    default: print("not such movement")
    }
    if move != nil{
        let check = Man1.move(move!, andChest: Chest1)
        if check.manFlag == .outOfRange{
            cleanConsole()
            print("🎁x\(presentsCount)/\(maxPresentsCount)")
            flagNewGame = false
            flagMainGame = false
            Room1.manLost()
            Room1.updateRoom(man: Man1, chest: Chest1)
            Room1.printRoom()
            print("You dead(")
            break
            
        }
        if check.chestFlag == .win{
            flagNewGame = false
            presentsCount += 1
//            print("🎁x\(presentsCount)")
            if presentsCount == maxPresentsCount{
                cleanConsole()
                Room1.manWin()
                Room1.updateRoom(man: Man1, chest: Chest1)
                Room1.printRoom()
                print("you collected \(maxPresentsCount) gifts you won!!!!🥳🥳🥳🥳🥳🥳🥳")
                flagMainGame = false
                break
            }
            Room1.updateRoom(man: Man1, chest: Chest1)
        } else if check.chestFlag == .outOfRange{
            errorMessage = "Your box is on fire. You have one way out - suicide"
        }
    }
    if flagNewGame{
        Room1.updateRoom(man: Man1, chest: Chest1)
    } else {
        newGameMessage = "Press Enter"
        NewGame(withChest: &Chest1, andMan: Man1)
        flagNewGame = true
    }
    
}


