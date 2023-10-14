
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allContactsGroup: [ContactGroup] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var contactManager = ContactManager()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return table
    }()
    
    private let segmentedControl: UISegmentedControl = {
        
        let items = ["First Name", "Last Name"]
        let segment = UISegmentedControl(items: items)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search Contact"
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        view.addSubview(segmentedControl)
        view.addSubview(searchBar)
        setupConstrains()
        navigationConfigure()
        segmentedControl.addTarget(self, action: #selector(reloadDataSource), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataSource()
    }
    
    func tableViewConfigure() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadDataSource), for: .valueChanged)
    }
    
    func navigationConfigure() {
        navigationItem.title = "Contacts"
        let addButton  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapCreate))
        addButton.tintColor = .black
        
        let premiumButton  = UIBarButtonItem(image: UIImage(systemName: "crown.fill"), style: .plain, target: self, action: #selector(didTapPremium))
        premiumButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItems = [addButton, premiumButton]
        
    }
    
    @objc private func didTapCreate() {
        let alert = UIAlertController(title: "Add contact", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in textField.placeholder = "First Name"
        }
        alert.addTextField { textField in textField.placeholder = "Last Name"
        }
        alert.addTextField { textField in textField.placeholder = "Phone Number"
        }
        
        let okButton = UIAlertAction(title: "Ok", style: .default)  { _ in
            guard let firstName = alert.textFields![0].text, !firstName.isEmpty else {
                self.showError(message: "First name is empty")
                return
            }
            
            guard let lastName = alert.textFields![1].text, !lastName.isEmpty else {
                self.showError(message: "Last name is empty")
                return
            }
            
            guard let phoneNumber = alert.textFields![2].text, !phoneNumber.isEmpty else {
                self.showError(message: "Phone number is empty")
                return
            }
            guard phoneNumber.isValidPhoneNumber() else {
                self.showError(message: "Invalid phone mumber")
                return
            }
            let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            self.add(contact: contact)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func add(contact: Contact) {
        contactManager.addContact(contact: contact)
        self.reloadDataSource()
    }
    
    @objc func reloadDataSource() {
        tableView.refreshControl!.beginRefreshing()
        
        var dictionary: [String: [Contact]] = [:]
        let allContacts = contactManager.getAllContacts()
        allContacts.forEach { contact in
            
            var key: String!
            if segmentedControl.selectedSegmentIndex == 0 {
                key = String(contact.firstName.first!)
            } else if segmentedControl.selectedSegmentIndex == 1 {
                key = String(contact.lastName.first!)
            }
            if var existingContacts = dictionary[key] {
                existingContacts.append(contact)
                dictionary[key] = existingContacts
            }else{
                dictionary[key] = [contact]
            }
        }
        
        var arrayOfcontactGroup: [ContactGroup] = []
        
        let alphabeticallyOrderedKeys: [String] = dictionary.keys.sorted { key1, key2 in
            return key1 < key2
        }
        alphabeticallyOrderedKeys.forEach { key in
            let contacts = dictionary[key]
            let contactGroup = ContactGroup(title: key, contacts: contacts!)
            arrayOfcontactGroup.append(contactGroup)
        }
        
        tableView.refreshControl!.endRefreshing()
        self.allContactsGroup = arrayOfcontactGroup
    }
    
    private func getContact(indexPath: IndexPath) -> Contact {
        let contactGroup = allContactsGroup[indexPath.section]
        let contact = contactGroup.contacts[indexPath.row]
        return contact
    }
    
    private func deleteContact(indexPath: IndexPath) {
        let deletedContact = allContactsGroup[indexPath.section].contacts.remove(at: indexPath.row)
        
        if allContactsGroup[indexPath.row].contacts.count < 1 {
            allContactsGroup.remove(at: indexPath.section)
        }
        contactManager.delete(contactToDelete: deletedContact)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @objc private func didTapPremium() {
        let vc = UINavigationController(rootViewController: PremiumViewController())
        vc.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
    
    private func setupConstrains() {
        let segmentedControlConsts = [
            segmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 70),
            segmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -70),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
        
        let searchBarConsts = [
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 10),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -10),
            searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: 10),
        ]
        let tableViewConsts = [
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5)
        ]
        NSLayoutConstraint.activate(segmentedControlConsts)
        NSLayoutConstraint.activate(searchBarConsts)
        NSLayoutConstraint.activate(tableViewConsts)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let contact = getContact(indexPath: indexPath)
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.fullNameLabel.text = "\(contact.firstName) \(contact.lastName)"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.fullNameLabel.text = "\(contact.lastName) \(contact.firstName)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContactsGroup[section].contacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allContactsGroup.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allContactsGroup[section].title
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.width / 8
    }
}

extension String {
    func isValidPhoneNumber() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
}
