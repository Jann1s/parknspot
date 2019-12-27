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