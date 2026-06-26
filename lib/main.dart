import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gpx/gpx.dart';

void main() {
  runApp(const MesRandoApp());
}

class Rando {
  final String nom, gr, distance, denivele, duree, niveau, description;
  final int pointsVue, gites, restos;
  final List<Map<String, String>> pointsInteret;
  final LatLng centre;
  final String? gpxAsset;

  const Rando({
    required this.nom,
    required this.gr,
    required this.distance,
    required this.denivele,
    required this.duree,
    required this.niveau,
    required this.description,
    required this.pointsVue,
    required this.gites,
    required this.restos,
    required this.pointsInteret,
    required this.centre,
    this.gpxAsset,
  });
}

final List<Rando> randos = [
  Rando(
    nom: 'GR34 — Chemin des Douaniers',
    gr: 'GR34',
    distance: '~2000 km',
    denivele: 'variable',
    duree: 'plusieurs semaines',
    niveau: 'Difficile',
    description: 'Le célèbre Chemin des Douaniers longe tout le littoral breton, des caps rocheux aux plages sauvages, en passant par les marais et les dunes.',
    pointsVue: 12,
    gites: 8,
    restos: 6,
    centre: const LatLng(48.2, -3.0),
    gpxAsset: 'assets/chemin-des-douaniers.gpx',
    pointsInteret: [
      {'type': 'vue', 'nom': 'Pointe du Raz', 'detail': 'Point de vue · extrémité ouest'},
      {'type': 'vue', 'nom': 'Cap Fréhel', 'detail': 'Point de vue · Côtes-d\'Armor'},
      {'type': 'gite', 'nom': 'Gîte de Perros-Guirec', 'detail': 'Hébergement · km 450'},
      {'type': 'resto', 'nom': 'Crêperie du Port', 'detail': 'Restaurant · Concarneau'},
      {'type': 'vue', 'nom': 'Mont-Saint-Michel', 'detail': 'Point de vue · Baie'},
      {'type': 'gite', 'nom': 'Gîte de Saint-Malo', 'detail': 'Hébergement · arrivée'},
    ],
  ),Rando(
  nom: 'Littoral de Normandie',
  gr: 'GR223',
  distance: '~360 km',
  denivele: 'variable',
  duree: '2-3 semaines',
  niveau: 'Moyen',
  description: 'Le GR223 longe le littoral normand du Mont-Saint-Michel à Tatihou, traversant falaises, plages du débarquement et havres pittoresques.',
  pointsVue: 8,
  gites: 5,
  restos: 4,
  centre: const LatLng(49.2, -1.5),
  gpxAsset: 'assets/littoral-de-la-normandie.gpx',
  pointsInteret: [
    {'type': 'vue', 'nom': 'Mont-Saint-Michel', 'detail': 'Point de vue · départ'},
    {'type': 'vue', 'nom': 'Plages du Débarquement', 'detail': 'Point de vue · km 120'},
    {'type': 'gite', 'nom': 'Gîte de Granville', 'detail': 'Hébergement · km 60'},
    {'type': 'resto', 'nom': 'Crêperie du Cotentin', 'detail': 'Restaurant · km 90'},
    {'type': 'vue', 'nom': 'Falaises d\'Étretat', 'detail': 'Point de vue · km 280'},
    {'type': 'gite', 'nom': 'Gîte de Barfleur', 'detail': 'Hébergement · km 310'},
  ],
),
  Rando(
    nom: 'Tour du Hohneck',
    gr: 'GR531',
    distance: '12 km',
    denivele: '420 m',
    duree: '4h',
    niveau: 'Facile',
    description: 'Tour autour du massif du Hohneck, point culminant des Vosges, avec vue sur les chaumes.',
    pointsVue: 2,
    gites: 1,
    restos: 0,
    centre: const LatLng(47.99, 7.00),
    pointsInteret: [
      {'type': 'vue', 'nom': 'Sommet du Hohneck', 'detail': 'Point de vue · km 4'},
      {'type': 'gite', 'nom': 'Chalet du Hohneck', 'detail': 'Hébergement · km 6'},
      {'type': 'vue', 'nom': 'Lac de Longemer', 'detail': 'Point de vue · km 10'},
    ],
  ),
];

class MesRandoApp extends StatelessWidget {
  const MesRandoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Rando',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D9E75)),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  final List<Widget> _pages = const [CartePage(), ListePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9E75),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes Rando', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Bretagne · Vosges', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Carte'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Randonn.'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Mes rando'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}

class CartePage extends StatefulWidget {
  const CartePage({super.key});

  @override
  State<CartePage> createState() => _CartePageState();
}

