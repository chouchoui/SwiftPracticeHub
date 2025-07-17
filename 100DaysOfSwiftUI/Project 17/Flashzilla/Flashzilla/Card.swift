//
//  Created on 2025/07/17 11:14.
//

import Foundation

struct Card: Codable {
    var prompt: String
    var answer: String

    static let example = Card(prompt: "苹果公司的创始人之一是谁？", answer: "史蒂夫·乔布斯")
}
