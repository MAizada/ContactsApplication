import Foundation

struct Contact: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
}

struct ContactGroup {
    let title: String
    var contacts: [Contact]
}

