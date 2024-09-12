////
////  PlainPlantModels.swift
////  PlantID

import RealmSwift
import Foundation

@objc(ScanHistoryRealm) class ScanHistoryRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var scanDate: Date = Date()
    @objc dynamic var plantName: String = ""
    @objc dynamic var imageData: Data? = nil
    @objc dynamic var scanType: Int = 0
    @objc dynamic var relatedObjectId: Int = 0 // ID связанного объекта

    override static func primaryKey() -> String? {
        return "id"
    }
}

var mainRealm: Realm!

class RealmController {
    
    static var shared: RealmController = RealmController()
    
    func setup() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: nil)
        do {
            mainRealm = try Realm()
        } catch let error as NSError {
            assertionFailure("Realm loading error: \(error)")
        }
    }
    
}

extension Realm {
    public func realmWrite(_ block: (() -> Void)) {
        if isInWriteTransaction {
            block()
        } else {
            do {
                try write(block)
            } catch {
                assertionFailure("Realm write error: \(error)")
            }
        }
    }
}

func realmWrite(realm: Realm = mainRealm, _ block: (() -> Void)) {
    realm.realmWrite(block)
}
