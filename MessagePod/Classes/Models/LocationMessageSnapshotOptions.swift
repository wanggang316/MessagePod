//
//  LocationMessageSnapshotOptions.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import MapKit


public struct LocationMessageSnapshotOptions {
    
    var showsBuildings = false

    var showsPointsOfInterest = false

    var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0)

    var scale: CGFloat = UIScreen.main.scale
    
}
