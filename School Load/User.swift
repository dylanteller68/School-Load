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
	var notificationHour = 8
	var notificationMinute = 0
	
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

	public func sortCourses() {
		if self.courses.count > 0 {
			for i in 0..<self.courses.count-1 {
				for k in i+1..<self.courses.count {
					if self.courses[i].time < self.courses[k].time {
						let tmp = self.courses[i]
						self.courses[i] = self.courses[k]
						self.courses[k] = tmp
					}
				}
			}
		}
	}
	
	public func setNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		
		var numTodosToday = 0
		
		for t in user.todos {
			let df = DateFormatter()
			df.dateStyle = .full
			var todoDateFormatted = df.string(from: t.date)
			todoDateFormatted.removeLast(6)
			
			let df2 = DateFormatter()
			df2.dateStyle = .full
			var todaysDateFormatted = df2.string(from: Date())
			todaysDateFormatted.removeLast(6)
			
			if todaysDateFormatted == todoDateFormatted {
				numTodosToday += 1
			}
		}
		
		let content = UNMutableNotificationContent()
		content.title = "Today"
		if numTodosToday != 1 {
			content.body = "You have \(numTodosToday) to-dos today"
		} else {
			content.body = "You have \(numTodosToday) to-do today"
		}
		content.sound = .default
		
		var dateComponents = DateComponents()
		dateComponents.calendar = Calendar.current

		dateComponents.hour = user.notificationHour
		dateComponents.minute = user.notificationMinute
		   
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		
		let uuidString = UUID().uuidString
		let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.requestAuthorization(options: [.alert,.sound], completionHandler: { (granted,error) in})
		notificationCenter.add(request)
	}
}
