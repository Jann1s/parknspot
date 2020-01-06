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