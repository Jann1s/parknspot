const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// This will create a User document with the onCreate trigger of Firebase Authentication

exports.createUser = functions.auth.user().onCreate((user) => {
    let mail = user.email;
    let time = admin.database.ServerValue.TIMESTAMP;

    admin.firestore().collection('user').add(
        {
            email: email,
            timestamp: time
        });
});