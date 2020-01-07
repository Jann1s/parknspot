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

exports.deleteUser = functions.auth.user().onDelete(user)
    .document('users/{uid}')
    ((snap) => {
        return admin.auth().deleteUser(snap.id)
            .then(() => console.log('Deleted user with ID:' + snap.id))
            .catch((error) => console.error('There was an error while deleting user:', error));
    });
