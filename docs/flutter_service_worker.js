'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "85a75204c06a3959f40426ffbfb30215",
"/main.dart.js": "a09d31b0d212e6059e6775866ea17735",
"/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/manifest.json": "e589d0037cf6fba8f450d71470566cab",
"/assets/LICENSE": "7596ab3f3d453927cd4f78e30314d82f",
"/assets/AssetManifest.json": "d1c794a2205804ab3ca1c9f75d9d2b3c",
"/assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/assets/images/icons8-neutral.png": "f5acac50c5c6cc9ef1bb34dec8d1feb6"
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
