const functions = require('firebase-functions');
const admin = require('firebase-admin');
const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyAcEYs5nXBC0DlNxZzneG_bLm_W4ZDwf4g',
    Promise: Promise
  });
const queryOverpass = require('@derhuerst/query-overpass');

admin.initializeApp();
admin.firestore().settings( { timestampsInSnapshots: true });

// This will create a User document with the onCreate trigger of Firebase Authentication

exports.createUser = functions.auth.user().onCreate((user) => {
  let mail = user.email;
  let timestamp = admin.firestore.FieldValue.serverTimestamp();

  admin.firestore().collection('users').add(
  {
    'email': mail,
    'timestamp': timestamp
  }).catch(function(error){
    console.error('Failed to add user! email: ' + mail);
    console.error(error);
  });
});

// This will delete a User document with the onDelete trigger of Firebase Authentication
exports.deleteUser = functions.auth.user().onDelete((user) => {
    let mail = user.email;
    var doc = admin.firestore().collection('users').where('email','==', mail);

    doc.get().then(function(querySnapshot) {
      querySnapshot.forEach(function(doc) {
        doc.ref.delete().catch(function(error){
          console.error('Failed to delete user! user.id: ' + user.id);
        });
      });
    }).catch(function(error) {
      console.error('Failed to get user! email:' + mail);
    });
});

