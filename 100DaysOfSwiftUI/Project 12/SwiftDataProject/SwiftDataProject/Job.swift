import Foundation
import SwiftData

@Model
class Job {
    var name: String = ""
    var priority: Int = 0
    var owner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
