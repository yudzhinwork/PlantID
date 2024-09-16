//
//  PlantModels.swift
//  PlantID
//
//import Foundation
//import UIKit
//
//struct PlantIdentificationResponse: Decodable {
//    let id: Int
//    let images: [Image]
//    let suggestions: [Suggestion]
//    
//    struct Image: Decodable {
//        let file_name: String
//        let url: String
//    }
//
//    struct Suggestion: Decodable {
//        let id: Int
//        let plant_name: String
//        let probability: Float
//        let plant_details: PlantDetails?
//        let similar_images: [SimilarImage]
//        
//        struct SimilarImage: Decodable {
//            let id: String
//            let url: String
//            let similarity: Float
//        }
//        
//        struct PlantDetails: Decodable {
//            let common_names: [String]?
//            let taxonomy: Taxonomy
//            let wiki_description: WikiDescription?
//            let best_light_condition: String?
//            let toxicity: String?
//            let best_watering: String?
//            
//            struct Taxonomy: Decodable {
//                let genus: String
//                let order: String
//                let family: String
//            }
//            
//            struct WikiDescription: Decodable {
//                let value: String
//                let citation: String
//            }
//        }
//    }
//}
//
/////
/////
/////
/////
/////
//
//import Foundation
//
//// MARK: - Главная структура ответа
//struct PlantResponse: Codable {
//    let id: Int
//    let customID: String?
//    let metaData: MetaData
//    let uploadedDatetime: Double
//    let finishedDatetime: Double
//    let images: [PlantImage]
//    let modifiers: [String]
//    let secret: String
//    let failCause: String?
//    let countable: Bool
//    let feedback: String?
//    let isPlant: Bool
//    let isPlantProbability: Double
//    let healthAssessment: HealthAssessment
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case customID = "custom_id"
//        case metaData = "meta_data"
//        case uploadedDatetime = "uploaded_datetime"
//        case finishedDatetime = "finished_datetime"
//        case images
//        case modifiers
//        case secret
//        case failCause = "fail_cause"
//        case countable
//        case feedback
//        case isPlant = "is_plant"
//        case isPlantProbability = "is_plant_probability"
//        case healthAssessment = "health_assessment"
//    }
//}
//
//// MARK: - Мета данные
//struct MetaData: Codable {
//    let latitude: Double?
//    let longitude: Double?
//    let date, datetime: String
//}
//
//// MARK: - Изображение
//struct PlantImage: Codable {
//    let fileName: String
//    let url: String
//
//    enum CodingKeys: String, CodingKey {
//        case fileName = "file_name"
//        case url
//    }
//}
//
//// MARK: - Оценка здоровья
//struct HealthAssessment: Codable {
//    let isHealthy: Bool
//    let isHealthyProbability: Double
//    let diseases: [Disease]
//
//    enum CodingKeys: String, CodingKey {
//        case isHealthy = "is_healthy"
//        case isHealthyProbability = "is_healthy_probability"
//        case diseases
//    }
//}
//
//// MARK: - Болезнь
//struct Disease: Codable {
//    let name: String
//    let probability: Double
//    let redundant: Bool?
//    let entityID: Int
//    let diseaseDetails: DiseaseDetails
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case probability
//        case redundant
//        case entityID = "entity_id"
//        case diseaseDetails = "disease_details"
//    }
//}
//
//// MARK: - Детали болезни
//struct DiseaseDetails: Codable {
//    let localName, description: String
//    let url: String?  // Сделано опциональным, чтобы избежать ошибок с null
//    let treatment: Treatment?
//
//    enum CodingKeys: String, CodingKey {
//        case localName = "local_name"
//        case description
//        case url
//        case treatment
//    }
//}
//
//// MARK: - Лечение
//struct Treatment: Codable {
//    let chemical: [String]?
//    let biological: [String]?
//    let prevention: [String]?
//}

import RealmSwift
import Realm

