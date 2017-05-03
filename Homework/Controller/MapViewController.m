//
//  MapViewController.m
//  Homework
//
//  Created by Aleksey Gorbachevskiy on 26/04/17.
//  Copyright © 2017 Aleksey Gorbachevskiy. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Vehicle+CoreDataClass.h"
#import "NetworkManager.h"
#import "DataProvider.h"
#import "MarkerView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AddressHelper.h"

@interface MapViewController () <GMSMapViewDelegate>

@property (strong, nonatomic) NSMutableArray <VehicleLocation *>*vehicleLocations;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) NSMutableArray <GMSMarker *>*markers;
@property (strong, nonatomic) GMSPolyline *polyline;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic) BOOL isLoadedCamera;
@property (nonatomic) BOOL tappedMarker;

@end

@implementation MapViewController

- (void)loadView {
    
    self.tappedMarker = NO;
    self.isLoadedCamera = NO;
    [self loadMap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vehicleLocations = [NSMutableArray new];
    self.markers = [NSMutableArray new];
    [self checkIfNeedUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Loading Data

- (void)downloadVehiclesFromLocalStorage {
    
    User *user = [[DataProvider sharedInstance] getUserWithUserid:self.userid];
    
    for (Vehicle *vehicle in user.vehicles) {
        
        if (vehicle.vehicleLocation) {
            
            [self.vehicleLocations addObject:vehicle.vehicleLocation];
        }
    }
    
    [self setupMarkers];
    [self setupCamera];
    [self startTimer];
}

- (void)startTimer {
    
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kSecondsBetweenUpdateMapViewMarkers target:self selector:@selector(updateAfterOneMinute) userInfo:nil repeats:YES];
    }
}

- (void)updateAfterOneMinute {
        
    [self clearData];
    [self downloadVehicleLocationsFromServer];
}

- (void)checkIfNeedUpdate {
    
    User *user = [[DataProvider sharedInstance] getUserWithUserid:self.userid];
    
    if ([NSDate secondsSinceDate:user.vehicleUpdateTime] >= 30) {
        
        [self clearData];
        [self downloadVehicleLocationsFromServer];
    } else {
        
        [self downloadVehiclesFromLocalStorage];
    }
}

- (void)downloadVehicleLocationsFromServer {
    
    [[NetworkManager sharedInstance] getVehiclesLocationWithUserid:self.userid success:^(NSArray *responseArray) {
        
        for (NSDictionary *vehicleLocationDict in responseArray) {
            
            [[DataProvider sharedInstance] saveVehicleLocationFromDict:vehicleLocationDict];
        }
        
        [self downloadVehiclesFromLocalStorage];
        
    } failure:^(NSError *error) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self downloadVehicleLocationsFromServer];
        });
        
        NSLog(@"%@", error);
    }];
}

- (void)clearData {
    
    [[DataProvider sharedInstance] clearVehicleLocations];
    
    [self.mapView setSelectedMarker:nil];
    
    for (GMSMarker *marker in self.markers) {
        
        marker.map = nil;
    }
    
    [self.markers removeAllObjects];
    [self.vehicleLocations removeAllObjects];
}

#pragma mark - Google Maps

- (void)loadMap {
    
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectZero];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.settings.myLocationButton = YES;
    self.view = self.mapView;
}

- (void)setupMarkers {
    
    for (VehicleLocation *vehicleLocation in self.vehicleLocations) {
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(vehicleLocation.lat, vehicleLocation.lon);
        marker.map = self.mapView;
        
        NSMutableDictionary *userData = [NSMutableDictionary new];
        
        [userData setObject:vehicleLocation.vehicleid forKey:@"vehicleid"];
        
        marker.userData = userData;
        
        [self.markers addObject:marker];
    }
}

- (void)setupCamera {
    
    GMSMarker *marker = [self.markers firstObject];
    
    if (marker) {
        
        if (self.isLoadedCamera) { return; }
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                                longitude:marker.position.longitude
                                                                     zoom:12];
        
        [self.mapView animateToCameraPosition:camera];
        
        self.isLoadedCamera = YES;
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    self.polyline.map = nil;
    
    if (mapView.selectedMarker == marker) {
        
        [mapView setSelectedMarker:nil];
    } else {
        
        self.tappedMarker = YES;
        [mapView setSelectedMarker:marker];
        
        if ([marker.userData isKindOfClass:[NSDictionary class]]) {
            
            NSNumber *vehicleid = [(NSDictionary *)marker.userData valueForKey:@"vehicleid"];
            
            Vehicle *vehicle = [[DataProvider sharedInstance] getVehicleWithVehicleid:vehicleid];
            
            [self getPolylineFromSource:self.mapView.myLocation toDestination:vehicle.vehicleLocation.location completion:^(GMSPolyline *polyline, NSError *error) {
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    self.polyline = polyline;
                    self.polyline.strokeColor = [UIColor blueColor];
                    self.polyline.strokeWidth = 3.f;
                    self.polyline.map = self.mapView;
                }
            }];
        }
    }
    
    return YES;
}

