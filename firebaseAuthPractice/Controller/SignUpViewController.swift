//
//  SignUpViewController.swift
//  firebaseAuthPractice
//
//  Created by Macbook Pro on 18/06/2024.
//

import UIKit
import FirebaseAuth
//bbbbbbbb
class SignUpViewController: UIViewController{

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet weak var signupButton : UIButton!
    
    private var isEmailValid = false
    private var isPasswordValid = false
    var validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates are connected in storyboard
        updateSignupButtonState()
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        guard let email = emailField.text,
        let password = passwordField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            //handle error
            //handle successful account creation
            if error == nil {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as? ViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "login") as? LogInViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSignupButtonState () {
        let normalColor = UIColor.systemBlue
        let dimColor = normalColor.withAlphaComponent(0.7)
        signupButton.isEnabled = isEmailValid && isPasswordValid
        signupButton.backgroundColor = signupButton.isEnabled ? normalColor : dimColor
    }
}




// MARK: - Text Field Delegate
extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == emailField {
            isEmailValid = validation.isEmailValid(textField.text ?? "")
        } else if textField == passwordField {
            isPasswordValid = validation.isPasswordValid(textField.text ?? "")
        }
        updateSignupButtonState()
    }
}
