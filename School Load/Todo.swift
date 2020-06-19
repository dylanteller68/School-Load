//
//  Todo.swift
//  School Load
//
//  Created by Dylan Teller on 4/13/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import Foundation

public class Todo {
	
	var name: String
	var course: String
	var date: Date
	var color: Int
	var dateCompleted = Date()
	var ID: String
	
	init(name: String, course: String, date: Date, color: Int, ID: String) {
		self.name = name
		self.course = course
		self.date = date
		self.color = color
		self.ID = ID
	}
	
	init(name: String, course: String, date: Date, dateCompleted: Date, color: Int, ID: String) {
		self.name = name
		self.course = course
		self.date = date
		self.dateCompleted = dateCompleted
		self.color = color
		self.ID = ID
	}
	
}
