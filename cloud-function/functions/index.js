const functions = require('firebase-functions');
const admin = require('firebase-admin');
const bcrypt = require('./custom-bcrypt');
const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyAcEYs5nXBC0DlNxZzneG_bLm_W4ZDwf4g',
    Promise: Promise
  });
const queryOverpass = require('@derhuerst/query-overpass');
const { GeoCollectionReference, GeoFirestore, GeoQuery, GeoQuerySnapshot } = require('geofirestore');

// Create a GeoCollection reference

admin.initializeApp();
admin.firestore().settings( { timestampsInSnapshots: true });

//Testing geofirestore
const geofirestore = new GeoFirestore(admin.firestore());
const geocollection = geofirestore.collection('/locations');



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

//Create Business User
exports.createBusinessUser = functions.https.onRequest(async (req, res) => {
  res.set('Content-Type', 'application/json');

  console.log(req.body.data);
  
  let timestamp = admin.firestore.FieldValue.serverTimestamp();
  let business = req.body.data.name;
  let apiKey = bcrypt.hash(business.concat(timestamp.toString()), {salt: Math.random().toString(36).substring(2, 15), rounds: 10});
  let lat = req.body.data.lat;
  let lon = req.body.data.lon;

  //Check if all required parameters are set
  if(business && lat && lon)
  {
    lat = parseFloat(lat);
    lon = parseFloat(lon);

    //Check if latitude and longitude are numbers
    if(lat != NaN && lon != NaN && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180)
    {
      let geo_point = new admin.firestore.GeoPoint(lat,lon);

      //Create business User
      admin.firestore().collection('/business').add(
      {
        'name': business,
        'location': geo_point,
        'API': apiKey,
        'timestamp': timestamp       
      }).then(function() {

        let queryLocation = admin.firestore().collection('/locations').where('location','==', geo_point);
        queryLocation.limit(1).get().then(querySnapshot => 
        {
          if(querySnapshot.empty)
          {
            //Create location
            admin.firestore().collection('/locations').add(
              {
                'availability': 1,
                'location': geo_point,
                'timestamp': timestamp       
              }
            ).then(function(){
              res.send ({
                'Code' : 100,
                'Status' : 'Success - Business User and Location created',
                'API-KEY' : apiKey
              })
            }).catch(function(error){
              res.send({
                data: {
                  'Code' : 200,
                  'Status' : 'Error - Business User created but failed to create new Location',
                  'API-KEY' : apiKey
                }
              });
              console.log(error);
            })
          }
          else{
            res.send ({
              'Code' : 100,
              'Status' : 'Success - Business User created',
              'API-KEY' : apiKey
            })
          }
        })
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

// Update Business user parking availability
exports.updateBusinessUserAvailability = functions.https.onRequest(async (req, res) => {
  res.set('Content-Type', 'application/json');

  let apiKey = req.body.data.apiKey;
  let availability = req.body.data.availability;
  let timestamp = admin.firestore.FieldValue.serverTimestamp();
  let queryBusinessUser = admin.firestore().collection('/business').where('API','==', apiKey);  
  
  availability = parseInt(availability);

  if(availability != NaN && availability <= 4 && availability >= 0)
  {
    queryBusinessUser.limit(1).get().then(querySnapshot =>
      {
        //Check if user with the requested API exist
        if(!querySnapshot.empty)
        {
          let geo_point = querySnapshot.docs[0].get('location');
          let queryLocation = admin.firestore().collection('/locations').where('location','==', geo_point);
          queryLocation.limit(1).get().then(querySnapshot =>
          {
            //Check if requested location exists
            if(!querySnapshot.empty)
            {
              let docIdLocations = querySnapshot.docs[0].id;
              //Update availability
              admin.firestore().collection('locations').doc(docIdLocations).update(
                {
                  availability: availability,
                  timestamp: timestamp
                }
              //If editing location document was succesful
              ).then(function(){
                  res.send({
                    data: {
                      'Code' : 100,
                      'Status' : 'Success - Location Availability updated'
                    }
                  });
                }).catch(function(error) {
                  res.send({
                    data: {
                      'Code' : 200,
                      'Status' : 'Error - Availability was not updated'
                    }
                  });
                  console.log(error);
                });
                //If location does not exist yet
            }else{
              //Create new location
              admin.firestore().collection('/locations').add({
                'availability' : availability,
                'location' : geo_point,
                'timestamp' : timestamp
              }).then(function() {
                res.send({
                  data: {
                    'Code': 100,
                    'Status': 'Success - Location Document created'
                  }
                });
              }).catch(function(error) {
                res.send({
                  data: {
                    'Code' : 200,
                    'Status' : 'Error - Location Document was not created'
                  }
                });
                console.log(error);
                });
              }
            });    
        }else{
          res.send({
            data: {
              'Code' : 200,
              'Status' : 'Incorrect API-Key - User not found'
            }
          });
        } 
      }); 
  }else{
    res.send({
      data: {
        'Code' : 200,
        'Status' : 'Incorrect Parameter - The Availability value has to be a number between 0 and 4'
      }
    });
  }   
});

// Delete Business user
exports.deleteBusinessUser = functions.https.onRequest((req, res) => {
  res.set('Content-Type', 'application/json');

  let apiKey = req.body.data.apiKey;
  let query = admin.firestore().collection('/business').where('API','==', apiKey);

  query.limit(1).get().then(querySnapshot => {
    //Check if Business User exists
    if(!querySnapshot.empty)
    {
      let docId = querySnapshot.docs[0].id;
      admin.firestore().collection('business').doc(docId).delete()
      .then(function(){
        res.send({
          data: {
            'Code': 100,
            'Status': 'Success - User deleted'
          }
        });
      }).catch(function(error){
        res.send({
          data: {
            'Code' : 200,
            'Status' : 'Error - User was not deleted'
          }
        });
        console.log(error);
      });
    }
    else{
      res.send({
        data: {
          'Code': 202,
          'Status': 'Incorrect API-Key - User not found'
        }
      });
    }
  })  
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

      if(lat != NaN && lon != NaN && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180)
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

  if(Number.isInteger(availability) && lat && lon)
  {
    if(context.auth){
      lat = parseFloat(lat);
      lon = parseFloat(lon);
      
      if(lat != NaN && lon != NaN && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180)
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
/* How to add a geoobject
  geocollection.add({
    name: 'Geofirestore',
    score: 100,
    // The coordinates field must be a GeoPoint!
    coordinates: new firebase.firestore.GeoPoint(40.7589, -73.9851)
  })
*/
  var rad = data.radius;
  var lat = data.latitude; 
  var lon = data.longitude;
  var parkingSpots = [];

  if(context.auth){
    if(rad && lat && lon)
    {
      rad = parseFloat(rad);
      lat = parseFloat(lat); 
      lon = parseFloat(lon);

      if(rad != NaN && lat != NaN && lon != NaN)
      {

        const getDataAsync = [];
        getDataAsync.push(
          googleMapsClient.placesNearby({
            language: 'en',
            location: [lat,lon],
            radius: rad,
            opennow: true,
            type: 'parking'
          })
          .asPromise().then((response) => {
            response.json.results.forEach(result => {
              parkingSpots.push({  
                'lat' : result.geometry.location.lat,
                'lon' : result.geometry.location.lng,
                'name' : result.name
              });
            });
            console.log(response.json.results);
            console.log('gm done');
          })
          .catch(function(error) {
            console.error(error);
          })
        );
        getDataAsync.push(
          queryOverpass(`
            [out:json][timeout:25];
            node
                (around: `+rad+`,`+lat+`, `+lon+`)
                ["amenity"="parking"];
            out body;
          `)
          .then((response)=>{
            response.forEach(result => {
              parkingSpots.push({
                'lat' : result.lat,
                'lon' : result.lon,
                'name' : result.tags.name || null,
                'capacity' : result.tags.capacity || null
              });
            });
            console.log(response);
            console.log('osm done');
            })
            .catch(function(error) {
              console.error(error);
          })
        );
        getDataAsync.push(
          // Get query (as Promise)
          geocollection.near({ center: new admin.firestore.GeoPoint(lat, lon), radius: rad 
          }).get().then((result) => {
            if(!result.docs.empty){
              result.docs.forEach(doc => {              
                parkingSpots.push({
                  'lat' : doc.data().coordinates.latitude,
                  'lon' : doc.data().coordinates.longitude,
                  'availability' : doc.data().availability
                });
              })
              console.log(result.docs);
              console.log('firestore done');
            }else{
              console.log('empty docs');
            }
          // All GeoDocument returned by GeoQuery, like the GeoDocument added above

          }).catch(function(error){
            console.log(error);
          })
        );
        // waits for all async operations in array to finish and returns the response
        return Promise.all(getDataAsync).then( () => {
          if(parkingSpots.length > 0){
            return {
              'Code' : 100,
              'Status' : 'Success',
              'Results' : parkingSpots
            }
          }else{
            return {
              'Code' : 200,
              'Status' : 'Error, try again later'
            }
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


