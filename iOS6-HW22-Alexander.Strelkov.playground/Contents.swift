import Foundation

var isAvailable = false

public struct Chip {
    public enum ChipType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let chipType: ChipType
    
    public static func make() -> Chip {
        guard let chipType = Chip.ChipType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        return Chip(chipType: chipType)
    }
    
    public func soldering() {
        let soderingTime = chipType.rawValue
        print("Soldering time: \(chipType.rawValue) seconds")
        sleep(UInt32(soderingTime))
    }
}

class Storage<Element> {
    
    var condition = NSCondition()
    
    var array = [Element]()
    
    init() {}
    
    func push(_ chip: Element) {
        condition.lock()
        array.append(chip)
        condition.unlock()
    }
    
    func pop() -> Element? {
        condition.lock()
        let lastElement = array.removeLast()
        condition.unlock()
        return lastElement
    }
    
    func peek() -> Element? {
        condition.lock()
        let lastElement = array.last
        condition.unlock()
        return lastElement
    }
    
    var isEmpty: Bool {
        condition.lock()
        let isEmpty = array.isEmpty
        condition.unlock()
        return isEmpty
    }
    
    var count: Int {
        condition.lock()
        let count = array.count
        condition.unlock()
        return count
    }
}

class ChipCreate: Thread {
    
    private var timer = Timer()
    private var count = Int()
    private var storage: Storage<Chip>
    
    init(storage: Storage<Chip>) {
        self.storage = storage
    }
    
    override func main() {
        createChip()
    }
    
    func createChip() {
        timer = Timer(timeInterval: 2, repeats: true) { [self] _ in
            let chip = Chip.make()
            storage.push(chip)
            print("Chip created at \(Date.now)")
            if let element = storage.peek() {
                print("Chip \(element.chipType) is added to storage") }
            isAvailable = true
            storage.condition.signal()
            storage.condition.unlock()
            count += 1
            if count == 10 {
                timer.invalidate()
            }
        }
        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run()
    }
}

class ChipSolder: Thread {
    
    private var storage: Storage<Chip>
    init(storage: Storage<Chip>) {
        self.storage = storage
    }
    
    override func main() {
        for _ in 1...10 {
            while (!isAvailable) {
                storage.condition.wait()
            }
            if let chip = storage.peek() {
                print("Taking \(chip.chipType) chip for soldering")
                storage.pop()?.soldering()
            }
            if storage.isEmpty {
                isAvailable = false
            }
            print("==SOLDERING FINISHED== at \(Date.now)")
        }
    }
}

var stack = Storage<Chip>()
let chipCreation = ChipCreate(storage: stack)
let chipSoldering = ChipSolder(storage: stack)
chipCreation.start()
chipSoldering.start()



