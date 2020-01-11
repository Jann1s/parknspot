
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

exports.createBusinessUser = functions.https.onRequest((req, res) => {
    let apiKey = req.query.apikey;
    let business = req.query.name;
    let timestamp = Date.now();
    let latitude = parseFloat(req.query.lat);
    let longitude = parseFloat(req.query.lon);
    let location = {
        google: new admin.firestore.GeoPoint(latitude,longitude)
    };

    admin.firestore().collection('business').add(
        {
            name: business,
            parkingLocation: location,
            API: apiKey,
            timestamp:timestamp       
        });
        
        res => {
            console.log(res);
        }
    return;
});

// Update Business user parking availability
//Example: https://us-central1-parknspot-262413.cloudfunctions.net/updateBusinessUserAvailability?docidbusiness=ectB0FVLGonCqb7i5OAW&docidlocations=lv4nzaIGodi0BaoKD6v1&availability=FULL
exports.updateBusinessUserAvailability = functions.https.onRequest((req, res) => {
    let docIdBusiness = req.query.docidbusiness;
    let docIdLocations = req.query.docidlocations;
    let availability = req.query.availability;
    let timestamp = Date.now();

    admin.firestore().collection('locations').doc(docIdLocations).update(
        {
            availability: availability,
            timestamp: timestamp
        }
    ),
    admin.firestore().collection('business').doc(docIdBusiness).update(
        {
            timestamp: timestamp
        }
    );    
    res => {
        console.log(res);
    }
    return;
});

//TODO: get user id and set as reference
/*
Input parameters:
  - lat : float
  - lon : float
Output parameters:
  - Status : string
  - Code : int
*/

exports.setLocation = functions.https.onCall((data,context) => {
  let lat = data.latitude;
  let lon = data.longitude;

  if(!lat && !lon)
  {
    return{
    Code: 201,
    Status: 'Incorrect parameters'
    }
    
  }else{
    if(lat != NaN && lon != NaN){
      return{
        Code: 202,
        Status: 'Incorrect lat or lon'
      }
    }else{
      if(!context.auth){
        return{ 
          Code : 201,
          Status : 'Incorrect parameters'
        }          
      }else{
        let location = {
          google: new admin.firestore.GeoPoint(lat,lon)
        }
        let time = Date.now();
        const mail = context.auth.token.email || null;

        let query = admin.firestore().collection('/users').where('email','==', mail);
        query.limit(1).get().then(querySnapshot => 
          {
            if(!querySnapshot.empty){
              let doc_id = querySnapshot.docs[0].id;
              return admin.firestore().collection('/users').doc(doc_id).update({
                location : location,
                timestamp : time
              }).then(function() {
                  let query = admin.firestore().collection('/locations').where('location','==', location);
                    query.limit(1).get().then(querySnapshot => 
                    {
                      if(querySnapshot.empty){
                        return admin.firestore().collection('/locations').set({
                          availability: 1,
                          location : location,
                          timestamp: time
                        }).then(function(){
                          return{ 
                            Code : 100,
                            Status : 'Success'
                          }
                        }).catch(function(error){
                          return{ 
                            Code : 200,
                            Status : 'Error, try again later'
                          }
                        })
                      }else{
                        /**
                         * IDK
                         */
                      }
                    });
                        
              }).catch(function(error) {
                return{
                  Code : 200,
                  Status : 'Error, try again later'
                }
              });
            }
          });
    
      } 
    }
  }

});

//TODO: get user id and set as reference
/*
Input parameters:
  - NOTHING 
Output parameters:
  - Status : string
  - Code : int
*/
exports.unSetLocation = functions.https.onCall((data,context) => {
    if(!context.auth){
      return{ 
        Code : 201,
        Status : 'Incorrect parameters'
      }               
    }else{
      let time = Date.now();
      const mail = context.auth.token.email || null;

      let query = admin.firestore().collection('/users').where('email','==', mail);
      query.limit(1).get().then(querySnapshot => 
        {
          if(!querySnapshot.empty){
            let doc_id = querySnapshot.docs[0].id;
            return admin.firestore().collection('/users').doc(doc_id).update({
              location : NULL,
              timestamp : time
            }).then(function() {
              return{ 
                Code : 100,
                Status : 'Success'
              }               
            }).catch(function(error) {
              return{
                Code : 200,
                Status : 'Error, try again later'
              }
            });
          }
        });
  
    } 
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
                "Code": 100,
                "Status": "Success"
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
