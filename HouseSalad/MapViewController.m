//
//  MapViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "MapViewController.h"
#import <Mapkit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TwitterAnnotation.h"

@implementation MapViewController

@synthesize mapView = _mapView;

#pragma mark - Synchronize Model and View

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }

    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    aView.image=[UIImage imageNamed:@"map_icon.png"];
    return aView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [super viewDidLoad];
    self.mapView.delegate = self;
    NSLog(@"%@", self.twitterSearch);
 
    [self searchTwitterWithString:self.twitterSearch andNumResults:200];
    
}

- (void)geocode:(NSString*)address withName:(NSString*)name withCoordinate:(CLLocationCoordinate2D)coordinate
{
    TwitterAnnotation *annotation = [[TwitterAnnotation alloc] initWithName:name address:address coordinate:coordinate];
    
    [self.mapView addAnnotation:annotation];    
    
}

-(void)searchTwitterWithString:(NSString *)str andNumResults:(int)num {
    
    NSLog(@"Enter search Twitter with String");

    NSURL *requestURL = [NSURL URLWithString:@"http://search.twitter.com/search.json"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           str, @"q",
                           @"", @"geocode",
                           @"", @"latitude",
                           @"", @"longitude",
                           [NSString stringWithFormat:@"%d", num], @"rpp",
                           @"en",@"lang",
                           nil];
    
    // tr = twitter request
    SLRequest *tr = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                       requestMethod:SLRequestMethodGET
                                                 URL:requestURL parameters:param];
    
    [tr performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSString *address = @"";
        NSString *text = @"";
        NSString *user = @"";
        // NSLOG RESULTS
        NSLog(@"Results:%@",[dict objectForKey:@"results"]);

        for (NSDictionary *d in [dict objectForKey:@"results"]) {
            CLGeocoder* gc = [[CLGeocoder alloc] init];

            address = [NSString stringWithFormat:@"%@",[d objectForKey:@"location"]];
            text = [NSString stringWithFormat:@"%@",[d objectForKey:@"text"]];
            user = [NSString stringWithFormat:@"%@",[d objectForKey:@"from_user"]];

            
            if ([address isKindOfClass:[NSString class]] && [address length] != 0){

            NSLog(@"Address: %@",address);

            [gc geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
                if(placemarks.count > 0){
               
                    NSLog(@"Address: %@",address);
                    
                    CLPlacemark *placemark = (CLPlacemark*)placemarks[0];
                    NSLog(@"Placemark: %@",[placemark description]);
                    CLLocation *location = placemark.location;                    
                    CLLocationCoordinate2D coordinate = location.coordinate;
                    
                    [self geocode:user withName:text withCoordinate:coordinate];
                }
                
            }];
                gc = nil;
 
           }
        }
    }];
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
