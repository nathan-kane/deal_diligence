const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events

exports.deleteTrxnNotification = functions.firestore
    .document("/company/{companyId}/trxns/{trxnsId}")
    .onDelete((snapshot, context) => {
      const newData = snapshot.data();
      const trxn = context.params.trxnsId;
      const payload = {
        notification: {
          title: String(newData.title),
          body: String(newData.body),
        },
        topic: trxn,
      };
      return admin.messaging().send(payload);
    });

