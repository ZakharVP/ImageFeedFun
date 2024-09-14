//
//  ProfileViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 05.09.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profileView: UIImageView?
    private var fullNameView: UILabel?
    private var mailView: UILabel?
    private var textView: UILabel?
    
   override func viewDidLoad() {
       
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addProfileImageView()
        addButtonExitView()
        addFullNameView()
        addMailView()
        addTextView()
    }
    
    private func addProfileImageView() {
        
        guard let profileImage = UIImage(named: "profile_photo") else { return}
        let profileView = UIImageView(image: profileImage)
        profileView.tintColor = .gray
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)
        
        profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.profileView = profileView
        
    }
    
    private func addButtonExitView() {
        
        guard let exitIcon = UIImage(systemName: "ipad.and.arrow.forward"),
              let profileViewOne = self.profileView  else { return }
        
        let buttonExit = UIButton.systemButton(
            with: exitIcon,
            target: self,
            action: #selector(Self.didTapButton))
        
        buttonExit.tintColor = UIColor(named: "RedColorExitButton")
        buttonExit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonExit)
        
        buttonExit.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        buttonExit.centerYAnchor.constraint(equalTo: profileViewOne.centerYAnchor).isActive = true
        buttonExit.widthAnchor.constraint(equalToConstant: 44).isActive = true
        buttonExit.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    private func addFullNameView() {
        
        guard let profileView = self.profileView else { return }
        let fullNameView = UILabel()
        fullNameView.textColor = .white
        fullNameView.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        fullNameView.translatesAutoresizingMaskIntoConstraints = false
        fullNameView.text = "Екатерина Новикова"
        view.addSubview(fullNameView)
        
        fullNameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        fullNameView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 8).isActive = true
        
        self.fullNameView = fullNameView
        
    }
    
    private func addMailView() {
        
        guard let fullNameView = self.fullNameView else { return }
        let mailView = UILabel()
        mailView.textColor = UIColor(named: "GrayColorEmailName")
        mailView.translatesAutoresizingMaskIntoConstraints = false
        mailView.text = "@ekaterina_nov"
        view.addSubview(mailView)
        
        mailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        mailView.topAnchor.constraint(equalTo: fullNameView.bottomAnchor, constant: 8).isActive = true
        
        self.mailView = mailView
        
    }
    
    private func addTextView() {
        
        guard let mailView = self.mailView else { return }
        let textView = UILabel()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Hello, world"
        view.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        textView.topAnchor.constraint(equalTo: mailView.bottomAnchor, constant: 8).isActive = true
        
    }
    
    @objc
    private func didTapButton() {
        //TODO "Something"
    }
}
