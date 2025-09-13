'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"manifest.json": "5d6e5eb9fb52a8efa376285aa8d73869",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "f7768c7c05f09b93b1d3a8e83bf164a3",
"version.json": "ad40048c0f98ca0016a8610f4a2fe283",
"assets/NOTICES": "e2eb5fba395fc901254ca8eebac475d1",
"assets/fonts/MaterialIcons-Regular.otf": "e05b54fa8749ef87157e347fff0adc04",
"assets/AssetManifest.json": "11febe3ccd8ba0ae3c67ca04feb5c558",
"assets/assets/fonts/Montserrat-Regular.ttf": "5e077c15f6e1d334dd4e9be62b28ac75",
"assets/assets/fonts/Montserrat-Medium.ttf": "bdb7ba651b7bdcda6ce527b3b6705334",
"assets/assets/images/card_background.png": "7e3afe41aaff8b8dfcc9517e6f0a64ae",
"assets/assets/images/balance.svg": "f4cf51e46c835050dcef079846b3c1f5",
"assets/assets/images/statistics.svg": "f13e5404b60ca45df1c8e6441b5ccee2",
"assets/assets/images/fingerprintIcon.svg": "e49719da010f9c7f38c703e8b9987df6",
"assets/assets/images/calendar.svg": "cc160d76b27532cb525025c2624d316b",
"assets/assets/images/more.svg": "65487695638ff4c6bf5c997a0c35a238",
"assets/assets/images/avatar_2.svg": "a55851694c42a3fa613c85d07670e20a",
"assets/assets/images/calendarSearch.svg": "e105a4a36685810932b740797054c3ab",
"assets/assets/images/settings.svg": "5353d0691ae414182b50de229b5c6364",
"assets/assets/images/my_transctions.svg": "f1d79bc97214a58165731dacbc4a82d8",
"assets/assets/images/facebookIcon.svg": "aa433852f61fb8338db0b7534b9d2114",
"assets/assets/images/googleIcon.svg": "a8c3791ecf8e76b64d8d2ecf46798150",
"assets/assets/images/wallet_account.svg": "d1e0f75d425a17121875a496850ac569",
"assets/assets/images/income.svg": "0d993e5e9704c32576c83f86920806a4",
"assets/assets/images/weekly.svg": "16e647b3c785ba4aecfefd82664ca908",
"assets/assets/images/my_investments.svg": "7f86e73efbd6e0dda30b278773b074aa",
"assets/assets/images/expenses.svg": "7eb9375d6f94d78047a336d5c72575f8",
"assets/assets/images/logout.svg": "5397f94e5c01ee3b925dfef65629886c",
"assets/assets/images/avatar_3.svg": "274e9649a5cca76fb6cd12f1035305dc",
"assets/assets/images/gallery.svg": "a065a4afb513ce953df29730328d1cea",
"assets/assets/images/avatar_1.svg": "4ce25235ea3303e1abf6dc6cb740aab5",
"assets/assets/images/dashboard.svg": "426b10f05dece13d841ce9be1a9359b3",
"assets/assets/images/weeklySplash.gif": "b31f35373a008f8f8a06d7e33e9a0294",
"assets/assets/i18n/ar.json": "f61a48f9ae893ecec70fbc50357133dd",
"assets/assets/i18n/en.json": "c159062ceebca6ab176c37aae7a52257",
"assets/FontManifest.json": "72c73d9ad7d6bb4f1a7d6dc05bd98c4d",
"assets/AssetManifest.bin.json": "63c3f6cb5e8a61811ae13f3f61595eef",
"assets/AssetManifest.bin": "f88a8989476bbee55ba6d667dbf58589",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"flutter_bootstrap.js": "1056c581ad32e270d949273a23286823",
"favicon.png": "9a007d8a1315d10196369a3afd33b43a",
"index.html": "bf34686f54c31b4ddd6573b9810ea906",
"/": "bf34686f54c31b4ddd6573b9810ea906"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
