//
//  MapViewController.h
//  KingTides
//
//  Created by Andrew Spinks on 8/12/2013.
//  Copyright (c) 2013 Green Cross Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GAITrackedViewController.h"

@interface MapViewController : GAITrackedViewController

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end
