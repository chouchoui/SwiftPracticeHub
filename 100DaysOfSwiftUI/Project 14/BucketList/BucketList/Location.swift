//
//  Created on 2025/07/16 10:51.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // 示例数据 for预览：池袋
    static let example = Location(
        id: UUID(),
        name: "池袋",
        description: "池袋是东京的一个繁华商业区，以购物、娱乐和美食闻名。",
        latitude: 35.7295,
        longitude: 139.7100
    )

    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
