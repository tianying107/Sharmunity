//
//  SYMap.h
//  Sharmunity
//
//  Created by st chen on 2017/2/9.
//  Copyright © 2017年 Sharmunity. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SYHeader.h"
@class SYMap;
@protocol SYMapDelegate <NSObject>

-(void)SYMap:(SYMap*)SYMap didSelectedSharePin:(MKAnnotationView*)placemarkPin mapItem:(MKMapItem*)mapItem;
-(void)SYMap:(SYMap*)SYMap didDeselectedSharePin:(MKAnnotationView*)placemarkPin mapItem:(MKMapItem*)mapItem;
-(void)SYMap:(SYMap*)SYMap didSelectedSearchResult:(MKMapItem*)mapItem;

@end
@interface SYMap : MKMapView<CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSMutableArray *regionCenterArray;
    UILabel *locationLabel;
    float distance;
    NSInteger pinIndex;
    NSMutableArray *placemarkArray;
    
    UIImage *selectedPin;
    UIImage *normalPin;
    
    MKAnnotationView *previousSelectedPin;
    
    /**
     *search bar view
     *the suscard show up when search button clicked
     */
    UIView *searchBarView;
    SYSuscard *searchView;
    UIButton *clearSearchButton;
    NSArray *searchResultArray;
    UITableView *resultTableView;
}


///**
// * This method used to init this class and set the location as the center point.
// * No annotation will be add to the center point.
// */
//- (id)initWithFrame:(CGRect)frame withLatitude:(float)latitude longitude:(float)longitude;
- (void)addMapItemAnnotation:(MKMapItem*)mapItem;
- (IBAction)location:(id)sender;
- (void)setLocationWithLatitude:(float)latitude longitude:(float)longitude;
- (void)removeAnnotations;
- (void)addCircleWithDistanse:(float)tdistance latitude:(float)latitude longitude:(float)longitude;
- (void)removeCircles;

@property (nonatomic, weak) id <SYMapDelegate> SYDelegate;

@property (strong, nonatomic) CLLocationManager *locationManager;

/**
 *search functions and properties
 */
- (void)setupSearchBar;
- (void)removeSearchBarViews;
- (void)searchViewShowUp;
@property UITextField *searchBar;

@end
