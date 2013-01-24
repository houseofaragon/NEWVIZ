//
//  MapViewController.h
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344


@interface MapViewController: UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *twitterSearch;
@property (nonatomic, strong) CLGeocoder *geocoder;

-(void)searchTwitterWithString:(NSString *)str andNumResults:(int)num;

@end