exports.createBusinessUser = functions.https.onRequest((req, res) => {
    let apiKey = req.query.apikey;
    let business = req.query.name;
    let timestamp = admin.firestore.FieldValue.serverTimestamp();
    let latitude = parseFloat(req.query.lat);
    let longitude = parseFloat(req.query.lon);
    let location = {
        google: new admin.firestore.GeoPoint(latitude,longitude)
    };

    admin.firestore().collection('business').add(
    {
        'name' : business,
        'parkingLocation' : location,
        'API' : apiKey,
        'timestamp' : timestamp       
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
    let timestamp = admin.firestore.FieldValue.serverTimestamp();

    admin.firestore().collection('locations').doc(docIdLocations).update(
    {
        'availability' : availability,
        'timestamp' : timestamp
    }),
    admin.firestore().collection('business').doc(docIdBusiness).update(
        {
            'timestamp': timestamp
        }
    );    
    res => {
        console.log(res);
    }
    return;
});

/*
Input parameters:
  context.auth.token : firebase.auth.DecodedIdToken
Output parameters:
  - Status : string
  - Code : int
  - Result : bool, optional
What it does:
  Auth user
  Find user doc
  Check if location exists in doc, return true, false
*/
exports.isLocationSet = functions.https.onCall((data, context) =>{
  // Auth user
  if(context.auth)
  {
    let userEmail = context.auth.token.email;
    console.log(userEmail);
    // Find user doc
    let query = admin.firestore().collection('/users').where('email','==', userEmail);

    return query.limit(1).get().then(querySnapshot => 
    {
      let userDoc = querySnapshot.docs[0];
      // Check if location exists in doc, return true, false
      let location = userDoc.get('location');
      if(typeof location !== 'undefined' && location){
        console.log('Location found');
        return {
          'Code' : 100,
          'Status' : 'Success',
          'Result' : true
        };
      }else{
        console.log('Location not found')
        return {
          'Code' : 100,
          'Status' : 'Success',
          'Result' : false
        };
      }
    }).catch(function (error){
      console.error(error);
      return {
        'Code' : 200,
        'Status' : 'Error, try again later'
      };
    });
  }else{
    console.log('Unauth user');
    return {
      'Code' : 201,
      'Status': 'Incorrect parameters'
    };
  }
});

/*
Input parameters:
  - context.auth.token : firebase.auth.DecodedIdToken
  - lat : float
  - lon : float
Output parameters:
  - Status : string
  - Code : int
*/
exports.setLocation = functions.https.onCall((data,context) => {
  let lat = data.lat;
  let lon = data.lon;

  if(lat && lon)
  {
    if(context.auth)
    {
      lat = parseFloat(lat);
      lon = parseFloat(lon);

      if(lat != NaN && lon != NaN)
      {
        let location = new admin.firestore.GeoPoint(lat,lon);
        let timestamp = admin.firestore.FieldValue.serverTimestamp();
        let mail = context.auth.token.email;

        let query = admin.firestore().collection('/users').where('email','==', mail);
        return query.limit(1).get().then(querySnapshot => 
        {
          if(!querySnapshot.empty){
            let doc_id = querySnapshot.docs[0].id;
            return admin.firestore().collection('/users').doc(doc_id).update({
              'location' : location,
              'timestamp' : timestamp
            }).then(function() {
              console.log('Success');
              return {
                'Code' : 100,
                'Status' : 'Success'
              }  
            }).catch(function(error) {
              console.log(error);
              return{
                'Code' : 200,
                'Status' : 'Error, try again later'
              }
            });
          }
        });
      }else{
        return{
          'Code': 202,
          'Status': 'Incorrect lat or lon'
        }
      }
    }else{
      console.log('Unauth user');
      return{
        'Code': 201,
        'Status': 'Incorrect parameters'
      }  
    }
  }else{
    return{
      'Code': 201,
      'Status': 'Incorrect parameters'
    }  
  }
});

/*
Input parameters:
  - context.auth.token : firebase.auth.DecodedIdToken 
Output parameters:
  - Status : string
  - Code : int
*/
exports.unSetLocation = functions.https.onCall((data,context) => {

  if(context.auth){
    let timestamp = admin.firestore.FieldValue.serverTimestamp();
    let mail = context.auth.token.email;

    let query = admin.firestore().collection('/users').where('email','==', mail);
    return query.limit(1).get().then(querySnapshot => 
    {
      if(!querySnapshot.empty)
      {
        let doc_id = querySnapshot.docs[0].id;
        let location = querySnapshot.docs[0].get('location');

        return admin.firestore().collection('/users').doc(doc_id).update({
          'location' : admin.firestore.FieldValue.delete(),
          'timestamp' : timestamp
        }).then(function() {
          let query = admin.firestore().collection('/locations').where('location','==', location);
          return query.limit(1).get().then(querySnapshot => 
          {
            if(querySnapshot.empty){
              return admin.firestore().collection('/locations').add({
                'availability': 1,
                'location' : location,
                'timestamp': timestamp,
                'userRef': admin.firestore().collection('/users').doc(doc_id)
              }).then(function(){
                return { 
                  'Code' : 100,
                  'Status' : 'Success'
                }
              }).catch(function(error){
                return { 
                  'Code' : 200,
                  'Status' : 'Error, try again later'
                }
              })
            }else{
              let doc_id = querySnapshot.docs[0].id;
              return  admin.firestore().collection('/locations').doc(doc_id).update({
                'availability' : 1,
                'location' : location,
                'timestamp' : timestamp,
                'userRef': admin.firestore().collection('/users').doc(doc_id)
              }).then(function() {
                return {
                  'Code' : 100,
                  'Status' : 'Success'
                }
              }).catch(function(error) {
                console.error(error);
                return {
                  'Code' : 200,
                  'Status' : 'Error, try again later'
                }
              });
            }
          });
        }).catch(function(error) {
          console.log(error);
          return{
            'Code' : 200,
            'Status' : 'Error, try again later'
          }
        });
      }
    }).catch(function(error) {
      console.log(error);
      return{
        Code : 200,
        Status : 'Error, try again later'
      }
    });

  }else{
    console.log('Unauth user');
    return {
      'Code' : 201,
      'Status' : 'Incorrect parameters'
    }
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
exports.setAvailability = functions.https.onCall((data, context) => {
  let availability = data.availability;
  let lat = data.lat;
  let lon = data.lon;
console.log(availability + ',[' + lat + ',' + lon + ']');
  if(Number.isInteger(availability) && lat && lon)
  {
    if(context.auth){
      lat = parseFloat(lat);
      lon = parseFloat(lon);

      if(lat != NaN && lon != NaN)
      {
        let geo_point = new admin.firestore.GeoPoint(lat,lon);
        let timestamp = admin.firestore.FieldValue.serverTimestamp();
        let email = context.auth.token.email;
        
        let query = admin.firestore().collection('/users').where('email', '==', email);
        return query.limit(1).get().then(querySnapshot => {
          let user_doc_id = querySnapshot.docs[0].id;

          let query = admin.firestore().collection('/locations').where('location','==', geo_point);
          return query.limit(1).get().then(querySnapshot => 
          {
            if(!querySnapshot.empty){
              let location_doc_id = querySnapshot.docs[0].id;
              return admin.firestore().collection('/locations').doc(location_doc_id).update({
                'availability' : availability,
                'location' : geo_point,
                'timestamp' : timestamp,
                'userRef' : admin.firestore().collection('/users').doc(user_doc_id)
              }).then(function() {
                return {
                  "Code": 100,
                  "Status": "Success"
                }
              }).catch(function(error) {
                console.error(error);
                return {
                  'Code' : 200,
                  'Status' : 'Error, try again later'
                }
              });
            }else{
              return admin.firestore().collection('/locations').add({
                'availability' : availability,
                'location' : geo_point,
                'timestamp' : timestamp,
                'userRef' : admin.firestore().collection('/users').doc(user_doc_id)
              }).then(function() {
                return {
                  'Code': 100,
                  'Status': 'Success'
                }
              }).catch(function(error) {
                console.error(error);
                return {
                  'Code' : 200,
                  'Status' : 'Error, try again later'
                }
              });
            }
          });
        }).catch(function(error) {
          console.log(error);
          return {
            'Code' : 200,
            'Status' : 'Error, try again later'
          }
        });
      }else{
        return {
          'Code': 202,
          'Status': 'Incorrect lat or lon'
        }
      }
    }else{
      console.log('Unauth user');
      return {
        'Code' : 201,
        'Status': 'Incorrect parameters'
      }
    }
  }else{
    return {
      'Code' : 201,
      'Status': 'Incorrect parameters'
    }
  }
});

//TODO: get user id and set as reference
/*
Input parameters:
  - radius : int
  - lat : float
  - lon : float
Output parameters:
  - Status : string
  - Code : int
*/
exports.getParkingLocations = functions.https.onCall((data,context) => {
  var rad = data.radius;
  var lat = data.latitude; 
  var lon = data.longitude;

  if(context.auth){
    if(rad && lat && lon)
    {
      rad = parseFloat(rad);
      lat = parseFloat(lat); 
      lon = parseFloat(lon);

      if(rad != NaN && lat != NaN && lon != NaN)
      {
        return googleMapsClient.placesNearby({
          language: 'en',
          location: [lat,lon],
          radius: rad,
          opennow: true,
          type: 'parking'
        }).asPromise().then((response) => {
          return {
            'Code' : 100,
            'Status': 'Success',
            'Places': response.json
          }
          /* 
          return queryOverpass(`
            [out:json][timeout:25];
            node(413536);
            out body;
          `)
          .then(console.log)
          .catch(console.error)
          */
        })
        .catch(function(error) {
          console.error(error);
          return {
            'Code' : 200,
            'Status' : 'Error, try again later'
          }
        });
      }else{
        console.log('Parameters not numbers');
        return {
          'Code' : 201,
          'Status' : 'Incorrect parameters'
        }
      }
    }else{
      console.log('Missing parameters');
      return {
        'Code' : 201,
        'Status' : 'Incorrect parameters'
      }
    }
  }else{
    console.log('Unauth user');
    return {
      'Code' : 201,
      'Status' : 'Incorrect parameters'
    }
  }
});