// MARK: - PlantImage
class PlantImage: Object, Decodable {
    @Persisted var fileName: String = ""
    @Persisted var url: String = ""
    
    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case url
    }
}

// MARK: - PlantIdentificationResponse
class PlantIdentificationResponse: Object, Decodable {
    @Persisted var id: Int = 0
    @Persisted var images = List<PlantImage>()
    @Persisted var suggestions = List<Suggestion>()
    @Persisted var isAddedToGarden: Bool = false
    @Persisted var isNewPlant: Bool = true
    @Persisted var localImageData: Data?
    @Persisted var scanDate: Date?
    
    @Persisted var wateringDate: Date? = nil
    @Persisted var sprayingDate: Date? = nil
    @Persisted var fertilizeDate: Date? = nil
    
    // MARK: - Decodable initialization
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        images.append(objectsIn: try container.decode([PlantImage].self, forKey: .images))
        suggestions.append(objectsIn: try container.decode([Suggestion].self, forKey: .suggestions))
        
        isAddedToGarden = false
        isNewPlant = true
        scanDate = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case suggestions
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

    // MARK: - Suggestion
    @objc(PlantIdentificationResponseSuggestion)
    class Suggestion: Object, Decodable {
        @Persisted var id: Int = 0
        @Persisted var plantName: String = ""
        @Persisted var probability: Float = 0.0
        @Persisted var plantDetails: PlantDetails?
        @Persisted var similarImages = List<SimilarImage>()
        
        override static func primaryKey() -> String? {
            return "id"
        }

        enum CodingKeys: String, CodingKey {
            case id
            case plantName = "plant_name"
            case probability
            case plantDetails = "plant_details"
            case similarImages = "similar_images"
        }

        // MARK: - SimilarImage
        @objc(SimilarImage)
        class SimilarImage: Object, Decodable {
            @Persisted var id: String = ""
            @Persisted var url: String = ""
            @Persisted var similarity: Float = 0.0
        }

        // MARK: - PlantDetails
        @objc(PlantDetails)
        class PlantDetails: Object, Decodable {
            // Сделаем commonNames опциональным, чтобы избежать ошибок при nil
            @Persisted var commonNames = List<String>()
            @Persisted var taxonomy: Taxonomy?
            @Persisted var wikiDescription: WikiDescription?
            @Persisted var bestLightCondition: String?
            @Persisted var toxicity: String?
            @Persisted var bestWatering: String?

            enum CodingKeys: String, CodingKey {
                case commonNames = "common_names"
                case taxonomy
                case wikiDescription = "wiki_description"
                case bestLightCondition = "best_light_condition"
                case toxicity
                case bestWatering = "best_watering"
            }

            // Переопределяем init для обработки случаев с nil
            convenience required init(from decoder: Decoder) throws {
                self.init()

                let container = try decoder.container(keyedBy: CodingKeys.self)

                // Если commonNames нет или оно nil, присваиваем пустой список
                let commonNamesArray = try container.decodeIfPresent([String].self, forKey: .commonNames) ?? []
                commonNames.append(objectsIn: commonNamesArray)
                
                taxonomy = try container.decodeIfPresent(Taxonomy.self, forKey: .taxonomy)
                wikiDescription = try container.decodeIfPresent(WikiDescription.self, forKey: .wikiDescription)
                bestLightCondition = try container.decodeIfPresent(String.self, forKey: .bestLightCondition)
                toxicity = try container.decodeIfPresent(String.self, forKey: .toxicity)
                bestWatering = try container.decodeIfPresent(String.self, forKey: .bestWatering)
            }

            // MARK: - Taxonomy
            @objc(Taxonomy)
            class Taxonomy: Object, Decodable {
                @Persisted var genus: String = ""
                @Persisted var order: String = ""
                @Persisted var family: String = ""
            }

            // MARK: - WikiDescription
            @objc(WikiDescription)
            class WikiDescription: Object, Decodable {
                @Persisted var value: String = ""
                @Persisted var citation: String = ""
            }
        }
    }
}


