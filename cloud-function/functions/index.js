const functions = require('firebase-functions');
const admin = require('firebase-admin');
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

/**
 * deleteUser gives 'user not specified' error when deploying 
 * TO BE FIXED
 */

/*
exports.deleteUser = functions.auth.user().onDelete(user)
    .document('users/{uid}')
    ((snap) => {
        return admin.auth().deleteUser(snap.id)
            .then(() => console.log('Deleted user with ID:' + snap.id))
            .catch((error) => console.error('There was an error while deleting user:', error));
    });
*/

/**
 * Enter user id, latitude and longitude as parameter using the https request below to alter the last location of the user
 * Unset location hasn't been set since it wasn't specified 
 * Updates timestamp when the location is set
 * Doesn't provide response for some reason and always times out
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
 * Availbilty is a string since in firebase I didn't find ENUM 
 * Updates timestamp when availability is changed
 * Not too sure on the information you want to send with this one but either way it works 
 * Doesn't provide response for some reason and always times out
 * I assume this is what it needs to do 
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
 * Haven't done yet 
 * Still iffy on the details are we saving the parking locations in the database 
 * I assume this just returns an array with the parkings in the specified radius 
 * But but but then how/why do we set availability if we don't save them
 * And if we do save them why? The database would be full of parking locations 
 */
exports.getParkingLocations = functions.https.onRequest(async (req,res) => {
    //TO DO 
});