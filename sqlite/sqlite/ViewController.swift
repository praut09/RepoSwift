//
//  ViewController.swift
//  sqlite
//
//  Created by sachin shinde on 30/12/19.
//  Copyright © 2019 sachin shinde. All rights reserved.
//

import UIKit
import SQLite3

struct apimodel {
    var name : String?
    var surname : String?
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableViewStudents: UITableView!
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    @IBOutlet var txtName: UITextField!
    var db : OpaquePointer? = nil
    var stmt : OpaquePointer? = nil
    var storeAPIdataInSqlite = apimodel()
    var array = [String]()
    var arrayName = NSMutableArray()
    var arraySurname = NSMutableArray()
    var finalArray = [String]()
    @IBOutlet var txtSurname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tableViewStudents.showAnimatedGradientSkeleton()
        openDatabaseFile()
        createTable()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddStudent(_ sender: UIButton) {
        array.append(txtName.text!)
        array.append(txtSurname.text!)
        finalArray.append(contentsOf: array)
        print(array)
        var stmt : OpaquePointer?
        let queryString = "INSERT INTO MCQTESTS (Name,Surname) VALUES (?,?)"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) == SQLITE_OK {
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert \(errmsg)")
            return
        }
        var i = 1
        for str in finalArray {
            if sqlite3_bind_text(stmt, Int32(i), str, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error Binding text \(errmsg)")
                return
            }
            i=i+1
        }
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Record Inserted")
            array = []
            finalArray = []
            readValues()
            tableViewStudents.isSkeletonable = false
            return
        }
        
    }
    
    func openDatabaseFile() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("sqlitedb.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error Opening Database \(errmsg)")
            return
        } else {
            print("Database opened successfully at file path \(fileURL.path)")
        }
    }
    
    func createTable() {
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS MCQTESTS (id INTEGER PRIMARY KEY AUTOINCREMENT , Name TEXT, Surname TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Cannot create table \(errmsg)")
            return
        }
        print("table created")
    }
    
    func readValues()
    {
        let queryString = "SELECT * FROM MCQTESTS"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error while fetching data : \(errmsg)")
            return
        }
        while sqlite3_step(stmt) == SQLITE_ROW {
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let surname = String(cString: sqlite3_column_text(stmt, 2))
            print("\(name) , \(name),")
            storeAPIdataInSqlite.name = name
            storeAPIdataInSqlite.surname = surname
            arrayName.add(storeAPIdataInSqlite.name!)
            arraySurname.add(storeAPIdataInSqlite.surname!)
        }
        DispatchQueue.main.async {
            self.tableViewStudents.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customCell
        cell.lblName.text = arrayName[indexPath.row] as? String
        cell.lblSurname.text = arraySurname[indexPath.row] as? String
    return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

