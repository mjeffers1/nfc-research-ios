//
//  ViewController.swift
//  nfc-research-ios
//
//  Created by Martin Jeffers on 2018-02-08.
//  Copyright © 2018 Martin Jeffers. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UITableViewController {
    
    fileprivate var session: NFCNDEFReaderSession!
    fileprivate var messages: [[NFCNDEFMessage]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        createNFCSession()
    }
    
    fileprivate func createNFCSession() {
        self.session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        self.session.alertMessage = "You can scan NFC-tags by holding them near your device."
    
    }
    
    fileprivate class func nameFormat(from typeNameFormat: NFCTypeNameFormat) -> String {
        switch typeNameFormat {
        case .empty:
            return "Empty"
        case .nfcWellKnown:
            return "NFC Well Known"
        case .media:
            return "Media"
        case .absoluteURI:
            return "Absolute URI"
        case .nfcExternal:
            return "NFC External"
        case .unchanged:
            return "Unchanged"
        default:
            return "Unknown"
        }
    }
}

// MARK: UITableView
extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let messageCount = self.messages[section].count
        let headerTitle = messageCount == 1 ? "One Message" : "\(messageCount) Messages"
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as UITableViewCell
        let nfcTag = self.messages[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = "\(nfcTag.records.count) Records"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nfcTag = self.messages[indexPath.section][indexPath.row]
        let records = nfcTag.records.map({ String(describing: String(data: $0.payload, encoding: .utf8)!) })
        
        let alertTitle = nfcTag.records.count == 1 ? "One Record found." : " \(nfcTag.records.count) Records found."
        let alert = UIAlertController(title: alertTitle, message: records.joined(separator: "\n"), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: NFCNDEFReaderSessionDelegate
extension ViewController : NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
        print(" ------------------------------------ ")
        print("\n NFC Session invalidated: \(error.localizedDescription) \n")
        print(" ------------------------------------ ")
        
        createNFCSession()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        for message in messages {
            print(" ------------------------------------ ")
            print(" * \(message.records.count) Records:")
            for record in message.records {
                print("\t* TypeNameFormat: \(ViewController.nameFormat(from: record.typeNameFormat))")
                print("\t* Payload: \(String(data: record.payload, encoding: .utf8)!)")
                print("\t* Type: \(record.type)")
                print("\t* Identifier: \(record.identifier)\n")
            }
            print(" ------------------------------------ ")
        }

        self.messages.append(messages)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

