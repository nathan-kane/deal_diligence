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