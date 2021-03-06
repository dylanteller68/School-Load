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
	var dateAdded: Date
	var color: Int
	var dateCompleted = Date()
	var ID: String
	var note: String
	
	init(name: String, course: String, date: Date, dateAdded: Date, color: Int, ID: String, note: String) {
		self.name = name
		self.course = course
		self.date = date
		self.dateAdded = dateAdded
		self.color = color
		self.ID = ID
		self.note = note
	}
	
	init(name: String, course: String, date: Date, dateCompleted: Date, dateAdded: Date, color: Int, ID: String, note: String) {
		self.name = name
		self.course = course
		self.date = date
		self.dateCompleted = dateCompleted
		self.dateAdded = dateAdded
		self.color = color
		self.ID = ID
		self.note = note
	}
	
}
