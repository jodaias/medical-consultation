importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBkD7rgOQ7PWaCbEPJ-nGqM5kTR3Ph_k3E",
  authDomain: "medical-consultation-5b148.firebaseapp.com",
  projectId: "medical-consultation-5b148",
  storageBucket: "medical-consultation-5b148.firebasestorage.app",
  messagingSenderId: "565832427919",
  appId: "1:565832427919:web:a6701494f80cd8722483fa"
});

const messaging = firebase.messaging();
