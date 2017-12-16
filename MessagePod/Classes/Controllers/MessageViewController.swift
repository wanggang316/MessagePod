//
//  MessageViewController.swift
//  MessageUI
//
//  Created by gang wang on 12/12/2017.
//

import UIKit

open class MessageViewController: UIViewController {

    // MARK: - UI Elements
    
    open var messagesTableView = MessageTableView()

    
    // MARK: - Properties
    open var messages: [Message]?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        self.messagesTableView.tableFooterView = UIView()
        
        self.view.addSubview(self.messagesTableView)
        
        self.messagesTableView.register(MessageTextCell.self, forCellReuseIdentifier: "cell")
        self.setupConstraints()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupConstraints() {
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = messagesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let bottom = messagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            let leading = messagesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = messagesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        } else {
            let leading = messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        }
        adjustScrollViewInset()
    }
    
    @objc
    private func adjustScrollViewInset() {
        if #available(iOS 11.0, *) {
            // No need to add to the top contentInset
        } else {
            let navigationBarInset = navigationController?.navigationBar.frame.height ?? 0
            let statusBarInset: CGFloat = UIApplication.shared.isStatusBarHidden ? 0 : 20
            let topInset = navigationBarInset + statusBarInset
            messagesTableView.contentInset.top = topInset
            messagesTableView.scrollIndicatorInsets.top = topInset
        }
    }
}

extension MessageViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTextCell
        if let messages = self.messages {
            cell.message = messages[indexPath.row]
        }
        return cell
    }
}

extension MessageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let messages = self.messages {
            let message = messages[indexPath.row]
            let atrributeString = NSMutableAttributedString.init(string: message.text)
            let range = NSRange(location: 0, length: message.text.count)
            atrributeString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 14), range: range)
            atrributeString.addAttribute(.link, value: UIFont.systemFont(ofSize: 14), range: range)

            let height = atrributeString.height(considering: 240 - 10)
//            let height = message.text.height(considering: 240 - 10, and: UIFont.systemFont(ofSize: 14))
            return height + 30
        }
        return 0
//
//        switch indexPath.row {
//        case 0: return 60
//        case 1: return 90
//        case 2: return 80
//        case 3: return 120
//        case 4: return 70
//        case 5: return 40
//        default:
//            return 60
//        }
    }
}
