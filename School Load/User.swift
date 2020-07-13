//
//  User.swift
//  School Load
//
//  Created by Dylan Teller on 4/12/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications

public class User {

	var ID: String = ""
	var fname: String = ""
	var lname: String = ""
	var email: String = ""
	var numCourses: Int = 0
	var numTodosToday: Int = 0
	var courses: [Course] = []
	var todos: [Todo] = []
	var completed: [Todo] = []
	var needsToGoToCourses = false
	var needsToGoToMe = false
	
	let colors: [UIColor] = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemPink, UIColor.systemPurple, UIColor.systemRed, UIColor.systemTeal, UIColor.systemYellow]
	
	public func sortTodos() {
		if self.todos.count > 0 {
			for i in 0..<self.todos.count-1 {
				for k in i+1..<self.todos.count {
					if self.todos[i].date > self.todos[k].date {
						let tmp = self.todos[i]
						self.todos[i] = self.todos[k]
						self.todos[k] = tmp
					}
				}
			}
			
			for i in 0..<self.todos.count-1 {
				for k in i+1..<self.todos.count {
					let formatter = DateFormatter()
					formatter.dateStyle = .full
					var datePre = formatter.string(from: self.todos[i].date)
					datePre.removeLast(6)
					
					let formatter2 = DateFormatter()
					formatter2.dateStyle = .full
					var date2Pre = formatter2.string(from: self.todos[k].date)
					date2Pre.removeLast(6)
					
					if datePre == date2Pre {
						let formatter3 = DateFormatter()
						formatter3.timeStyle = .short
						let time1 = formatter3.string(from: self.todos[i].date)
						let formatter4 = DateFormatter()
						formatter4.timeStyle = .short
						let time2 = formatter4.string(from: self.todos[k].date)
						if time1 == time2 {
							if self.todos[i].dateAdded > self.todos[k].dateAdded {
								let tmp = self.todos[i]
								self.todos[i] = self.todos[k]
								self.todos[k] = tmp
							}
						}
					}
				}
			}
		}
	}
	
	public func sortCompleted() {
		if self.completed.count > 0 {
			for i in 0..<self.completed.count-1 {
				for k in i+1..<self.completed.count {
					if self.completed[i].dateCompleted > self.completed[k].dateCompleted {
						let tmp = self.completed[i]
						self.completed[i] = self.completed[k]
						self.completed[k] = tmp
					}
				}
			}
		}
	}

}
