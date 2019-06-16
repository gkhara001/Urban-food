//
//  DetailsFoodViewController.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class DetailsFoodViewController: UIViewController {
    
    @IBOutlet weak var detailsFoodView: DetailsFoodView?

    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateView() {
        if let viewModel = viewModel {
            detailsFoodView?.priceLabel?.text = viewModel.price
            detailsFoodView?.hoursLabel?.text = viewModel.isOpen
            detailsFoodView?.locationLabel?.text = viewModel.phoneNumber
            detailsFoodView?.ratingsLabel?.text = viewModel.location.address1! + ", " + viewModel.location.city!
            detailsFoodView?.collectionView?.reloadData()
            centerMap(for: viewModel.coordinate)
            title = viewModel.name
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsFoodView?.mapView?.addAnnotation(annotation)
        detailsFoodView?.mapView?.setRegion(region, animated: true)
    }
}

extension DetailsFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailsCollectionViewCell
        if let url = viewModel?.imageUrls[indexPath.item] {
            cell.imageView?.af_setImage(withURL: url)
        }
        cell.restName?.text = viewModel?.name
        cell.restRating?.text = viewModel?.rating
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsFoodView?.pageControl?.currentPage = indexPath.item
    }
    

    
}
