'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/assets/images/netherlands_unsplash.jpg": "afe5b4900a01d03d2f36d6d7e26b03a0",
"assets/assets/images/brussels_unsplash.jpg": "32800a8ec8c7b79c030bd51db3729ad8",
"assets/assets/images/heidelberg_unsplash.jpg": "cb563fc6749c4b8a9732073ca18afc9f",
"assets/assets/images/prague_unsplash.jpg": "de61482ee7ca924cc63336f2863d36a1",
"assets/assets/images/solingen_unsplash.jpg": "5ea9ffdf06ab80e0af9c3be93702a947",
"assets/assets/images/cochem_unsplash.jpg": "3f2e482949746cc26ac1734361417d00",
"assets/assets/images/euskirchen_unsplash.jpg": "c1efb59bddffbd29ca2d807c394f8e7e",
"assets/assets/images/mannheim_unsplash.jpg": "4c844e57a155043242490270ad9282a2",
"assets/assets/images/dortmund_unsplash.jpg": "c561d1dff2d79247d9564cfaf9a72b53",
"assets/assets/images/belgium_unsplash.jpg": "6f51fc6375bcf3ce97fc4b3e0e79c0bc",
"assets/assets/images/duisburg_unsplash.jpg": "14db0e9e200f49cfdd36ec1d3a95569b",
"assets/assets/images/berlin_unsplash.jpg": "74274016f88a021a48fbaee137122187",
"assets/assets/images/aachen_unsplash.jpg": "4d55ffc7fa321560c4eac3aff6682f05",
"assets/assets/images/slovakia_unsplash.jpg": "6eb959550ce8b2bf2beab74c56cef9ef",
"assets/assets/images/vienna_unsplash.jpg": "0c8c8d5c4ceccd04d9d846515cb8a133",
"assets/assets/images/amsterdam_unsplash.jpg": "34ea4e2a201f433a6c70a898cb3a0163",
"assets/assets/images/hungary_unsplash.jpg": "9d9c42fd8be88a8c14d478cad48e435e",
"assets/assets/images/dusseldorf_unsplash.jpg": "15df5936d508e3598f4edd6de11fa099",
"assets/assets/images/cologne_unsplash.jpg": "b7a1353fec51a2b1a26873800d6181ec",
"assets/assets/images/bratislava_unsplash.jpg": "9fd169b634daa0c235cf6a2dd39081f2",
"assets/assets/images/czechrepublic_unsplash.jpg": "3ee4e27a72b011e6453263a11db931c6",
"assets/assets/images/pisa_unsplash.jpg": "c17a907db1720caf6951aa256612db52",
"assets/assets/images/paris_unsplash.jpg": "f686513e6a7eb24bb0c94ee0aa4ce3e0",
"assets/assets/images/brugge_unsplash.jpg": "fdb6211b2170894630fb00dbf4f5fc7d",
"assets/assets/images/milano_unsplash.jpg": "937dd31623022462712e8d39089f38f6",
"assets/assets/images/venice_unsplash.jpg": "cc84437dc4d84263994dfad9a59e236d",
"assets/assets/images/hamburg_unsplash.jpg": "0435ffe5aae17da99be9c37ec47d268e",
"assets/assets/images/karlsruhe_unsplash.jpg": "51551e8f7d8f620531bd82659abb9447",
"assets/assets/images/france_unsplash.jpg": "1ae2adee58bbb79f4921657e8485a24b",
"assets/assets/images/essen_unsplash.jpg": "a86b00c315168b16ae0df5a12d0a5692",
"assets/assets/images/bochum_unsplash.jpg": "ddfc0a2975bfc7ff2d97c806218ba070",
"assets/assets/images/bonn_unsplash.jpg": "8719437369a0ac41933da363dc13b3a0",
"assets/assets/images/italy_unsplash.jpg": "3efdd6107bf7550c05e0a52c9b2e76f1",
"assets/assets/images/como_unsplash.jpg": "4f484286f5df103a2e88d874a1428745",
"assets/assets/images/wuppertal_unsplash.jpg": "88e81a59d49be0e92c093120152c3d7d",
"assets/assets/images/budapest_unsplash.jpg": "2a6762661fb6464316fef4b1508525ba",
"assets/assets/images/germany_unsplash.jpg": "b3eb0b88216876419140a3399a3dbdb7",
"assets/assets/images/florence_unsplash.jpg": "39ece76c444930ef1697a6cdb0795342",
"assets/assets/images/austria_unsplash.jpg": "c8bd4313bd9bd6ea61b936ce78e10380",
"assets/assets/images/stuttgart_unsplash.jpg": "eb02d60c2111285717390ee76c46c389",
"assets/assets/images/siegburg_unsplash.jpg": "c7cc16fda1e8522ed98004adeaba9c04",
"assets/assets/images/luxembourg_unsplash.jpg": "17694f1740634ec4d6cf0b478da343ce",
"assets/assets/images/muenster_unsplash.jpg": "36deeb6814bdd8bdba4cf2a9a2eb62bd",
"assets/assets/images/luxembourg_city_unsplash.jpg": "be6da37f5efce35e11e031c4195b69bc",
"assets/assets/images/koblenz_unsplash.jpg": "343437547b9742f1a705f0ab12530316",
"assets/AssetManifest.json": "0cea3dac3d1a36ecd4a13e7b0a20b3e5",
"assets/FontManifest.json": "4a0bee9eff179c5b9622518eea44bd79",
"assets/NOTICES": "b7adb82af4c29f688e7c0211c25d48b8",
"assets/AssetManifest.bin": "472c772084109bd235b0f6b64fc27ea8",
"assets/fonts/Courgette-Regular.ttf": "249ec2a5292e7aac44667e4cdbccc0ec",
"assets/fonts/Nunito-Regular.ttf": "2cd487d187b602d1fa522f8af05f1fbd",
"assets/fonts/MaterialIcons-Regular.otf": "ebcfd65b9d7c679b38ae038547ce46e7",
"assets/fonts/Nunito-Bold.ttf": "9772667f53d0a85e7b09b879821ef01b",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"manifest.json": "5f733a495994ea67693b6d644ba1f1a4",
"canvaskit/canvaskit.wasm": "e5b1f72690096075e25fe1f481cb6ce6",
"canvaskit/skwasm.js": "831c0eebc8462d12790b0fadf3ab6a8a",
"canvaskit/canvaskit.js": "45bec3a754fba62b2d8f23c38895f029",
"canvaskit/skwasm.wasm": "2cb965595f656f0c58ad6bb5988f8280",
"canvaskit/skwasm.worker.js": "7ec8c65402d6cd2a341a5d66aa3d021f",
"canvaskit/chromium/canvaskit.wasm": "347841c04107bb5a17164bee251d8307",
"canvaskit/chromium/canvaskit.js": "6bdd0526762a124b0745c05281c8a53e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "c4ff3272922ceb47be4a35c74e4f6fc1",
"/": "c4ff3272922ceb47be4a35c74e4f6fc1",
"main.dart.js": "4e3e94a8a0ad6e5a8cc8ba6b74a99fef",
"version.json": "fc480c04d42383f1366520c963295a5b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
