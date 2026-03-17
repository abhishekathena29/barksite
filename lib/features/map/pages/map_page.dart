import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _searchController = TextEditingController();
  bool _isRequestingLocation = false;
  String? _locationError;
  _Location? _location;

  final List<_NearbyPlace> _places = [
    _NearbyPlace('PetSmart', '0.8 mi', '123 Main St', 4.5, 'store', 25, 30),
    _NearbyPlace(
      'Dog Park Central',
      '0.5 mi',
      '200 Park Ave',
      4.9,
      'park',
      70,
      20,
    ),
    _NearbyPlace('Petco', '1.2 mi', '456 Oak Ave', 4.3, 'store', 80, 65),
    _NearbyPlace(
      'Paws and Claws Grooming',
      '1.5 mi',
      '789 Pine Rd',
      4.7,
      'groomer',
      20,
      70,
    ),
    _NearbyPlace('Happy Tails Vet', '1.8 mi', '321 Elm St', 4.8, 'vet', 65, 80),
    _NearbyPlace(
      'Pet Supplies Plus',
      '2.1 mi',
      '654 Maple Dr',
      4.4,
      'store',
      35,
      85,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isRequestingLocation = true;
      _locationError = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));
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
    await launchUrl(Uri.parse(query), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final searchTerm = _searchController.text.trim().toLowerCase();
    final filtered = _places.where((place) {
      if (searchTerm.isEmpty) return true;
      return place.name.toLowerCase().contains(searchTerm) ||
          place.address.toLowerCase().contains(searchTerm) ||
          place.type.toLowerCase().contains(searchTerm);
    }).toList();

    return AppLayout(
      title: 'Map & Nearby Spots',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nearby stores, parks, vets, and grooming',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The page scrolls as a single experience now, so the map, filters, and locations stay in one flow.',
                      style: TextStyle(color: AppTheme.mutedText, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search parks, vets, or stores',
                        prefixIcon: Icon(LucideIcons.search),
                      ),
                    ),
                    if (_isRequestingLocation) ...[
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(),
                    ],
                    if (_locationError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _locationError!,
                        style: const TextStyle(color: AppTheme.destructive),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _openGoogleMaps,
              child: Card(
                child: SizedBox(
                  height: 310,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD9EEE5),
                              Color(0xFFEAF1D6),
                              Color(0xFFE8EDF7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(painter: _GridPainter()),
                      ),
                      Positioned.fill(
                        child: CustomPaint(painter: _RoadPainter()),
                      ),
                      if (_location != null)
                        const Positioned(
                          left: 170,
                          top: 138,
                          child: _MapMarker(
                            color: Colors.red,
                            icon: Icons.circle,
                          ),
                        ),
                      ...filtered.map(
                        (place) => Positioned(
                          left: place.x / 100 * 320,
                          top: place.y / 100 * 270,
                          child: _MapMarker(
                            color: _placeColor(place.type),
                            icon: _placeIcon(place.type),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: const [
                              Icon(LucideIcons.externalLink, size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tap the map to open Google Maps',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Legend(label: 'Pet Store', color: Color(0xFF3B82F6)),
                _Legend(label: 'Dog Park', color: Color(0xFF22C55E)),
                _Legend(label: 'Groomer', color: Color(0xFF8B5CF6)),
                _Legend(label: 'Vet', color: Color(0xFFEC4899)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Nearby results (${filtered.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...filtered.map(
              (place) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _placeColor(
                              place.type,
                            ).withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _placeIcon(place.type),
                            color: _placeColor(place.type),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                place.address,
                                style: const TextStyle(
                                  color: AppTheme.mutedText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${place.distance} • ${place.rating} stars',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, size: 12, color: Colors.white),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.mutedText.withValues(alpha: 0.16)
      ..strokeWidth = 0.5;

    const step = 36.0;
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
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.78)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final dividerPaint = Paint()
      ..color = const Color(0xFFD8C78C)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pathA = Path()
      ..moveTo(0, size.height * 0.24)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.15,
        size.width,
        size.height * 0.34,
      );
    final pathB = Path()
      ..moveTo(size.width * 0.15, 0)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.42,
        size.width * 0.55,
        size.height,
      );

    canvas.drawPath(pathA, roadPaint);
    canvas.drawPath(pathB, roadPaint);
    canvas.drawPath(pathA, dividerPaint);
    canvas.drawPath(pathB, dividerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Color _placeColor(String type) {
  switch (type) {
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

IconData _placeIcon(String type) {
  switch (type) {
    case 'park':
      return LucideIcons.mapPin;
    case 'groomer':
      return LucideIcons.scissors;
    case 'vet':
      return LucideIcons.heart;
    default:
      return LucideIcons.mapPin;
  }
}

class _NearbyPlace {
  const _NearbyPlace(
    this.name,
    this.distance,
    this.address,
    this.rating,
    this.type,
    this.x,
    this.y,
  );

  final String name;
  final String distance;
  final String address;
  final double rating;
  final String type;
  final double x;
  final double y;
}

class _Location {
  const _Location({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
