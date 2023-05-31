import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';


class BlogPost {
  final String postId;
  final String title;
  final String summary;
  final String caption;
  final String imageUrl;
  final String imageAttribution;
  final String content;
  final String country;
  final String city;

  const BlogPost({
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.content,
    required this.country,
    required this.city,
  });
}

final Map<String, BlogPost> blogPosts = {
  '1': BlogPost(
    postId: '1',
    title: 'Exploring Bonn: The Beethoven City',
    summary: 'Experience the historical charm of Bonn ...',
    caption: 'Bonn, the birthplace of Ludwig van Beethoven, is filled with rich culture and stunning architecture.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/bonn_unsplash.jpg',
    imageAttribution: 'Photo by Roman Schmitz on Unsplash',
    content: 'Immerse yourself in the history of Bonn, wandering through streets that echo with the melodies of Beethoven. Experience the cultural richness that emanates from every corner.',
    country: 'Germany',
    city: 'Bonn',
  ),
  '2': BlogPost(
    postId: '2',
    title: 'Cologne: A Blend of Old and New',
    summary: 'Journey through time in the city of Cologne ...',
    caption: 'Cologne marries historical architecture with modern life. The iconic Cologne Cathedral is a must-see.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/cologne_unsplash.jpg',
    imageAttribution: 'Photo by Glenn Carstens-Peters on Unsplash',
    content: 'Cologne, an old city bursting with vibrant life. From the Gothic spires of the Cologne Cathedral to the bustling streets of modern districts, there\'s always something new to discover.',
    country: 'Germany',
    city: 'Cologne',
  ),
  '3': BlogPost(
    postId: '3',
    title: 'Dortmund: The Green Metropolis',
    summary: 'Uncover the green heart of Dortmund ...',
    caption: 'Dortmund, a city transformed from a coal and steel powerhouse into a green oasis.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/dortmund_unsplash.jpg',
    imageAttribution: 'Photo by Waldemar on Unsplash',
    content: 'Dortmund is a testament to the power of transformation. Once known for coal and steel, it\'s now famous for its green spaces and parks. Explore Dortmund and experience the city reborn.',
    country: 'Germany',
    city: 'Dortmund',
  ),
  '4': BlogPost(
    postId: '4',
    title: 'Düsseldorf: The Art and Fashion Hub',
    summary: 'Immerse yourself in the art and ...',
    caption: 'Düsseldorf, a city known for its pioneering influence in electronic/experimental music and its Japanese community.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/dusseldorf_unsplash.jpg',
    imageAttribution: 'Photo by Liam Martens on Unsplash',
    content: 'Düsseldorf, a city that radiates creative energy. From fashion to art and music, Düsseldorf is a city that dares to imagine. Explore the famous Königsallee, renowned for its high-end shopping, and don\'t miss the thriving Japanese district.',
    country: 'Germany',
    city: 'Düsseldorf',
  ),
  '5': BlogPost(
    postId: '5',
    title: 'Aachen: The Spa City with a Rich History',
    summary: 'Experience the rich history and wellness ...',
    caption: 'Aachen, a city where Charlemagne once ruled and famous for its thermal spas.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/aachen_unsplash.jpg',
    imageAttribution: 'Photo by Carolina Nichitin on Unsplash',
    content: 'Aachen is a city that pampers both your mind and body. Explore the historical Charlemagne landmarks and unwind in the city\'s world-renowned thermal spas. A visit to Aachen is a soothing journey through time.',
    country: 'Germany',
    city: 'Aachen',
  ),
  '6': BlogPost(
    postId: '6',
    title: 'Essen: The City of Bread and Butter',
    summary: 'Discover the industrial heritage and ...',
    caption: 'Essen, a city that played a key role in the industrial revolution of Germany.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/essen_unsplash.jpg',
    imageAttribution: 'Photo by Peter Heinsius on Unsplash',
    content: 'Essen is a city that was at the heart of Germany\'s industrial revolution. Now, it balances its industrial heritage with beautiful parks and green spaces. The Zollverein Coal Mine Industrial Complex in Essen is a UNESCO World Heritage Site that is a must-see.',
    country: 'Germany',
    city: 'Essen',
  ),
  '7': BlogPost(
    postId: '7',
    title: 'Bochum: The Heart of the Ruhr Industry',
    summary: 'Dive into the industrial culture of Bochum ...',
    caption: 'Bochum, a testament to the industrial strength of the Ruhr region.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/bochum_unsplash.jpg',
    imageAttribution: 'Photo by Marlo Wock on Unsplash',
    content: 'Bochum symbolizes the strength of the Ruhr region, with its history steeped in the coal mining industry. Today, it\'s a vibrant city offering a rich tapestry of culture and history, from the German Mining Museum to the captivating musicals at Starlight Express.',
    country: 'Germany',
    city: 'Bochum',
  ),
  '8': BlogPost(
    postId: '8',
    title: 'Münster: City of Bikes and History',
    summary: 'Discover Münster, where history ...',
    caption: 'Münster, a vibrant city known for its university and high number of bicycles.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/muenster_unsplash.jpg',
    imageAttribution: 'Photo by Nico Brüggemann on Unsplash',
    content: 'Münster is a city that perfectly marries the old with the new. Discover a history-rich town center, and a young, vibrant community cycling around the city. With over 500 years of history, the University of Münster is not to be missed.',
    country: 'Germany',
    city: 'Münster',
  ),
  '9': BlogPost(
    postId: '9',
    title: 'Duisburg: The Heart of the Ruhr Region',
    summary: 'Explore Duisburg, a city known for its ...',
    caption: 'Duisburg, a key city in the Ruhr industrial area with a history steeped in coal and steel production.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/duisburg_unsplash.jpg',
    imageAttribution: 'Photo by Calvin fitra Anggara on Unsplash',
    content: 'Duisburg is a city that embodies Germany\'s industrial past. With its impressive Inner Harbour, which has transformed from a center of industry into a bustling hub of culture and dining, Duisburg is a city that has successfully reinvented itself.',
    country: 'Germany',
    city: 'Duisburg',
  ),
  '10': BlogPost(
    postId: '10',
    title: 'Euskirchen: Gateway to the Eifel',
    summary: 'Experience Euskirchen, the charming gateway ...',
    caption: 'Euskirchen, a peaceful town that serves as a perfect base to explore the Eifel region.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/euskirchen_unsplash.jpg',
    imageAttribution: 'Photo by Yan Van Nerum on Unsplash',
    content: 'Euskirchen, a quaint town that offers the perfect gateway to the picturesque Eifel region. Bask in the tranquility of nature, and experience the simple joys of life in the peaceful town of Euskirchen.',
    country: 'Germany',
    city: 'Euskirchen',
  ),
  '11': BlogPost(
    postId: '11',
    title: 'Cochem: A Romantic Getaway',
    summary: 'Uncover the romantic allure of Cochem, a gem on the Moselle River ...',
    caption: 'Cochem, known for its stunning castle and romantic riverside setting.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/cochem_unsplash.jpg',
    imageAttribution: 'Photo by Julia Solonina on Unsplash',
    content: 'Cochem is a city that exudes a romantic charm. The city\'s crowning glory is the Cochem Imperial Castle, majestically overlooking the scenic Moselle River. Explore the winding streets, enjoy a river cruise, or sample some of the local Riesling.',
    country: 'Germany',
    city: 'Cochem',
  ),
  '12': BlogPost(
    postId: '12',
    title: 'Koblenz: Where Rhine and Moselle meet',
    summary: 'Experience the enchantment of Koblenz ...',
    caption: 'Koblenz, a historic city charmingly set at the confluence of two majestic rivers.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/koblenz_unsplash.jpg',
    imageAttribution: 'Photo by Jonathan Kemper on Unsplash',
    content: 'Koblenz, with its 2000-year-old history, is one of the oldest cities in Germany. The Deutsches Eck, where the Rhine and Moselle rivers converge, offers a picturesque spectacle that is a must-see for every visitor.',
    country: 'Germany',
    city: 'Koblenz',
  ),
  '13': BlogPost(
    postId: '13',
    title: 'Mannheim: The City of Squares',
    summary: 'Explore Mannheim, a unique cityscape based on a grid of squares ...',
    caption: 'Mannheim, where you can experience its distinctively organized city layout and vibrant culture.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/mannheim_unsplash.jpg',
    imageAttribution: 'Photo by Lāsma Artmane on Unsplash',
    content: 'Known as "Die Quadratestadt" (the city of squares), Mannheim has a unique city layout unlike any other in Germany. Its vibrant cultural scene and rich history make it a compelling city to explore.',
    country: 'Germany',
    city: 'Mannheim',
  ),
  '14': BlogPost(
    postId: '14',
    title: 'Heidelberg: The Romantic City',
    summary: 'Discover Heidelberg, a romantic city renowned for its historic old town and prestigious university ...',
    caption: 'Heidelberg, where academia and a vibrant old town create a romantic backdrop.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/heidelberg_unsplash.jpg',
    imageAttribution: 'Photo by Mateo Krössler on Unsplash',
    content: 'Nestled in a picturesque valley along the river Neckar, Heidelberg is renowned for its historic old town, beautiful castle ruins, and one of the oldest universities in Germany. Its romantic charm is sure to enchant every visitor.',
    country: 'Germany',
    city: 'Heidelberg',
  ),
  '15': BlogPost(
    postId: '15',
    title: 'Karlsruhe: The Fan City',
    summary: 'Immerse yourself in Karlsruhe, a city uniquely planned in the shape of a fan ...',
    caption: 'Karlsruhe, a city that beautifully fans out from its central palace.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/karlsruhe_unsplash.jpg',
    imageAttribution: 'Photo by Komal Gahir on Unsplash',
    content: 'Karlsruhe, also known as the Fan City due to its unique city layout, with streets radiating out from the beautiful Baroque palace at its heart. It\'s a vibrant city with a rich history, a lively arts scene, and fantastic dining experiences.',
    country: 'Germany',
    city: 'Karlsruhe',
  ),
  '16': BlogPost(
    postId: '16',
    title: 'Stuttgart: The Cradle of the Automobile',
    summary: 'Discover Stuttgart, the birthplace of ...',
    caption: 'Stuttgart, a city that combines innovation with rich cultural heritage.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/stuttgart_unsplash.jpg',
    imageAttribution: 'Photo by Niklas Ohlrogge on Unsplash',
    content: 'Stuttgart, nestled in a verdant valley surrounded by vineyards and forests, is the birthplace of the automobile. Home to Mercedes-Benz and Porsche, it combines Swabian diligence with a forward-thinking approach and a high-quality lifestyle.',
    country: 'Germany',
    city: 'Stuttgart',
  ),
  '17': BlogPost(
    postId: '17',
    title: 'Berlin: A City of History',
    summary: 'A dive into the rich history and the vibrant, creative life of the German capital ...',
    caption: 'Berlin, a city that weaves together threads of history, culture, and creativity.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/berlin_unsplash.jpg',
    imageAttribution: 'Photo by Simon Vollformat on Unsplash',
    content: "Berlin, the capital city of Germany, is a metropolis that effortlessly weaves together the threads of history, culture, and creativity. It's an eclectic mix of old and new, showcasing its gritty history while embodying a forward-thinking spirit.",
    country: 'Germany',
    city: 'Berlin',
  ),
  '18': BlogPost(
    postId: '18',
    title: 'Hamburg: The Gateway to the World',
    summary: 'Discover the maritime charm of Hamburg ...',
    caption: 'Hamburg, a city that embraces its rich maritime history and modern vibrancy.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/hamburg_unsplash.jpg',
    imageAttribution: 'Photo by Moritz Kindler on Unsplash',
    content: 'Hamburg, Germany\'s second-largest city, is known for its majestic harbor, the bustling Fish Market, and the historic warehouse district, Speicherstadt. Its maritime charm and cosmopolitan flair create a unique atmosphere.',
    country: 'Germany',
    city: 'Hamburg',
  ),
  '19': BlogPost(
    postId: '19',
    title: 'Solingen: The City of Blades',
    summary: 'Explore Solingen, a city famous for its high-quality blades ...',
    caption: 'Solingen, where tradition meets innovation in the art of blade-making.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/solingen_unsplash.jpg',
    imageAttribution: 'Photo by Alexander Schimmeck on Unsplash',
    content: 'Solingen, also known as the "City of Blades", is renowned for its production of fine swords, knives, scissors and razors made by famous manufacturers such as Wusthof, Henckels, and Boker. Its tradition of metalworking continues to thrive today.',
    country: 'Germany',
    city: 'Solingen',
  ),
  '20': BlogPost(
    postId: '20',
    title: 'Wuppertal: City on the Schwebebahn',
    summary: 'Experience Wuppertal, a city best known for ...',
    caption: 'Wuppertal, where the iconic Schwebebahn offers a unique cityscape perspective.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/wuppertal_unsplash.jpg',
    imageAttribution: 'Photo by Jorgen Hendriksen on Unsplash',
    content: 'Wuppertal is a green city in the heart of North Rhine-Westphalia. Its suspension railway, the "Schwebebahn", is a unique and loved symbol of the city, offering a unique perspective of the urban landscape as it whisks passengers above the river Wupper.',
    country: 'Germany',
    city: 'Wuppertal',
  ),
  '21': BlogPost(
    postId: '21',
    title: 'Siegburg: A Timeless Middle Age Beauty',
    summary: 'Get lost in time with the medieval charm ...',
    caption: 'Siegburg, where the Middle Ages come to life in the present day.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/siegburg_unsplash.jpg',
    imageAttribution: 'Photo by Serj Sakharovskiy on Unsplash',
    content: 'Siegburg is a charming city steeped in history, where the medieval age is still alive. The crowning glory of Siegburg is its Michelsberg Abbey, a Benedictine monastery, which sits majestically overlooking the town and offering a window into the past.',
    country: 'Germany',
    city: 'Siegburg',
  ),
  '22': BlogPost(
    postId: '22',
    title: 'Paris: The City of Lights',
    summary: 'Immerse yourself in the vibrant and romantic charm of Paris...',
    caption: 'Paris, where romance, culture, and history blend seamlessly in the City of Lights.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/paris_unsplash.jpg',
    imageAttribution: 'Photo by Mattia Righetti on Unsplash',
    content: "Paris, the City of Lights, captivates with its world-renowned landmarks like the Eiffel Tower, Louvre Museum, and the charming neighborhood of Montmartre. The city's rich artistic heritage, exquisite cuisine, and chic lifestyle create an unforgettable experience.",
    country: 'France',
    city: 'Paris',
  ),
  '23': BlogPost(
    postId: '23',
    title: 'Brussels: Heart of Europe',
    summary: 'Experience the diverse culture of Brussels, the capital of Europe...',
    caption: 'Brussels, a multicultural hub with a rich history and a vibrant present.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/brussels_unsplash.jpg',
    imageAttribution: 'Photo by n on Unsplash',
    content: 'Brussels is known as the heart of Europe, a city where cultures come together and flourish. From its iconic Atomium and the historic Grand Place to its rich comic culture, and, of course, waffles and chocolate, Brussels is a city with something for everyone.',
    country: 'Belgium',
    city: 'Brussels',
  ),
  '24': BlogPost(
    postId: '24',
    title: 'Brugge: The Venice of the North',
    summary: 'Venture through the romantic canals and cobbled streets of Brugge...',
    caption: 'Brugge, a fairy-tale medieval town filled with canals and charming old buildings.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/brugge_unsplash.jpg',
    imageAttribution: 'Photo by Libby Penner on Unsplash',
    content: 'Brugge is often known as "The Venice of the North" due to its beautiful canals that wind through the city. Its well-preserved medieval architecture, cobbled streets, and picturesque market squares create a magical atmosphere, transporting visitors back in time.',
    country: 'Belgium',
    city: 'Brugge',
  ),
  '25': BlogPost(
    postId: '25',
    title: 'Bratislava: The Beauty on the Danube',
    summary: 'Discover the charm of Bratislava, Slovakia’s ...',
    caption: 'Bratislava, the city where history and modernity meet on the banks of the Danube.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/bratislava_unsplash.jpg',
    imageAttribution: 'Photo by Martin Katler on Unsplash',
    content: 'Bratislava, the capital of Slovakia, is a fascinating city marked by its rich history, diverse architecture, and beautiful location on the Danube river. From the medieval Bratislava Castle to the futuristic UFO Bridge, the city is a blend of old and new.',
    country: 'Slovakia',
    city: 'Bratislava',
  ),
  '26': BlogPost(
    postId: '26',
    title: 'Vienna: The Imperial City',
    summary: 'Experience the grandeur of Vienna, the city of music and dreams...',
    caption: 'Vienna, where classical music, art, and history live on every street.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/vienna_unsplash.jpg',
    imageAttribution: 'Photo by daniel plan on Unsplash',
    content: 'Vienna is a city of culture and refinement. Known as the City of Music, it was home to great composers like Mozart and Beethoven. From the stunning Schönbrunn Palace to its lively coffee house culture, Vienna exudes an unmistakable charm.',
    country: 'Austria',
    city: 'Vienna',
  ),
  '27': BlogPost(
    postId: '27',
    title: 'Budapest: The Pearl of the Danube',
    summary: 'Explore the grandeur of Budapest ...',
    caption: 'Budapest, where the old world charm meets a dynamic modern city.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/budapest_unsplash.jpg',
    imageAttribution: 'Photo by Ervin Lukacs on Unsplash',
    content: 'Budapest is an enchanting city split by the Danube River into hilly Buda and flat Pest. With its stunning architecture like the Hungarian Parliament and Buda Castle, thermal baths, and vibrant nightlife, Budapest offers a memorable travel experience.',
    country: 'Hungary',
    city: 'Budapest',
  ),
  '28': BlogPost(
    postId: '28',
    title: 'Amsterdam: The City of Canals',
    summary: 'Discover Amsterdam, the city of picturesque canals and rich heritage...',
    caption: 'Amsterdam, a city where history, culture, and progressive ideals converge.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/amsterdam_unsplash.jpg',
    imageAttribution: 'Photo by Max van den Oetelaar on Unsplash',
    content: "Amsterdam is a city known for its artistic heritage, elaborate canal system, and narrow houses. Famous for the Anne Frank House and Van Gogh Museum, it's a city that blends history with a liberal modern ethos that is truly unique.",
    country: 'Netherlands',
    city: 'Amsterdam',
  ),
  '29': BlogPost(
    postId: '29',
    title: 'Luxembourg: A Small Country with a Big Heart',
    summary: 'Unearth the treasures of Luxembourg, a ...',
    caption: 'Luxembourg, a city with a mix of influences that has shaped a unique culture.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/luxembourg_city_unsplash.jpg',
    imageAttribution: 'Photo by Cedric Letsch on Unsplash',
    content: "Luxembourg, one of Europe’s smallest countries, packs a big punch with its rich history, stunning landscapes, and impressive architecture. From its UNESCO-listed Old Town to the modern Kirchberg district, Luxembourg is full of surprises.",
    country: 'Luxembourg',
    city: 'Luxembourg City',
  ),
  '30': BlogPost(
    postId: '30',
    title: 'Prague: The City of a Hundred Spires',
    summary: 'Explore Prague, a city known for its rich history ...',
    caption: 'Prague, a fairy tale city where history weaves its way through every street.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/prague_unsplash.jpg',
    imageAttribution: 'Photo by Denis Poltoradnev on Unsplash',
    content: 'Prague is a magical city of bridges, cathedrals, gold-tipped towers, and church domes. The city’s historic centre reflects centuries of architectural styles which give the city its fairytale-like atmosphere. Known for its Prague Castle and Charles Bridge, Prague is a feast for the history and architecture lovers.',
    country: 'CzechRepublic',
    city: 'Prague',
  ),
  '31': BlogPost(
    postId: '31',
    title: 'Milano: The Fashion Capital',
    summary: 'Delve into Milano, Italy\'s vibrant fashion and design hub...',
    caption: 'Milano, a city where high-fashion and centuries-old architecture coexist.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/milano_unsplash.jpg',
    imageAttribution: 'Photo by Ouael Ben Salah on Unsplash',
    content: 'Milano is known worldwide for its luxury fashion districts, spectacular architectural landmarks such as the Milan Cathedral, and significant cultural institutions like the La Scala opera house. It is a city that defines cosmopolitan sophistication and creative spirit.',
    country: 'Italy',
    city: 'Milano',
  ),
  '32': BlogPost(
    postId: '32',
    title: 'Como: The Gem of Lombardy',
    summary: 'Experience the allure of Como, nestled by its captivating lake...',
    caption: 'Como, where nature\'s beauty and Italian elegance converge.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/como_unsplash.jpg',
    imageAttribution: 'Photo by Daniele Salutari on Unsplash',
    content: 'Como, a city located in Northern Italy’s Lombardy region, is famed for its spectacular lake views, elegant architecture, and the majestic Alps. Known for its Gothic Como Cathedral, charming old town, and the scenic funicular railway, Como is a blend of cultural and natural attractions.',
    country: 'Italy',
    city: 'Como',
  ),
  '33': BlogPost(
    postId: '33',
    title: 'Florence: The Cradle of the Renaissance',
    summary: 'Florence, the city that stands as a monument ...',
    caption: 'Florence, where every street is a testament to Italy\'s artistic heritage.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/florence_unsplash.jpg',
    imageAttribution: 'Photo by Heidi Kaden on Unsplash',
    content: 'Florence, the capital of Italy\'s Tuscany region, is renowned for its abundance of art and architecture. Home to masterpieces such as Michelangelo’s "David" statue, the Duomo, and the Uffizi Gallery, Florence is a city that is truly a feast for the senses.',
    country: 'Italy',
    city: 'Florence',
  ),
  '34': BlogPost(
    postId: '34',
    title: 'Venice: The Floating City',
    summary: 'Immerse yourself in Venice, a city of romance and wonder...',
    caption: 'Venice, where gondolas glide through a maze of historical canals.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/venice_unsplash.jpg',
    imageAttribution: 'Photo by Damiano Baschiera on Unsplash',
    content: 'Venice, known as the "Floating City", is famed for its canals, gondolas, and beautiful architecture. Iconic landmarks such as the Piazza San Marco, Doge’s Palace, and the Bridge of Sighs add to the city\'s magic, making it a place like no other.',
    country: 'Italy',
    city: 'Venice',
  ),
  '35': BlogPost(
    postId: '35',
    title: 'Pisa: More Than Just a Leaning Tower',
    summary: 'Discover Pisa, a city of architectural wonders and ...',
    caption: 'Pisa, a city that balances historical marvels and vibrant Italian life.',
    imageUrl: 'https://raw.githubusercontent.com/MannavaVivek/MannavaVivek.github.io/main/assets/images/pisa_unsplash.jpg',
    imageAttribution: 'Photo by Andrae Ricketts on Unsplash',
    content: 'Best known for its iconic Leaning Tower, Pisa also boasts other architectural and artistic marvels, owing to its rich history as a maritime power during the Middle Ages. Its vibrant student life, fueled by the prestigious University of Pisa, gives the city a youthful and lively atmosphere.',
    country: 'Italy',
    city: 'Pisa',
  ),

};

