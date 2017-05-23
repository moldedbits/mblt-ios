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

class LoginViewController: UIViewController, ActivityIndicatorPresenter {
    
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
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

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
                self.viewModel.authenticate(username: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "")
                    .trackActivity(self.viewModel.activityIndicator)
                    .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] authenticationStatus in
                switch authenticationStatus {
                case .success(_):
                    break
                case .faliure(let error):
                    self.showError(error)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.activityIndicator
            .distinctUntilChanged()
            .drive(onNext: { [unowned self] active in
                self.view.endEditing(true)
                _ = active ? self.showActivityIndicator() : self.hideActivityIndicator()
                self.loginButton.isEnabled = !active
            })
            .addDisposableTo(disposeBag)
        
        viewModel.isUsernameValid
            .distinctUntilChanged()
            .map { $0.message }
            .bind(to: usernameErrorLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.isPasswordValid
            .distinctUntilChanged()
            .map { $0.message }
            .bind(to: passwordErrorLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    

}

extension UIViewController {
    func showError(_ error: AuthenticationError) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
