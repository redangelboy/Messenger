//
//  ChatModel.swift
//  ChatRoom
//
//  Created by Kun Niu on 12/1/22.
//


import Foundation


struct message : Decodable{
    var UID : String
    var body : String
    var timestamp : String
    var username : String
    
}

struct user {
    var UID : String
    var email : String
    var password : String
    var username : String
    
}

