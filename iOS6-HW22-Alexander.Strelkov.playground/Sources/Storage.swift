import Foundation

public class Storage<Element> {
    
    private var condition = NSCondition()
    
    var array = [Element]()
    
    var isAvailable = false
    
    public init() {}
    
    public func push(_ chip: Element) {
        condition.lock()
        array.append(chip)
        isAvailable = true
        condition.unlock()
        condition.signal()
    }
    
    public func wait() {
        condition.lock()
            while !isAvailable {
                condition.wait()
            }
        condition.unlock()
    }
}
