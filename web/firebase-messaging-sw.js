importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyB_8NorMVXjXUyi45K2KVKPNw7DP17Js_8",
    authDomain: "tetraconnect.firebaseapp.com",
    projectId: "tetraconnect",
    storageBucket: "tetraconnect.appspot.com",
    messagingSenderId: "821629462628",
    appId: "1:821629462628:web:1c0ff4ef254d059b185771",
    measurementId: "G-PC2P4XPQ4B"
});

const messaging = firebase.messaging();
messaging.onBackgroundMessage(function (payload) {
  console.log("Received background message ", payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "https://firebasestorage.googleapis.com/v0/b/tetraconnect.appspot.com/o/app%2Flogo.png?alt=media&token=b4855885-c37b-4cee-a773-a847bc30dd73",
  };

  if (Notification.permission === "granted") {
    new Notification(
        notificationTitle,
        {
            body: payload.notification.body,
            icon: "https://firebasestorage.googleapis.com/v0/b/tetraconnect.appspot.com/o/app%2Flogo.png?alt=media&token=b4855885-c37b-4cee-a773-a847bc30dd73",
        }
    );
  }

  self.registration.showNotification(notificationTitle, notificationOptions);
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});