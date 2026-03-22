//
//  RouteData.swift
//  AppalTRACK
//
//  Created by Eric Hendershot on 3/21/26.
//
struct Route {
    let bus: String,
    weekday: [String],
    stops: [Stop]
}

struct Stop {
    let name: String
    let departure: [String]
}

let busList: [Route] = [
    Route(
        bus: "Blue",
        weekday: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
        stops: [
            Stop(name: "ASU College St Station", departure: [":05", ":25", ":45"]),
            Stop(name: "", departure: []),
            Stop(name: "", departure: []),
            Stop(name: "", departure: []),
        ]
    )
]