// MARK: - PlantResponse
class PlantResponse: Object, Decodable {
    @Persisted var id: Int = 0
    @Persisted var customID: String? = nil
    @Persisted var metaData: MetaData?
    @Persisted var uploadedDatetime: Double = 0.0
    @Persisted var finishedDatetime: Double = 0.0
    @Persisted var images = List<PlantImage>()
    @Persisted var modifiers = List<String>()
    @Persisted var secret: String = ""
    @Persisted var failCause: String? = nil
    @Persisted var countable: Bool = false
    @Persisted var feedback: String? = nil
    @Persisted var isPlant: Bool = false
    @Persisted var isPlantProbability: Double = 0.0
    @Persisted var healthAssessment: HealthAssessment?
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case customID = "custom_id"
        case metaData = "meta_data"
        case uploadedDatetime = "uploaded_datetime"
        case finishedDatetime = "finished_datetime"
        case images
        case modifiers
        case secret
        case failCause = "fail_cause"
        case countable
        case feedback
        case isPlant = "is_plant"
        case isPlantProbability = "is_plant_probability"
        case healthAssessment = "health_assessment"
    }

    // MARK: - MetaData
    @objc(PlantResponseMetaData)
    class MetaData: Object, Decodable {
        @Persisted var latitude: Double? = nil
        @Persisted var longitude: Double? = nil
        @Persisted var date: String = ""
        @Persisted var datetime: String = ""
    }

    // MARK: - HealthAssessment
    @objc(PlantResponseHealthAssessment)
    class HealthAssessment: Object, Decodable {
        @Persisted var isHealthy: Bool = false
        @Persisted var isHealthyProbability: Double = 0.0
        @Persisted var diseases = List<Disease>()

        enum CodingKeys: String, CodingKey {
            case isHealthy = "is_healthy"
            case isHealthyProbability = "is_healthy_probability"
            case diseases
        }
    }

    // MARK: - Disease
    @objc(PlantResponseDisease)
    class Disease: Object, Decodable {
        @Persisted var name: String = ""
        @Persisted var probability: Double = 0.0
        @Persisted var redundant: Bool? = nil
        @Persisted var entityID: Int = 0
        @Persisted var diseaseDetails: DiseaseDetails?

        enum CodingKeys: String, CodingKey {
            case name
            case probability
            case redundant
            case entityID = "entity_id"
            case diseaseDetails = "disease_details"
        }
    }

    // MARK: - DiseaseDetails
    @objc(PlantResponseDiseaseDetails)
    class DiseaseDetails: Object, Decodable {
        @Persisted var localName: String = ""
        @Persisted var plantDescription: String = "" // Переименовано с "description"
        @Persisted var url: String? = nil
        @Persisted var treatment: Treatment?

        enum CodingKeys: String, CodingKey {
            case localName = "local_name"
            case plantDescription = "description"  // Используем для соответствия с JSON
            case url
            case treatment
        }
    }

    // MARK: - Treatment
    @objc(PlantResponseTreatment)
    class Treatment: Object, Decodable {
        @Persisted var chemical = List<String>()
        @Persisted var biological = List<String>()
        @Persisted var prevention = List<String>()
        
        enum CodingKeys: String, CodingKey {
            case chemical
            case biological
            case prevention
        }
        
        required override init() {
            super.init()
        }
        
        required init(from decoder: Decoder) throws {
            super.init()
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let chemicalArray = try? container.decode([String].self, forKey: .chemical) {
                chemical.append(objectsIn: chemicalArray)
            }
            if let biologicalArray = try? container.decode([String].self, forKey: .biological) {
                biological.append(objectsIn: biologicalArray)
            }
            if let preventionArray = try? container.decode([String].self, forKey: .prevention) {
                prevention.append(objectsIn: preventionArray)
            }
        }
    }
}

