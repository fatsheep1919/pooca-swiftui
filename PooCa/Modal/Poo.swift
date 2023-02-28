//
//  Poo.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import Foundation
import SwiftUI

enum PooHardness: String, CaseIterable, Codable {
  case hard = "便秘"
  case dry = "干燥"
  case perfect = "完美"
  case soft = "绵软"
  case liquid = "拉稀"
}

enum PooColor: String, CaseIterable, Codable {
  case yellow
  case green
  case brown
  case pink
  case black
}

enum PooMood: String, CaseIterable, Codable {
  case happy = "开心"
  case proud = "骄傲"
  case soso = "平常"
  case anxious = "焦虑"
  case tired = "疲惫"
}

struct Poo: Identifiable, Codable {
  let id: UUID
  var date: String
  var time: String
  var hardness: PooHardness?
  var color: PooColor?
  var mood: PooMood?
  var desc: String = ""
  
  init(id: UUID = UUID(), hardness: PooHardness? = nil, color: PooColor? = nil, mood: PooMood? = nil, desc: String = "") {
    let currentDate = Date();
    let date = Poo.formatDate(date: currentDate);
    let time = Poo.formatTime(time: currentDate);
    
    self.id = id
    self.date = date
    self.time = time
    self.hardness = hardness
    self.color = color
    self.mood = mood
    self.desc = desc
  }
  
  mutating func update(newItem: Poo) {
    self.hardness = newItem.hardness
    self.color = newItem.color
    self.mood = newItem.mood
    self.desc = newItem.desc
  }
  
  static func formatDate(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "YYYY-MM-dd";
    return formatter.string(from: date);
  }
  
  static func formatTime(time: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm";
    return formatter.string(from: time);
  }
}
