const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.updateTrxnNotification = functions.firestore
    .document("company/{companyId}/trxns/{trxnsId}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();
      const documentId = context.params.documentId;

      // // Access other fields as needed from newValue

      // // Constructing the notification payload
      const payload = {
        notification: {
          title: "Document Updated",
          body: "Document ${documentId} has been updated.",
        },
        // You can add additional data fields as needed
        data: {
          documentId: documentId,
        },
      };

      // // Get the device token from your Firestore document
      const deviceToken = newValue.deviceToken;

      // Send the notification
      return admin.messaging().send(deviceToken, payload);
    });


