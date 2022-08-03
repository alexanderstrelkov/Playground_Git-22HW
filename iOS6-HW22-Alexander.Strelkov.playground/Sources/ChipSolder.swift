import Foundation

public class ChipSolder: Thread {
    
    private var storage: Storage<Chip>
    public init(storage: Storage<Chip>) {
        self.storage = storage
    }
    
    public override func main() {
        for _ in 1...10 {
            storage.wait()
            storage.array.removeLast().soldering() // мы же должны удалить элемент из массива? а не просто уснуть через .soldering() ?
            if storage.array.isEmpty {
                storage.isAvailable = false
            }
            print("==Solder finish== at \(NSDate.now)")
        }
    }
}
