//
//  AgeRegisterViewController.swift
//  MyCalendar
//
//  Created by 桑原望 on 2020/03/27.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit

class AgeRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var maxPitches: UILabel!
    // これはテキストフィールドなので、変数の名前は ageField の方がわかりやすい。
    // （ageLabel だと UILabel と間違いやすい）。
    @IBOutlet weak var ageLabel: UITextField!
    
    let userDefaults = UserDefaults.standard
    //プロパティ監視
    // ↓ 必ず数値が入ることを保証して、オプショナルにはしない。
    var age: Int = 0 {
        didSet {
            // ↓ すでに、age に値が入っているので、ここで再度 ageLabel から値を入力する必要はない。
            // if let ageInt = Int(ageLabel.text!) {
                // self.age = ageInt
                if age < 6 { //6歳未満の場合
                    firstLabel.isHidden = true
                    secondLabel.isHidden = true
                    alertLabel.isHidden = false
                    maxPitches.isHidden = true
                    maxPitches.text = ""
                    alertLabel.text = "まずは野球を楽しみましょう!"
                    self.doneButton.isEnabled  = true
                    
                } else if age >= 6, age < 13 {//小学生の場合
                    firstLabel.isHidden = false
                    secondLabel.isHidden = false
                    maxPitches.text = String(800)
                    maxPitches.isHidden = false
                    alertLabel.text = "月に800球以上投げないようにしましょう。"
                    self.doneButton.isEnabled  = true
                    
                } else if age >= 13, age < 16 {//中学生の場合
                    firstLabel.isHidden = false
                    secondLabel.isHidden = false
                    maxPitches.text = String(1400)
                    maxPitches.isHidden = false
                    alertLabel.text = "月に1400球以上投げないようにしましょう。"
                    self.doneButton.isEnabled  = true
                // age >= 16 は上記以外すべてなので、else でかけます。
                // } else if age >= 16 {//高校生〜大人の場合
                } else {
                    firstLabel.isHidden = false
                    secondLabel.isHidden = false
                    maxPitches.text = String(2000)
                    maxPitches.isHidden = false
                    alertLabel.text = "月に2000球以上投げないようにしましょう。"
                    self.doneButton.isEnabled  = true
                }
            // }
        }
    }
    @IBAction func cancelReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageLabel.delegate = self
        
        firstLabel.isHidden = true
        // maxPitches.isHidden = true
        secondLabel.isHidden = true
        //前回登録した年齢データの取り出し
        // ↓ 年齢は数値なので、Int で保存しておいた方が良い。
        /*
        let myAge = userDefaults.string(forKey: "myAge")
        ageLabel.text = myAge
         */
        let myAge = userDefaults.integer(forKey: "myAge")
        ageLabel.text = String(myAge)
        // 最初からアドバイスを表示しておくために、age に代入。
        age = myAge
        
        self.doneButton.isEnabled  = false
        
        //   NumberPadに"Done"ボタンを表示
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width: 320, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [space, doneButton]
        ageLabel.inputAccessoryView = toolBar
        self.ageLabel.keyboardType = UIKeyboardType.numberPad
      
        // 文字が入力されるたびにメソッドを呼び出すための処理
        ageLabel.addTarget(
            self,
            action: #selector(AgeRegisterViewController.textFieldDidChange(textFiled:)),
            for: UIControl.Event.editingChanged
        )
    }
    @objc func doneButtonTapped(sender: UIButton) {
        self.view.endEditing(true)
    }
    //textFieldタップ時に全選択にする
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        /*
        // textFieldDidEndEditing は、Done を押さないと呼び出されないので、
        // 別の方法で処理するように変更。
        //年齢に応じて投球数の上限を表示
        if let ageInt = Int(ageLabel.text!) {
            self.age = ageInt
        }
         */
        // 保存処理はここで OK
        // 上限投球数を保存
        userDefaults.set(Int(maxPitches.text!), forKey: "myMax")
        // 同じ情報を複数保存するとバグの原因になるので、"myMaxString" は不要。
        // userDefaults.set(maxPitches.text, forKey: "myMaxString")
        //年齢を保存
        // 年齢は数値なので、Int で保存する。Int にできなかったときには、0 を保存。
        // userDefaults.set(ageLabel.text!, forKey: "myAge")
        let ageInt = Int(ageLabel.text!) ?? 0
        userDefaults.set(ageInt, forKey: "myAge")
        userDefaults.synchronize()
    }
  
    // 文字を入力するたびに呼び出される。
    @objc func textFieldDidChange(textFiled: UITextField) {
        //年齢に応じて投球数の上限を表示
        if let ageInt = Int(ageLabel.text!) {
            self.age = ageInt
        }
    }
}
