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
	var time: Date
	
	init(name: String, color: Int, ID: String, numTodos: Int, time: Date) {
		self.name = name
		self.color = color
		self.ID = ID
		self.numTodos = numTodos
		self.time = time
	}
	
}
