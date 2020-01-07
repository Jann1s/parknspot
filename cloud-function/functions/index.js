const functions = require('firebase-functions');
const admin = require('firebase-admin');
const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyAcEYs5nXBC0DlNxZzneG_bLm_W4ZDwf4g',
    Promise: Promise
  });

admin.initializeApp();

// This will create a User document with the onCreate trigger of Firebase Authentication

exports.createUser = functions.auth.user().onCreate((user) => {
    let mail = user.email;
    let time = Date.now();

    admin.firestore().collection('users').add(
        {
            email: mail,
            timestamp: time
        });
});

// This will delete a User document with the onDelete trigger of Firebase Authentication
exports.deleteUser = functions.auth.user().onDelete((user) => {
    let mail = user.email;
    var doc = admin.firestore().collection('users').where('email','==', mail);

    doc.get().then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
          doc.ref.delete();
        });
      });
});


/**
 * Enter user id, latitude and longitude as parameter using the https request below to alter the last location of the user 
 * Updates timestamp when the location is set
 */
//https://us-central1-parknspot-262413.cloudfunctions.net/setLocation?lat=(latitude goes here)&lon=(longitude goes here)&user=(user id goes here)
exports.setLocation = functions.https.onRequest(async (req,res) =>{
    
    let latitude = parseFloat(req.query.lat);
    let longitude = parseFloat(req.query.lon);
    
    let location = {
        google: new admin.firestore.GeoPoint(latitude,longitude)
    }
    let time = Date.now();

    const snapshot = await admin.firestore().collection('/users').doc(req.query.user).update(
        {
            location: location,
            timestamp: time
        });
        res => {
            console.log(res);
          },
          err => {
            console.log("Error occured");
          }
          return;
}); 
/**
 * Enter parking id and availability
 * Updates timestamp when availability is changed
 */
//https://us-central1-parknspot-262413.cloudfunctions.net/setAvailability?parking=(parking id goes here)&availability=(availability goes here)
exports.setAvailability = functions.https.onRequest(async (req,res) =>{

    let availability = req.query.availability;
    let time = Date.now();

    const snapshot = await admin.firestore().collection('/locations').doc(req.query.parking).update(
        {
            availability: availability,
            timestamp: time
        });
        res => {
            console.log(res);
          },
          err => {
            console.log("Error occured");
          }
          return;
}); 
/**
 * Enter search radius and cordinates
 * Returns list of parking objects in json
 */
//https://us-central1-parknspot-262413.cloudfunctions.net/getParkingLocations?rad=(search radius goes here)l&at=(latitude goes here)&lon=(longitude goes here)
exports.getParkingLocations = functions.https.onRequest(async (req,res) => {
    var radius = parseFloat(req.query.rad);
    var lat = parseFloat(req.query.lat); 
    var lon = parseFloat(req.query.lon);
    googleMapsClient.placesNearby({
        language: 'en',
        location: [lat,lon],
        radius: radius,
        opennow: true,
        type: 'parking'
      }).asPromise().then((response) => {
        console.log(response.json)
      })
      .catch(err => console.log(err));
});