- (nullable UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    MarkerView *markerView = [[MarkerView alloc] init];
    
    if ([marker.userData isKindOfClass:[NSDictionary class]]) {
        
        NSNumber *vehicleid = [(NSMutableDictionary *)marker.userData valueForKey:@"vehicleid"];
        NSString *address = [(NSMutableDictionary *)marker.userData valueForKey:@"address"];
        
        if (address) {
            markerView.markerDescriptionLabel.text = address;
        } else {
            [self setupAddressFromMarkerInfoWindow:marker];
        }
        
        Vehicle *vehicle = [[DataProvider sharedInstance] getVehicleWithVehicleid:vehicleid];
        
        markerView.vehicle = vehicle;
        
        if (NO == self.tappedMarker) {
            
            [markerView.markerImageView setImageWithURL:[NSURL URLWithString:vehicle.vehicleLocation.vehicle.foto]];
            NSLog(@"foto = %@", vehicle.vehicleLocation.vehicle.foto);
        } else {
            
            [markerView.markerImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:vehicle.vehicleLocation.vehicle.foto]]
                                              placeholderImage:nil
                                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                           
                                                           self.tappedMarker = NO;
                                                           [markerView.markerImageView setImage:image];
                                                           [mapView setSelectedMarker:nil];
                                                           [mapView setSelectedMarker:marker];
                                                       }
                                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                           
                                                           NSLog(@"%@", error.localizedDescription);
                                                       }];
        }
    }
    
    return markerView;
}

- (void)setupAddressFromMarkerInfoWindow:(GMSMarker *)marker {
    
    if ([marker.userData isKindOfClass:[NSDictionary class]]) {
        
        NSNumber *vehicleid = [(NSMutableDictionary *)marker.userData valueForKey:@"vehicleid"];
        
        Vehicle *vehicle = [[DataProvider sharedInstance] getVehicleWithVehicleid:vehicleid];
        
        [AddressHelper addressWithLocation:vehicle.vehicleLocation.location completionHandler:^(NSString *address, NSError *error) {
            
            if (address) {
                
                [(NSMutableDictionary *)marker.userData setObject:address forKey:@"address"];
            }
            
            self.tappedMarker = NO;
            [self.mapView setSelectedMarker:nil];
            [self.mapView setSelectedMarker:marker];
        }];
    }
}

#pragma mark - Route

- (void)getPolylineFromSource:(CLLocation *)sourceLocation toDestination:(CLLocation *)destinationLocation completion:(void (^)(GMSPolyline *polyline, NSError *error))completion {
    
    [[NetworkManager sharedInstance] getDirectionsWithFromSource:sourceLocation toDestination:destinationLocation success:^(NSDictionary *result) {
        
        GMSMutablePath *path = [GMSMutablePath path];
        
        NSArray *routes = [result objectForKey:@"routes"];
        
        if (routes.count < 1) {
            
            return;
        }
        
        NSDictionary *firstRoute = routes.firstObject;
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] firstObject];
        
        NSArray *steps = [leg objectForKey:@"steps"];
        
        int stepIndex = 0;
        
        CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
        
        for (NSDictionary *step in steps) {
            
            NSDictionary *start_location = [step objectForKey:@"start_location"];
            stepCoordinates[++stepIndex] = [self.class coordinateWithLocation:start_location];
            [path addCoordinate:[self.class coordinateWithLocation:start_location]];
            
            NSString *polyLinePoints = [[step objectForKey:@"polyline"] objectForKey:@"points"];
            GMSPath *polyLinePath = [GMSPath pathFromEncodedPath:polyLinePoints];
            for (int p=0; p<polyLinePath.count; p++) {
                [path addCoordinate:[polyLinePath coordinateAtIndex:p]];
            }
            
            
            if ([steps count] == stepIndex){
                NSDictionary *end_location = [step objectForKey:@"end_location"];
                stepCoordinates[++stepIndex] = [self.class coordinateWithLocation:end_location];
                [path addCoordinate:[self.class coordinateWithLocation:end_location]];
            }
        }
        
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor blueColor];
        polyline.strokeWidth = 3.f;
        
        completion(polyline, nil);
        
    } failure:^(NSError *error) {
        
        completion(nil, error);
    }];
}

+ (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

@end
