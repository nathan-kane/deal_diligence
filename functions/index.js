const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore
    .document("chat/{messageId}")
    .onCreate((snapshot, context) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
      return admin.messaging().sendToTopic("chat", {
      // Sending a notification message.
        notification: {
          title: snapshot.data()["username"],
          body: snapshot.data()["text"],
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });

exports.newUser = functions.firestore
    .document("company/{companyId}/trxns")
    .onCreate((snapshot, context) => {
      const payload = {
        notification: {
          title: String(snapshot.title),
          body: String(snapshot.body),
        },
        topic: context.params.companyId,
      };
      return admin.messaging().send(payload);
    });

