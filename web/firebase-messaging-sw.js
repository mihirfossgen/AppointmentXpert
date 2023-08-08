{
  
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
   apiKey: "AIzaSyCX7puGlnu_F7DeMBA86rNj4tiotpFAtAE",
   authDomain: "fhealthcare-cpas.firebaseapp.com",
   projectId: "healthcare-cpas",
   storageBucket: "healthcare-cpas.appspot.com",
   messagingSenderId: "231282522270",
   appId: "1:231282522270:ios:3f6178dc8bbca810b1638f",
   measurementId: "G-TVPC08LVQ3"
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
}