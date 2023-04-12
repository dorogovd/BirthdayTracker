//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Dmitrii Dorogov on 05.04.2023.
//

import UIKit
import CoreData

class BirthdaysTableViewController: UITableViewController {
    
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        let sortDescriptor1 = NSSortDescriptor(key: "lastName", ascending: true) // сортировка списка объектов Birthday
        let sortDescriptor2 = NSSortDescriptor(key: "firstName", ascending: true) // true - сортировка по возрастанию, false - сортировка по убыванию
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to load data due to an error: \(error)")
        }
        tableView.reloadData() // РАБОТАЕТ ТОЛЬКО ПОСЛЕ ПЕРЕЗАПУСКА ПРИЛОЖЕНИЯ
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentifier", for: indexPath)
        let birthday = birthdays[indexPath.row]
        
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }

        return cell
        
    }

    
    // метод для возможности редактирования таблицы дней рождений (сдвигание, удаление и тд)
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row { // проверяем что массив birthdays имеет минимум столько же объектов что и кол-во строк чтобы небыло "out of range"
            let birthday = birthdays[indexPath.row] // значение которое хотим удалить
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate // получаем доступ к контексту к базе данных для делегата???
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday) // удаляем объект из базы данных
            birthdays.remove(at: indexPath.row) // удаляем обхект и из таблицы
            
            do {
                try context.save() // сохранение изменений
            } catch let error {
                print("Failed to save due an \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade) // fade - вид анимации
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
