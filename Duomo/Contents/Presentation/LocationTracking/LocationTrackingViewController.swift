//
//  LocationTrackingViewController.swift
//  Duomo
//
//  Created by 승진김 on 2019/08/05.
//  Copyright © 2019 jinnify. All rights reserved.
//

import RxSwift
import RxCocoa
import MapKit


class LocationTrackingViewController: BaseViewController, BindViewType {
  
  //MARK: - Constant
  struct Constant {
    static let annotationSize = CGSize(width: 30, height: 30)
  }
  
  
  //MARK: - UI Properties
  @IBOutlet weak var mapView: MKMapView!
  
  
  
  //MARK: - Properties
  typealias ViewModel = LocationTrackingViewModel
  var disposeBag = DisposeBag()
//  var dataSource: RxTableViewSectionedReloadDataSource<SectionOfUserModel>?

  
  init(viewModel: ViewModel) {
    defer {
      self.viewModel = viewModel
    }
    super.init()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
}

//MARK: - Bind
extension LocationTrackingViewController {
  
  //OUTPUT
  func command(viewModel: LocationTrackingViewModel) {
    
    let obViewWillAppear = rx.viewWillAppear
      .map { _ in ViewModel.Command.viewWillAppear }
    
    Observable<ViewModel.Command>
      .merge([
        obViewWillAppear
      ])
      .bind(to: viewModel.command)
      .disposed(by: self.disposeBag)
  }
  
  
  //INPUT
  func state(viewModel: LocationTrackingViewModel) {
    
    viewModel.state
      .drive(onNext: { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .viewWillAppearState(latitude: let latitude, longitude: let longitude):
          self.setupMapView(latitude, longitude)
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}


//MARK: - Method Handler
extension LocationTrackingViewController {
  
  private func setupMapView(_ latitude: Double, _ longitude: Double) {
    self.mapView.delegate = self
    
    print("Latitude: \(latitude), Longitude: \(longitude)")
    
    //User1
    let user1 = UserAnnotation(title: "김승진", subtitle: "kim", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    self.mapView.addAnnotation(user1)
    //User2
    let user2 = UserAnnotation(title: "", subtitle: "park", coordinate: CLLocationCoordinate2D(latitude: 37.96762828000323, longitude: 127.15782309999993))
    self.mapView.addAnnotation(user2)
    
    
    if user2.title == "" {
      let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                     longitude: longitude),
                                      span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
      self.mapView.setRegion(region, animated: true)
    } else {
      mapView.showAnnotations([user1, user2], animated: true)
    }
    
    
  }

}


//MARK: - MKMapViewDelegate
extension LocationTrackingViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
      annotationView?.image = UIImage(named: "Profile")?.resize(to: Constant.annotationSize)
      annotationView?.backgroundColor = .white
      annotationView?.layer.cornerRadius = Constant.annotationSize.width / 2
      annotationView?.canShowCallout = true
    }
    

    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//    let location = view.annotation
//    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
////    location.mapItem().openInMaps(launchOptions: launchOptions)
//    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location!.coordinate, addressDictionary: [CNPostalAddressStreetKey: location?.subtitle]))
//    mapItem.name = location?.title ?? ""
//    mapItem.openInMaps(launchOptions: launchOptions)
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
  }
}
