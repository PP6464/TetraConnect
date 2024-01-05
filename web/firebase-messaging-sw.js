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
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});