List<BlogPost> getBlogPostsForCountry(String country) {
  return blogPosts.values.where((post) => post.country.toLowerCase() == country.toLowerCase()).toList();
}


class BlogPostListItem extends StatelessWidget {
  final String postId;
  final String title;
  final String summary;
  final String caption;
  final String imageUrl;
  final String imageAttribution;
  final String country;
  final String city;

  const BlogPostListItem({
    Key? key,
    required this.postId,
    required this.title,
    required this.summary,
    required this.caption,
    required this.imageUrl,
    required this.imageAttribution,
    required this.country,
    required this.city,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/post/$postId'),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 200, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: 'Courgette',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    summary,
                    style: TextStyle(
                      fontSize: 12, 
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BlogPostScreen extends StatefulWidget {
  final String postId;

  const BlogPostScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _BlogPostScreenState createState() => _BlogPostScreenState();
}


class _BlogPostScreenState extends State<BlogPostScreen> {
  late BlogPost _post;
  bool _isHovered = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _post = blogPosts[widget.postId]!;
    
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Wait for the widget rendering to complete and then scroll
    if (MediaQuery.of(context).size.height > 800) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          _scrollController.jumpTo(1100);
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      leading: Tooltip(
        message: 'Back',
        child: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
          },
        ),
      ),
      title: Text(
        "Explore ${_post.city}",
        style: TextStyle(fontFamily: 'Courgette'),
      ),
    ),
    body: SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: _post.imageUrl,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (_isHovered)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.5),
                      child: Text(
                        _post.imageAttribution,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post.title,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  _post.content,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
