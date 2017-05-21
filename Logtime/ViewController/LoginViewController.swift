//
//  LoginViewController.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 20/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.placeholder = "Username"
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("Login", for: .normal)
            loginButton.setTitleColor(.gray, for: .disabled)
        }
    }
    
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    var signedIn: ((User) -> Void)?
    
    convenience init(viewModel: LoginViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    func setupBindings() {
        userNameTextField.rx.text.orEmpty.bind(to: viewModel.username).addDisposableTo(disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).addDisposableTo(disposeBag)
        
        viewModel.isValid.map{ $0 }.bind(to: loginButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        loginButton.rx.tap.withLatestFrom(viewModel.isValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] _ -> Observable<AuthStatus> in
                return self.viewModel.authenticate(username: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "")
            }
            .subscribe(onNext: {authStatus in
                switch authStatus {
                case .success(_):
                    break
                case .faliure(let error):
                    print(error)
                    break
                }
            }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
}
