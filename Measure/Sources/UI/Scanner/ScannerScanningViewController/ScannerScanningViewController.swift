//
//  ScannerScanningViewController.swift
//  PlantID

import UIKit
import RealmSwift

public let apiKey = "cYbFQfo56cJdlgoik5CaU48fy2hR3lfPx7u0ipcjY6231eTR5v"

class ScannerScanningViewController: BaseViewController {
    
    @IBOutlet private weak var scanningImageView: UIImageView!
    
    var scanningImage: UIImage!
    var scannerType: ScannerType = .identify

    override func viewDidLoad() {
        super.viewDidLoad()
        scanningImageView.image = scanningImage
        guard let imageData = scanningImage.jpegData(compressionQuality: 0.8) else { return }
        processImage(imageData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    func imageToBase64String(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }

    func processImage(_ imageData: Data) {
        let base64String = imageData.base64EncodedString()
        switch scannerType {
        case .identify:
            identifyPlant(with: base64String)
        case .diagnose:
            diagnosePlant(with: base64String)
        }
    }
    
    func diagnosePlant(with base64Image: String) {
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "images": ["data:image/jpeg;base64,\(base64Image)"],
            "datetime": Int(Date().timeIntervalSince1970),
            "plant_language": "en",
            "disease_details": ["cause",
                              "common_names",
                              "classification",
                              "description",
                              "treatment",
                              "url"],
        ]
        
        guard let url = URL(string: "https://api.plant.id/v2/health_assessment") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                do {
                    let plantResponse = try decoder.decode(PlantResponse.self, from: data)
                    parsePlantHealthResponse(plantResponse)
                } catch {
                    print("Failed to decode JSON: \(error)")
                    let vc = ScannerNotFoundViewController()
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch {
                print("Request failed: \(error.localizedDescription)")
            }
        }
    }
    
    func identifyPlant(with base64Image: String) {
         let parameters: [String: Any] = [
             "api_key": apiKey,
             "images": ["data:image/jpeg;base64,\(base64Image)"],
             "datetime": Int(Date().timeIntervalSince1970),
             "modifiers": ["crops_fast", "similar_images"],
             "plant_language": "en",
             "plant_details": ["common_names",
                               "edible_parts",
                               "gbif_id",
                               "name_authority",
                               "propagation_methods",
                               "synonyms",
                               "taxonomy",
                               "url",
                               "wiki_description",
                               "wiki_image",
                               "best_light_condition",
                               "toxicity",
                               "best_watering",
             ],
         ]
         
         guard let url = URL(string: "https://api.plant.id/v2/identify") else {
             print("Invalid URL")
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         
         do {
             request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
         } catch {
             print("Failed to serialize JSON: \(error.localizedDescription)")
             return
         }
         
         Task {
             do {
                 let (data, _) = try await URLSession.shared.data(for: request)
                 
                 let decoder = JSONDecoder()
                 do {
                     let plantResponse = try decoder.decode(PlantIdentificationResponse.self, from: data)
                     handlePlantIdentification(plantResponse)
                 } catch {
                     print("Failed to decode JSON: \(error)")
                     let vc = ScannerNotFoundViewController()
                     navigationController?.pushViewController(vc, animated: true)
                 }
                 
             } catch {
                 print("Request failed: \(error.localizedDescription)")
             }
         }
     }
    
    func parsePlantHealthResponse(_ response: PlantResponse) {
        guard let imageData = scanningImage.jpegData(compressionQuality: 0.8) else { return }
        let base64String = imageData.base64EncodedString()
        
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "images": ["data:image/jpeg;base64,\(base64String)"],
            "datetime": Int(Date().timeIntervalSince1970),
            "modifiers": ["crops_fast", "similar_images"],
            "plant_language": "en",
            "plant_details": ["common_names",
                              "edible_parts",
                              "gbif_id",
                              "name_authority",
                              "propagation_methods",
                              "synonyms",
                              "taxonomy",
                              "url",
                              "wiki_description",
                              "wiki_image",
                              "best_light_condition",
                              "toxicity",
                              "best_watering",
            ],
        ]
        
        guard let url = URL(string: "https://api.plant.id/v2/identify") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                do {
                    let plantResponse = try decoder.decode(PlantIdentificationResponse.self, from: data)
                    
                    if plantResponse.suggestions.first!.probability >= 0.2 {
                        if response.healthAssessment!.isHealthy {
                            plantResponse.isAddedToGarden = false
                            guard let imageData = scanningImage.jpegData(compressionQuality: 0.8) else { return }
                            plantResponse.localImageData = imageData
                            realmWrite {
                                mainRealm.add(plantResponse, update: .modified)
                            }
                            realmWrite {
                                mainRealm.add(response, update: .modified)
                            }
                            let vc = ScannerPlantIsHealthyController()
                            savePlantToHistoryHealthy(plantResponse, response: 
                                                        response, base64Image:
                                                        imageData.base64EncodedString())
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = ScannerResultViewController()
                            vc.resultHealty = response
                            guard let imageData = scanningImage.jpegData(compressionQuality: 0.8) else { return }
                            plantResponse.localImageData = imageData
                            vc.result = plantResponse
                            vc.scannerType = .diagnose
                            vc.image = scanningImage
                            realmWrite {
                                mainRealm.add(response, update: .modified)
                            }
                            realmWrite {
                                mainRealm.add(plantResponse, update: .modified)
                            }
                            savePlantToHistoryHealthy(plantResponse, 
                                                      response: response,
                                                      base64Image: imageData.base64EncodedString())       
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        let vc = ScannerNotFoundViewController()
                        navigationController?.pushViewController(vc, animated: true)
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                    let vc = ScannerNotFoundViewController()
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch {
                print("Request failed: \(error.localizedDescription)")
            }
        }
        
    }
    
    func handlePlantIdentification(_ response: PlantIdentificationResponse) {
        if response.suggestions.first!.probability >= 0.2 {
            let vc = ScannerResultViewController()
            vc.result = response
            vc.scannerType = .identify
            vc.image = scanningImage
            guard let imageData = scanningImage.jpegData(compressionQuality: 0.8) else { return }
            savePlantToHistory(response, base64Image: imageData.base64EncodedString())
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ScannerNotFoundViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func savePlantToHistory(_ plantResponse: PlantIdentificationResponse, base64Image: String) {
        let historyItem = ScanHistoryRealm()
        historyItem.id = plantResponse.id
        historyItem.scanDate = Date()
        historyItem.plantName = plantResponse.suggestions.first!.plantName
        if let imageData = Data(base64Encoded: base64Image) {
            historyItem.imageData = imageData
        }
        historyItem.scanType = scannerType.rawValue
        historyItem.relatedObjectId = plantResponse.id
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(historyItem)
            }
            print("Successfully saved plant identification to history.")
        } catch {
            print("Failed to save plant identification to history: \(error.localizedDescription)")
        }
    }
    
    func savePlantToHistoryHealthy(_ plantResponse: PlantIdentificationResponse, response: PlantResponse, base64Image: String) {
        let historyItem = ScanHistoryRealm()
        historyItem.id = plantResponse.id
        historyItem.scanDate = Date()
        historyItem.plantName = plantResponse.suggestions.first!.plantName
        if let imageData = Data(base64Encoded: base64Image) {
            historyItem.imageData = imageData
        }
        historyItem.scanType = scannerType.rawValue
        historyItem.relatedObjectId = response.id
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(historyItem)
            }
            print("Successfully saved plant identification to history.")
        } catch {
            print("Failed to save plant identification to history: \(error.localizedDescription)")
        }
    }
    
    
    func savePlantResponse(_ response: PlantResponse) {
        let realm = try! Realm()

        do {
            try realm.write {
                realm.add(response)
            }
        } catch {
            print("Ошибка при сохранении объекта: \(error)")
        }
    }

}
