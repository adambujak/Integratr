class FunctionQueue {
    class Node {
        var function : () -> Void
        var next : Node? = nil
        init(function: @escaping () -> Void) {
            self.function = function
        }
    }
    var head: Node? = nil
    var tail: Node? = nil
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func peek() -> () -> Void {
        if !self.isEmpty(){
            return head!.function
        }
        else{
            return {}
        }
    }
    
    func add(function: @escaping () -> Void) {
        let node = Node(function: function)
        if tail != nil {
            tail!.next = node
        }
        tail = node
        
        if isEmpty() {
            head = node
        }
    }
    func remove() -> () -> Void {
        if isEmpty(){
            return {}
        }
        else {
            let function = head!.function
            head = head!.next
            if head == nil {
                tail = nil
            }
            return function
        }
    }
    func empty() {
        head = nil
        tail = nil
    }
}

