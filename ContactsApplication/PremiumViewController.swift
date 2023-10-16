import UIKit

class PremiumViewController: UIViewController {
    
    let subscribeButton = UIButton()
    let restoreButton = UIButton()
    let clearButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        let premiumLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 400))
        premiumLabel.text = "Premium"
        premiumLabel.textAlignment = .center
        premiumLabel.textColor = .black
        premiumLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.view.addSubview(premiumLabel)
        
        let textLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 500))
        textLabel.text = "Upgrade to premium and get a lot of features..."
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        self.view.addSubview(textLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 700))
        priceLabel.text = "3.99$"
        priceLabel.textAlignment = .center
        priceLabel.textColor = .white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.view.addSubview(priceLabel)
        priceLabel.attributedText = strikeText(strike: "3.99$")
        
        let newPriceLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 750))
        newPriceLabel.text = "1.99$"
        newPriceLabel.textAlignment = .center
        newPriceLabel.textColor = .white
        newPriceLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.view.addSubview(newPriceLabel)
        
        let bottomTextLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 350, height: 1400))
        bottomTextLabel.text = "This is auto-renewable Subscription. It will be changed to your iTunes account before each pay period. You can cancel anytime by going into your Settings > Subscriptions. Restore perchases if previously subscribed."
        bottomTextLabel.numberOfLines = 5
        bottomTextLabel.textAlignment = .center
        bottomTextLabel.textColor = .white
        bottomTextLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        self.view.addSubview(bottomTextLabel)
        
        let subscribeButtonFrame = CGRect(x: 50, y: 650, width: 300, height: 40)
        subscribeButton.frame = subscribeButtonFrame
        subscribeButton.backgroundColor = .systemTeal
        subscribeButton.layer.cornerRadius = 10
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.addTarget(self, action: #selector(tap), for: .touchDown)
        self.view.addSubview(subscribeButton)
        
        let restoreButtonFrame = CGRect(x: 50, y: 700, width: 300, height: 40)
        restoreButton.frame = restoreButtonFrame
        restoreButton.backgroundColor = .systemFill
        restoreButton.layer.cornerRadius = 10
        restoreButton.setTitle("Restore", for: .normal)
        restoreButton.addTarget(self, action: #selector(tap), for: .touchDown)
        self.view.addSubview(restoreButton)
        
        let clearButton  = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCreate))
        clearButton.tintColor = .black
        navigationItem.rightBarButtonItems = [clearButton]
        
    }
    

    @objc private func didTapCreate() {
        dismiss(animated: true, completion: nil)

    }
    
    @objc func tap (sender: UIButton) {
        print("button pressed")
    }
    
    func strikeText(strike: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: strike)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

