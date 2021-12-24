//
//  OpenMessangers.swift
//  OrdersManagement
//
//  Created by Алексей Сухов on 24.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import Foundation
import SwiftUI

class OpenMessangers {
    private func getPhoneForWhatsup(number : String)->String
    {
        let item = number
        var ret = ""
        
        for letter in item {
            
            if letter.isNumber
            {
                ret.append(letter)
            }
        }
        return ret
    }
    func openPersonInCall(number : String)
    {
        
        let address = "tel:\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        let url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing telegramm")
                }
            }
            //}
        }
    }
    
    func openPersonInTelegram(number : String)
    {
        
        let address = "tg://msg?to=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        let url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing telegramm")
                }
            }
            //}
        }
    }
    func openPersonInSMS(number: String)
    {
        
        let address = "SMS:\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        let url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing sms")
                }
            }
            //}
        }
    }
    func openPersonInViber(number : String)
    {
        
        let address = "viber://add?number=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        let url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing Viber")
                }
            }
            //}
        }
    }
    func OpenPersonInWhatsup(number : String)
    {
        let address = "whatsapp://send/?phone=\(self.getPhoneForWhatsup( number : number  ))"
        //address = "https://www.hackingwithswift.com"
        let url  = URL(string: address)
        
        //Text which will be shared on WhatsApp is: "Hello Friends, Sharing some data here... !"
        if let url = url {
            // if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("WhatsApp accessed successfully")
                } else {
                    print("Error accessing WhatsApp")
                }
            }
            //}
        }
    }
}
