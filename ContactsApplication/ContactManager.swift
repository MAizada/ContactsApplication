
import Foundation

struct ContactManager {
    
    let allContactsKey: String = "allContactsKey"
    let userDefaults = UserDefaults.standard
    
    func getAllContacts() -> [Contact] {
        var allContacts: [Contact] = []
        if let data = userDefaults.object(forKey: allContactsKey) as? Data {
            do {
                let decoder = JSONDecoder()
                allContacts = try decoder.decode([Contact].self, from: data)
            } catch {
                print("Ecould'n decode given data to [Contact] with error:\(error.localizedDescription)")
            }
        }
        return allContacts
    }
    
    func addContact(contact: Contact) {
        var allContacts = getAllContacts()
        allContacts.append(contact)
        save(allContacts: allContacts)
    }
  
    func edit(contactToEdit: Contact, editedContact: Contact) {
        var allContacts = getAllContacts()
        
        for index in 0..<allContacts.count {
   
            let contact = allContacts[index]
            
            if contact.firstName == contactToEdit.firstName && contact.lastName == contactToEdit.lastName && contact.phoneNumber == contactToEdit.phoneNumber {
                allContacts.remove(at: index)
                allContacts.insert(contact, at: index)
                break
            }
        }
        save(allContacts: allContacts)
    }

    func delete(contactToDelete: Contact) {
        var allContacts = getAllContacts()
        
        for index in 0..<allContacts.count {
            let contact = allContacts[index]
            
            if contact.firstName == contactToDelete.firstName && contact.lastName == contactToDelete.lastName && contact.phoneNumber == contactToDelete.phoneNumber {
                allContacts.remove(at: index)
                break
            }
        }
        save(allContacts: allContacts)
    }
    
    func save(allContacts: [Contact]) {
        do {
            let encoded = JSONEncoder()
            let encodedData = try encoded.encode(allContacts)
            userDefaults.set(encodedData, forKey: allContactsKey)
            
        } catch {
            print("Couldn't encode given [Userscore] into data with error: \(error.localizedDescription)")
        }
    }
}
