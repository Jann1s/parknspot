
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyAcEYs5nXBC0DlNxZzneG_bLm_W4ZDwf4g',
    Promise: Promise
  });

admin.initializeApp();
admin.firestore().settings( { timestampsInSnapshots: true });

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

//TODO: get user id and set as reference
/*
Input parameters:
  - availability : int
  - lat : float
  - lon : float
Output parameters:
  - Status : string
  - Code : int
*/
exports.setAvailability = functions.https.onRequest(async (req,res) => {
  res.set('Content-Type', 'application/json')

  console.log(req.body.data);

  let availability = req.body.data.availability;
  let lat = req.body.data.lat;
  let lon = req.body.data.lon;

  if(availability && lat && lon)
  {
    lat = parseFloat(lat);
    lon = parseFloat(lon);
    if(lat != NaN && lon != NaN)
    {
      let geo_point = new admin.firestore.GeoPoint(lat,lon);
      // TODO: fix timestamp
      let hrtime = process.hrtime(); 
      let timestamp = new admin.firestore.Timestamp(hrtime[0],hrtime[1]);
      let query = admin.firestore().collection('/locations').where('location','==', geo_point);

      query.limit(1).get().then(querySnapshot => 
      {
        if(!querySnapshot.empty){
          let doc_id = querySnapshot.docs[0].id;
          admin.firestore().collection('/locations').doc(doc_id).update({
            'availability' : availability,
            'location' : geo_point,
            'timestamp' : timestamp
          }).then(function() {
            res.send({
              data: {
                'Code': 100,
                'Status': 'Success'
              }
            });
          }).catch(function(error) {
            res.send({
              data: {
                'Code' : 200,
                'Status' : 'Error, try again later'
              }
            });
            console.log(error);
          });
        }else{
          admin.firestore().collection('/locations').add({
            'availability' : availability,
            'location' : geo_point,
            'timestamp' : timestamp
          }).then(function() {
            res.send({
              data: {
                'Code': 100,
                'Status': 'Success'
              }
            });
          }).catch(function(error) {
            res.send({
              data: {
                'Code' : 200,
                'Status' : 'Error, try again later'
            
              }
            });
            console.log(error);
          });
        }
      });

    }
    else
    {
      res.send({
        data: {
          'Code': 202,
          'Status': 'Incorrect lat or lon'
        }
      });
    }
  }else{
    res.send({
      data: {
        'Code' : 201,
        'Status': 'Incorrect parameters'
      }
    });
  }
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

