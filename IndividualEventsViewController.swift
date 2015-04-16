//
//  IndividualEventsViewController.swift
//  EventsApp
//
//  Created by Nick Kolasinski on 4/14/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

class IndividualEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var thisEvent = Event()
    var photosArray = [Photo]()
    
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCamera()
    }
    
    func setPhotosData()
    {
        Photo.queryForPhotos { (photos, error) -> Void in
            for photo in photos
            {
                if photo.event.objectId == self.thisEvent.objectId
                {
                    self.photosArray.append(photo)
                }
            }
            self.tableView.reloadData()
        }
    }
    func setUpCamera()
    {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
    }
    
    @IBAction func onAddButtonTabbed(sender: UIBarButtonItem)
    {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let newPhoto = Photo()
        newPhoto.imageFile = PFFile(data: UIImagePNGRepresentation(image))
        newPhoto.event = thisEvent
        newPhoto.photographer = kProfile
        newPhoto.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            self.setPhotosData()
            // Video "Adding Photos to an Event", 3:45
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as PhotoTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray.count
    }

}
