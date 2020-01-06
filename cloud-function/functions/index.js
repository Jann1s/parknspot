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
/*
exports.deleteUser = functions.auth.user().onDelete(user)
    .document('users/{uid}')
    ((snap) => {
        return admin.auth().deleteUser(snap.id)
            .then(() => console.log('Deleted user with ID:' + snap.id))
            .catch((error) => console.error('There was an error while deleting user:', error));
    });
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