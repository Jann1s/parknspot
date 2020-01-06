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

/* exports.deleteUser = functions.auth.user().onDelete(user)
    .document('users/{uid}')
    ((snap) => {
        return admin.auth().deleteUser(snap.id)
            .then(() => console.log('Deleted user with ID:' + snap.id))
            .catch((error) => console.error('There was an error while deleting user:', error));
    });
 */


// Create Business user
//Example: https://us-central1-parknspot-262413.cloudfunctions.net/createBusinessUser?apikey=sad06012020&name=sadcompany&lat=37.422&lon=122.084
exports.createBusinessUser = functions.https.onRequest((req, res) => {
    let apiKey = req.query.apikey;
    let business = req.query.name;
    let latitude = parseFloat(req.query.lat);
    let longitude = parseFloat(req.query.lon);
    let location = {
        google: new admin.firestore.GeoPoint(latitude,longitude)
    };

    admin.firestore().collection('business').add(
        {
            apiKey: apiKey,
            business: business,
            location: location
        });
        
        res => {
            console.log(res);
        }
    return;
});

// Update Business user parking availability
/* exports.updateBusinessEntry = functions.https.onRequest((req, res) => {
    let apiKey = null;
    let parkingAvailability = null;
    let time = Date.now();

    admin.firestore().collection('business').add(
        {
            timestamp: time
        });
}); */

// Delete Business user
//Example: https://us-central1-parknspot-262413.cloudfunctions.net/deleteBusinessUser?docid=ojenefuiweng
exports.deleteBusinessUser = functions.https.onRequest((req, res) => {
    let docId = req.query.docid;
    admin.firestore().collection('business').doc(docId).delete();    
    res => {
        console.log(res);
    }
    return;
});