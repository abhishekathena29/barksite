import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../widgets/app_layout.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isRequestingLocation = false;
  String? _locationError;
  _Location? _location;

  final List<_NearbyPlace> _places = [
    _NearbyPlace('PetSmart', '0.8 mi', '123 Main St', 4.5, 'store', 25, 30),
    _NearbyPlace('Dog Park Central', '0.5 mi', '200 Park Ave', 4.9, 'park', 70, 20),
    _NearbyPlace('Petco', '1.2 mi', '456 Oak Ave', 4.3, 'store', 80, 65),
    _NearbyPlace('Paws and Claws Grooming', '1.5 mi', '789 Pine Rd', 4.7, 'groomer', 20, 70),
    _NearbyPlace('Happy Tails Vet', '1.8 mi', '321 Elm St', 4.8, 'vet', 65, 80),
    _NearbyPlace('Pet Supplies Plus', '2.1 mi', '654 Maple Dr', 4.4, 'store', 35, 85),
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isRequestingLocation = true;
      _locationError = null;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isRequestingLocation = false;
      _location = _Location(latitude: 37.7749, longitude: -122.4194);
    });
  }

  Future<void> _openGoogleMaps() async {
    final query = _location != null
        ? 'https://www.google.com/maps/search/pet+stores+dog+parks+near+me/@${_location!.latitude},${_location!.longitude},14z'
        : 'https://www.google.com/maps/search/pet+stores+dog+parks+near+me';
    final uri = Uri.parse(query);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Find Pet Stores',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search for pet stores...',
              prefixIcon: Icon(LucideIcons.search, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          if (_isRequestingLocation)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8),
                    Text('Requesting location access...'),
                  ],
                ),
              ),
            ),
          if (_locationError != null)
            Card(
              color: AppTheme.destructive.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.alertCircle, color: AppTheme.destructive),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_locationError!, style: const TextStyle(color: AppTheme.destructive, fontSize: 12)),
                          const SizedBox(height: 6),
                          OutlinedButton.icon(
                            onPressed: _requestLocationPermission,
                            icon: const Icon(LucideIcons.navigation, size: 16),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _openGoogleMaps,
            child: Card(
              margin: EdgeInsets.zero,
              child: SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE8F4EA), Color(0xFFE9F1FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.2,
                        child: CustomPaint(
                          painter: _GridPainter(),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RoadPainter(),
                      ),
                    ),
                    if (_location != null)
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2 - 20,
                        top: 120,
                        child: Column(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(child: Icon(Icons.circle, color: Colors.white, size: 12)),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                              child: const Text('You', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ..._places.map((place) {
                      return Positioned(
                        left: place.x / 100 * MediaQuery.of(context).size.width,
                        top: place.y / 100 * 260,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: _placeColor(place.type),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(_placeIcon(place.type), color: Colors.white, size: 12),
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(LucideIcons.externalLink, size: 12),
                              SizedBox(width: 6),
                              Text('Tap to open Google Maps', style: TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _Legend(color: Colors.red, label: 'Your Location'),
              _Legend(color: const Color(0xFF3B82F6), label: 'Pet Store'),
              _Legend(color: const Color(0xFF22C55E), label: 'Dog Park'),
              _Legend(color: const Color(0xFF8B5CF6), label: 'Groomer'),
              _Legend(color: const Color(0xFFEC4899), label: 'Vet'),
            ],
          ),
          const SizedBox(height: 10),
          if (_location != null)
            Row(
              children: [
                const Icon(LucideIcons.navigation, size: 16, color: AppTheme.primary),
                const SizedBox(width: 6),
                Text('Your location: ${_location!.latitude.toStringAsFixed(4)}, ${_location!.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.mutedText)),
              ],
            ),
          const SizedBox(height: 10),
          const Text('Nearby Dog Places', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _places.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final place = _places[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: _placeColor(place.type), shape: BoxShape.circle),
                          child: Icon(_placeIcon(place.type), color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(place.distance, style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(place.address, style: const TextStyle(fontSize: 12, color: AppTheme.mutedText)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text('★', style: TextStyle(color: Colors.amber)),
                                  const SizedBox(width: 4),
                                  Text(place.rating.toString(), style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.mutedText.withOpacity(0.3)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    paint.strokeWidth = 1;
    paint.color = Colors.grey.withOpacity(0.2);
    canvas.drawLine(Offset(0, size.height / 4), Offset(size.width, size.height / 4), paint);
    canvas.drawLine(Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.75), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Location {
  _Location({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}

class _NearbyPlace {
  _NearbyPlace(this.name, this.distance, this.address, this.rating, this.type, this.x, this.y);
  final String name;
  final String distance;
  final String address;
  final double rating;
  final String type;
  final double x;
  final double y;
}

IconData _placeIcon(String type) {
  switch (type) {
    case 'store':
      return LucideIcons.store;
    case 'park':
      return LucideIcons.treePine;
    case 'groomer':
      return LucideIcons.scissors;
    case 'vet':
      return LucideIcons.stethoscope;
    default:
      return LucideIcons.store;
  }
}

Color _placeColor(String type) {
  switch (type) {
    case 'store':
      return const Color(0xFF3B82F6);
    case 'park':
      return const Color(0xFF22C55E);
    case 'groomer':
      return const Color(0xFF8B5CF6);
    case 'vet':
      return const Color(0xFFEC4899);
    default:
      return const Color(0xFF3B82F6);
  }
}
