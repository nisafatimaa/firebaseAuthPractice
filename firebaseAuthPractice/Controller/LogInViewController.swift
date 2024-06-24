//
//  LogInViewController.swift
//  firebaseAuthPractice
//
//  Created by Macbook Pro on 18/06/2024.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

class LogInViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var loginButton : UIButton!
    
    private var isEmailValid = false
    private var isPasswordValid = false
    var validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLoginButtonState()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailField.text,
              let password = passwordField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error == nil {
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "vc") as? ViewController else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                AlertMessage.showAlertMessage("Account do not exist", "This account do not exist.you can create a new account.", self!)
            }
        }
    }
    
    @IBAction func googleLogin() {
        //retriving clientID
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        //the client ID is essential for configuring google-sign in process
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //starts sign in flow, here it shows google account to sign in
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error {
                print("Error signing in with Google: \(error)")
                return
            }
            
            //upon successful sign in, it extracts user's IDToken
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            //that IDToken is used to create credential of firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            //credentials are used to sign in
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error signing in with Firebase: \(error)")
                    return
                }
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as? ViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func appleIDLogin(_ sender: UIButton) {
        //not implemented because of unavalible of apple developer program.
    }
    
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "signup") as? SignUpViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateLoginButtonState () {
        let normalColor = UIColor.systemBlue
        let dimColor = normalColor.withAlphaComponent(0.7)
        loginButton.isEnabled = isEmailValid && isPasswordValid
        loginButton.backgroundColor = loginButton.isEnabled ? normalColor : dimColor
    }
}



// MARK: - Text Field Delegate
extension LogInViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailField {
            isEmailValid = validation.isEmailValid(textField.text ?? "")
        } else if textField == passwordField {
            isPasswordValid = validation.isPasswordValid(textField.text ?? "")
        }
        updateLoginButtonState()
    }
}

