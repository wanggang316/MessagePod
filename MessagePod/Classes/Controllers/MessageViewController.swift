//
//  MessageViewController.swift
//  MessageUI
//
//  Created by gang wang on 12/12/2017.
//

import UIKit

class MessageViewController: UIViewController {

    // MARK: - UI Elements
    
    open var messagesTableView = MessageTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupConstraints()
        self.messagesTableView.dataSource = self
        self.messagesTableView.delegate = self
        self.view.addSubview(self.messagesTableView)
        
        self.messagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension MessageViewController: UITableViewDelegate {
    
}
