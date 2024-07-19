importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
  apiKey: "AIzaSyDBIaLXzl5tF2QNTN58s2iPDI--GLr7bqo",
      authDomain: "deal-diligence-5de73.firebaseapp.com",
      projectId: "deal-diligence-5de73",
      storageBucket: "deal-diligence-5de73.appspot.com",
      messagingSenderId: "394692266013",
      appId: "1:394692266013:web:0b5da830c03cc9d1a51ef4",
      databaseURL: "https://deal-diligence-5de73-default-rtdb.firebaseio.com",
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();
  messaging.requestPermission()
  .then(function() {
    console.log('Notification permission granted.');

      try {
                    if (firebase.messaging.isSupported()) {
                      const messaging = firebase.messaging();
                      messaging
                        .getToken({
                          vapidKey: "BPeAY_n11fc6jVMd5deMLLHJ51ntWfW4wzt9qjh3B0KFbC5pPkR3sn3t_QRxTg3zDSCVLLtZ2kHxxvR4jL2EoNk"
                        })
                        .then((currentToken) => {
                          if (currentToken) {
                                                 subscribeTokenToTopic(currentToken,"chat");
                          }
                        })
                        .catch((err) => {
                          console.log('Error to get token', err);
                        });

                      messaging.onMessage((payload) => {
                        console.log(payload.notification)
                      });

                      // Otherwise, we need to ask the user for permission
                      if (Notification.permission !== 'granted') {
                        Notification.requestPermission();
                      }
                    } else {
                      console.log('firebase messaging not supported');
                    }
                  } catch (err) {
                    console.log(err);
                  }

  })
  .catch(function(err) {
    console.log('Unable to get permission to notify. ', err);
  });




          function subscribeTokenToTopic(token, topic) {
            fetch(`https://iid.googleapis.com/iid/v1/${token}/rel/topics/${topic}`, {
              method: 'POST',
              headers: new Headers({
                Authorization: `key=${FCM_SERVER_KEY}`
              })
            })
              .then((response) => {
                if (response.status < 200 || response.status >= 400) {
                  console.log(response.status, response);
                }
                console.log(`"${topic}" is subscribed`);
              })
              .catch((error) => {
                console.error(error.result);
              });
            return true;
          }

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });