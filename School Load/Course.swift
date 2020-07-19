//
//  Course.swift
//  School Load
//
//  Created by Dylan Teller on 4/13/20.
//  Copyright © 2020 Dylan Teller. All rights reserved.
//

import Foundation

public class Course {
	
	var name: String
	var color: Int
	var numTodos: Int
	var ID : String
	
	init(name: String, color: Int, ID: String, numTodos: Int) {
		self.name = name
		self.color = color
		self.ID = ID
		self.numTodos = numTodos
	}
	
	static public func ==(left: Course, right: Course) -> Bool {
		if left.ID == right.ID {
			return true
		} else {
			return false
		}
	}
	
}
