import Foundation

public class ChipCreate: Thread {
    
    private var timer = Timer()
    private var count = Int()
    private var storage: Storage<Chip>
    
    public init(storage: Storage<Chip>) {
        self.storage = storage
    }
    
    public override func main() {
        createChip()
    }
    
    func createChip() {
        timer = Timer(timeInterval: 2, repeats: true) { [self] _ in
            let chip = Chip.make()
            storage.push(chip)
            print("Chip \(chip.chipType) created at \(NSDate.now)")
        }
        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run(until: NSDate.now + 20)
    }
}

