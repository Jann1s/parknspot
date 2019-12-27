const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.createUser = functions.https.onRequest((request, response) => {
    let email;

    if (request.get('content-type') == 'application/json') {
        email = request.body.email;
    }
});