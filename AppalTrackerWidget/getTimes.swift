// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct APIStopsResponse: Codable {
    let get_stop_etas: [busStopModel]
}

// Model used to store information about the estimated time, bus ID, and the route color
struct EnRoute: Codable {
    let time: String
    let routeID: Int
    let equipmentID: String
}
// Model used to store information about the Bus and the stop location
struct busStopModel: Codable {
    let id: Int
    let enRoute: [EnRoute]
}
// Model used to store information about the Stop, the estimated time, and the routeID
struct nextStopInfo: Codable {
    let stopID: Int
    let time: String
    let routeID: String
}
// Model used to store information about the route color, bus ID, and next stop information
struct busInformationModel: Codable {
    let routeID: Int
    let equipmentID: String
    let nextStopInfo: [nextStopInfo]
}

struct jsonCall: Codable {
    let flipped_bus_stops: [String: String]
}

struct colorInfo: Codable {
    let colors: [String: String]
}


class routeData {

    let allStopsUrl: String = "https://appalcart.etaspot.net/service.php?service=get_stop_etas&statusData=1&token=TESTING"
    let currentBusesAvailableUrl: String = "https://appalcart.etaspot.net/service.php?service=get_vehicles&includeETAData=1&inService=1&orderedETAArray=1&token=TESTING"

    private var time: String
    private var routeID: Int

    init (){
        self.time = "test"
        self.routeID = 0
    }

    func fetchStopData() async throws -> [busStopModel] {
        let url: URL = URL(string: allStopsUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse: APIStopsResponse = try JSONDecoder().decode(APIStopsResponse.self, from: data)
        return decodedResponse.get_stop_etas
    }

    // func fetchAvailableBusData() async throws -> [busInformationModel] {

    // }

    func getFilteredDataByName(nameValue: String) async throws -> [nextStopInfo]{
        var nextStopInfoArray: [nextStopInfo] = []
        
        guard let fileURL = Bundle.main.url(forResource: "flipped_bus_stops", withExtension: "json"),
              let colorFileURL = Bundle.main.url(forResource: "color_ids", withExtension: "json") else {
            return nextStopInfoArray
        }

        let jsonData = try Data(contentsOf: fileURL)
        let decodedBusStops = try JSONDecoder().decode(jsonCall.self, from: jsonData)

        let colorJsonData = try Data(contentsOf: colorFileURL)
        let decodedColorData = try JSONDecoder().decode(colorInfo.self, from: colorJsonData)

        let busData = try await fetchStopData()

        guard let stopIDString = decodedBusStops.flipped_bus_stops[nameValue],
              let stopIDFromJson = Int(stopIDString) else {
            return nextStopInfoArray
        }
        

        for stops in busData {
            if stops.id == stopIDFromJson {
                for values in stops.enRoute {
                    let color = decodedColorData.colors["routeID: \(values.routeID)"] ?? "unknown"
                    nextStopInfoArray.append(nextStopInfo(stopID: stops.id, time: values.time, routeID: color))
                }
            }
        }
        return nextStopInfoArray
    }


}

// let test = routeData()
// let testData = try await test.getFilteredDataByName(nameValue: "ASU College of Health Sciences")
// print(testData)
// let testData = try await test.fetchStopData()

// for stops in testData {
//     // print (stops.id)
//     for routes in stops.enRoute {
//         if stops.id == 110{
//             print(stops.id)
//             print(routes)
//         }
//     }

// }
