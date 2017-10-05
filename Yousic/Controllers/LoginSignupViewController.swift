//
//  ViewController.swift
//  Yousic
//
//  Created by Adly Thebaud on 10/4/17.
//  Copyright © 2017 ThebaudHouse. All rights reserved.
//  Call it Yousique!

import UIKit
import Firebase
class LoginSignupViewController: UIViewController {

   //MARK: Member Variables
   var ref: DatabaseReference!
   var signupIsShowing: Bool = true
   
   //MARK: Outlets

   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var usernameTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var mainActionButton: UIButton!
   @IBOutlet weak var secondaryActionButton: UIButton!
   
   
   //MARK: Actions
   
   // authenticate
   @IBAction func mainActionButtonTapped(_ sender: Any) {
      guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text else {
         // do some error handling here.
         print("invalid forms")
         return
      }
      Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
         // if this if statement is false, then we've successfully authenticated!
         if error != nil {
            print(error)
            return
         }
         
         self.ref.updateChildValues(["user": username])
         self.performSegue(withIdentifier: "toHomeScreen", sender: nil)
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let homeVC = segue.destination as? HomeScreenViewController
      homeVC?.navigationItem.title = "You in, son"
      
      
      
   }
   
   // switch between login and signup views
   // always starting on signup
   @IBAction func secondaryActionButtonTapped(_ sender: Any) {
      if signupIsShowing {
         // show login
         emailTextField.isHidden = true
         mainActionButton.titleLabel?.text = "Login"
         secondaryActionButton.titleLabel?.text = "Sign Up"
         signupIsShowing = false
      } else if !signupIsShowing {
         // show the sign up!
         emailTextField.isHidden = false
         mainActionButton.titleLabel?.text = "Sign Up"
         secondaryActionButton.titleLabel?.text = "Login"
         signupIsShowing = true
         
      }

   }
   
   
   //MARK: Methods
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupView()
      ref = Database.database().reference(fromURL: "https://spottystarter.firebaseio.com/")
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func setupView() {
      mainActionButton.titleLabel?.text = "Sign Up"
      secondaryActionButton.titleLabel?.text = "Login"
   }
   
  
  


}

