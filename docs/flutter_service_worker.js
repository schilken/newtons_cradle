'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "85a75204c06a3959f40426ffbfb30215",
"main.dart.js": "a2012795db1bd54a52ffbb77571ca837",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "e589d0037cf6fba8f450d71470566cab",
"assets/LICENSE": "21eba787d0ae0012ae813b6a1964ccbf",
"assets/AssetManifest.json": "9a027a5277c8f614a1e3da3b8fd36840",
"assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/images/black-ball-smaller.png": "4eee2ee0aad6bdfaf8242c5640b3e4dc",
"assets/assets/images/black-ball.png": "ef642e5c12c4ecc44a219b4fbed515e9",
"assets/assets/audio/click.wav": "614fec9801d664ed68dc0feba0d0cb41",
"assets/assets/audio/billiard-tick.wav": "0aada737a76ba282fb3392f6d613ce68"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
