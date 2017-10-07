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
   var usersRef: DatabaseReference!
   var signupIsShowing: Bool = true
   
   //MARK: Outlets
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var usernameTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var mainActionButton: UIButton!
   @IBOutlet weak var secondaryActionButton: UIButton!
   @IBOutlet weak var signupErrorLabel: UILabel!
   
   
   //MARK: Actions
   /**********************************************************
    * NAME: mainActionButtonTapped
    *
    * DESCRIPTION: authenticate a user into database.
    ***********************************************************/
   @IBAction func mainActionButtonTapped(_ sender: Any) {
      registerNewUser()
   }
   
   /**********************************************************
    * NAME: secondaryActionButtonTapped
    *
    * DESCRIPTION: switch between login and signup views.
    ***********************************************************/
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
   
   /**********************************************************
    * NAME: unwindToLogin
    *
    * DESCRIPTION: change views when logout button is tapped.
    ***********************************************************/
   @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
      // should I do any logging out firebase code here?
   }
   
   
   //MARK: Methods
   /**********************************************************
    * NAME: viewDidLoad
    *
    * DESCRIPTION: called when the view is loaded
    ***********************************************************/
   override func viewDidLoad() {
      super.viewDidLoad()
      // view setup
      setupView()
      // instantiate reference to our database.
      ref = Database.database().reference(fromURL: "https://spottystarter.firebaseio.com/")
      
   }
   
   
   /**********************************************************
    * NAME: setupView
    *
    * DESCRIPTION: do additional view set up
    ***********************************************************/
   func setupView() {
      mainActionButton.titleLabel?.text = "Sign Up"
      secondaryActionButton.titleLabel?.text = "Login"
      signupErrorLabel.isHidden = true
   }
   
   
   /**********************************************************
    * NAME: displaySignupError
    *
    * DESCRIPTION: If there is an error in signing up, let
    * user know.
    ***********************************************************/
   func displaySignupError(_ error: Error?) {
      signupErrorLabel.textColor = UIColor.red
      signupErrorLabel.text = "\(error?.localizedDescription)"
      signupErrorLabel.isHidden = false
   }
  
   /**********************************************************
    * NAME: registerNewUser
    *
    * DESCRIPTION: register a new user in my authorization
    * and keep their data in the database!
    ***********************************************************/
   func registerNewUser() {
      guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text else {
         // do some error handling here.
         print("invalid forms")
         return
      }
      Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
         // if this if statement is false, then we've successfully authenticated!
         if error != nil {
            //            self.displaySignupError(error)
            print(error)
            return
         }
         // make a dictionary of values to send to Firebase
         let valuesToSendToFirebase = ["Username": username, "Email": email]
         
         guard let uid = user?.uid else {
            return
         }
         // create a reference to the uid child of the users which is child of database
         self.usersRef = self.ref.child("users").child(uid)
         
         // update the "users" part of the database.
         self.usersRef.updateChildValues(valuesToSendToFirebase, withCompletionBlock: { (err, ref) in
            if err != nil {
               print(err)
               return
            }
         })
         
         // once done, perform segue.
         self.performSegue(withIdentifier: "toHomeScreen", sender: nil)
      }
   }


}