class _CartePageState extends State<CartePage> {
  List<LatLng> _gr34Points = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGpx();
  }

  Future<void> _loadGpx() async {
    try {
      final data = await rootBundle.loadString('assets/chemin-des-douaniers.gpx');
      final gpx = GpxReader().fromString(data);
      final points = <LatLng>[];
      for (final trk in gpx.trks) {
        for (final seg in trk.trksegs) {
          for (final pt in seg.trkpts) {
            if (pt.lat != null && pt.lon != null) {
              points.add(LatLng(pt.lat!, pt.lon!));
            }
          }
        }
      }
      // Alléger : garder 1 point sur 10
      final simplified = <LatLng>[];
      for (int i = 0; i < points.length; i += 10) {
        simplified.add(points[i]);
      }
      setState(() {
        _gr34Points = simplified;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1D9E75)),
            SizedBox(height: 16),
            Text('Chargement du tracé GR34...'),
          ],
        ),
      );
    }

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(48.2, -3.0),
        initialZoom: 7,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.mes_rando',
        ),
        if (_gr34Points.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _gr34Points,
                strokeWidth: 3,
                color: const Color(0xFF1D9E75),
              ),
            ],
          ),
        MarkerLayer(
          markers: randos.map((r) => Marker(
            point: r.centre,
            width: 120,
            height: 36,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FichePage(rando: r)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Flexible(child: Text(r.gr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class ListePage extends StatelessWidget {
  const ListePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: randos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final rando = randos[index];
        return RandoCard(
          rando: rando,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FichePage(rando: rando)),
          ),
        );
      },
    );
  }
}

class RandoCard extends StatelessWidget {
  final Rando rando;
  final VoidCallback onTap;

  const RandoCard({super.key, required this.rando, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(rando.nom, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                  Chip(
                    label: Text(rando.gr, style: const TextStyle(color: Color(0xFF1D9E75), fontSize: 11)),
                    backgroundColor: const Color(0xFFE1F5EE),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat(Icons.route, rando.distance, 'Distance'),
                  _stat(Icons.trending_up, rando.denivele, 'Dénivelé'),
                  _stat(Icons.access_time, rando.duree, 'Durée'),
                  _stat(Icons.speed, rando.niveau, 'Niveau'),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  if (rando.pointsVue > 0) _tag('🏔 ${rando.pointsVue} point(s) de vue', const Color(0xFFEAF3DE), const Color(0xFF3B6D11)),
                  if (rando.gites > 0) _tag('🏠 ${rando.gites} gîte(s)', const Color(0xFFE6F1FB), const Color(0xFF185FA5)),
                  if (rando.restos > 0) _tag('🍽 ${rando.restos} resto(s)', const Color(0xFFFAEEDA), const Color(0xFF854F0B)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String valeur, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1D9E75)),
        const SizedBox(height: 2),
        Text(valeur, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _tag(String texte, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(texte, style: TextStyle(fontSize: 11, color: fg)),
    );
  }
}

class FichePage extends StatefulWidget {
  final Rando rando;
  const FichePage({super.key, required this.rando});

  @override
  State<FichePage> createState() => _FichePageState();
}

class _FichePageState extends State<FichePage> {
  List<LatLng> _trace = [];

  @override
  void initState() {
    super.initState();
    if (widget.rando.gpxAsset != null) {
      _loadGpx();
    }
  }

  Future<void> _loadGpx() async {
    try {
      final data = await rootBundle.loadString(widget.rando.gpxAsset!);
      final gpx = GpxReader().fromString(data);
      final points = <LatLng>[];
      for (final trk in gpx.trks) {
        for (final seg in trk.trksegs) {
          for (final pt in seg.trkpts) {
            if (pt.lat != null && pt.lon != null) {
              points.add(LatLng(pt.lat!, pt.lon!));
            }
          }
        }
      }
      final simplified = <LatLng>[];
      for (int i = 0; i < points.length; i += 10) {
        simplified.add(points[i]);
      }
      setState(() => _trace = simplified);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final rando = widget.rando;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF1D9E75),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF1D9E75),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(rando.nom, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statHeader(rando.distance, 'Distance'),
                        _statHeader(rando.denivele, 'Dénivelé+'),
                        _statHeader(rando.duree, 'Durée'),
                        _statHeader(rando.niveau, 'Niveau'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(rando.description, style: const TextStyle(color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(initialCenter: rando.centre, initialZoom: rando.gpxAsset != null ? 7 : 11),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.mes_rando',
                          ),
                          if (_trace.isNotEmpty)
                            PolylineLayer(polylines: [Polyline(points: _trace, strokeWidth: 3, color: const Color(0xFF1D9E75))]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Points d\'intérêt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...rando.pointsInteret.map((poi) => _poiTile(poi)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text('Démarrer la rando', style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statHeader(String valeur, String label) {
    return Column(
      children: [
        Text(valeur, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _poiTile(Map<String, String> poi) {
    final icons = {
      'vue': (Icons.landscape, const Color(0xFF3B6D11), const Color(0xFFEAF3DE)),
      'gite': (Icons.bed, const Color(0xFF185FA5), const Color(0xFFE6F1FB)),
      'resto': (Icons.restaurant, const Color(0xFF854F0B), const Color(0xFFFAEEDA)),
    };
    final style = icons[poi['type']] ?? (Icons.place, Colors.grey, Colors.grey.shade100);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: style.$3, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(style.$1, color: style.$2, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(poi['nom']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(poi['detail']!, style: TextStyle(fontSize: 11, color: style.$2)),
            ],
          ),
        ],
      ),
    );
  }
}