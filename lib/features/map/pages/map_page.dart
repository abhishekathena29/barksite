import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme.dart';
import '../../../widgets/app_layout.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _searchController = TextEditingController();

  final List<_NearbyPlace> _places = [
    _NearbyPlace(
      'Friendicoes SECA',
      '3.2 km',
      'Jangpura B, South Delhi',
      4.8,
      'vet',
      30,
      62,
    ),
    _NearbyPlace(
      'All Creatures Veterinary Hospital',
      '8.5 km',
      'Vasant Vihar, New Delhi',
      4.9,
      'vet',
      70,
      40,
    ),
    _NearbyPlace(
      'PetZone Delhi',
      '5.1 km',
      'Lajpat Nagar II, New Delhi',
      4.5,
      'store',
      55,
      72,
    ),
    _NearbyPlace(
      'Dog Zone India',
      '6.8 km',
      'Saket District Centre, New Delhi',
      4.6,
      'groomer',
      62,
      82,
    ),
    _NearbyPlace(
      'Pawsome Pet Shop',
      '7.2 km',
      'Rajouri Garden, West Delhi',
      4.4,
      'store',
      18,
      35,
    ),
    _NearbyPlace(
      'The Dog Cafe',
      '4.9 km',
      'Hauz Khas Village, New Delhi',
      4.7,
      'cafe',
      45,
      55,
    ),
    _NearbyPlace(
      'Deer Park Delhi',
      '5.3 km',
      'Hauz Khas, New Delhi',
      4.8,
      'park',
      40,
      46,
    ),
    _NearbyPlace(
      'K9 Club Grooming & Boarding',
      '6.1 km',
      'Greater Kailash I, New Delhi',
      4.6,
      'groomer',
      65,
      66,
    ),
    _NearbyPlace(
      'DogSpot Store',
      '9.0 km',
      'Connaught Place, New Delhi',
      4.3,
      'store',
      50,
      24,
    ),
    _NearbyPlace(
      'Delhi Pet Hospital',
      '12.5 km',
      'Pitampura, North Delhi',
      4.5,
      'vet',
      26,
      18,
    ),
    _NearbyPlace(
      'Barks & Bites Cafe',
      '7.8 km',
      'Shahpur Jat, New Delhi',
      4.6,
      'cafe',
      58,
      60,
    ),
    _NearbyPlace(
      'Pets & Vets Clinic',
      '4.2 km',
      'Green Park, New Delhi',
      4.7,
      'vet',
      42,
      38,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      title: 'Delhi Dog Spots',
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
                      'Stores, cafes, vets & parks in Delhi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find the best dog-friendly places in and around Delhi — from vet clinics and groomers to pet cafes and parks.',
                      style: TextStyle(color: AppTheme.mutedText, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search cafes, vets, stores or parks',
                        prefixIcon: Icon(LucideIcons.search),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Card(
            //   child: SizedBox(
            //     height: 310,
            //     child: Stack(
            //       children: [
            //         Container(
            //           decoration: const BoxDecoration(
            //             gradient: LinearGradient(
            //               colors: [
            //                 Color(0xFFD9EEE5),
            //                 Color(0xFFEAF1D6),
            //                 Color(0xFFE8EDF7),
            //               ],
            //               begin: Alignment.topLeft,
            //               end: Alignment.bottomRight,
            //             ),
            //           ),
            //         ),
            //         Positioned.fill(
            //           child: CustomPaint(painter: _GridPainter()),
            //         ),
            //         Positioned.fill(
            //           child: CustomPaint(painter: _RoadPainter()),
            //         ),
            //         ...filtered.map(
            //           (place) => Positioned(
            //             left: place.x / 100 * 320,
            //             top: place.y / 100 * 270,
            //             child: _MapMarker(
            //               color: _placeColor(place.type),
            //               icon: _placeIcon(place.type),
            //             ),
            //           ),
            //         ),
            //         Positioned(
            //           left: 14,
            //           right: 14,
            //           bottom: 14,
            //           child: Container(
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 14,
            //               vertical: 10,
            //             ),
            //             decoration: BoxDecoration(
            //               color: Colors.white.withValues(alpha: 0.92),
            //               borderRadius: BorderRadius.circular(18),
            //             ),
            //             child: Row(
            //               children: const [
            //                 Icon(LucideIcons.mapPin, size: 16),
            //                 SizedBox(width: 8),
            //                 Expanded(
            //                   child: Text(
            //                     'Dog-friendly spots across Delhi NCR',
            //                     style: TextStyle(fontWeight: FontWeight.w600),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Legend(label: 'Pet Store', color: Color(0xFF3B82F6)),
                _Legend(label: 'Dog Park', color: Color(0xFF22C55E)),
                _Legend(label: 'Groomer', color: Color(0xFF8B5CF6)),
                _Legend(label: 'Vet', color: Color(0xFFEC4899)),
                _Legend(label: 'Dog Cafe', color: Color(0xFFF97316)),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _placeColor(
                              place.type,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _placeLabel(place.type),
                            style: TextStyle(
                              fontSize: 10,
                              color: _placeColor(place.type),
                              fontWeight: FontWeight.w600,
                            ),
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
    case 'cafe':
      return const Color(0xFFF97316);
    default:
      return const Color(0xFF3B82F6);
  }
}

IconData _placeIcon(String type) {
  switch (type) {
    case 'park':
      return LucideIcons.trees;
    case 'groomer':
      return LucideIcons.scissors;
    case 'vet':
      return LucideIcons.stethoscope;
    case 'cafe':
      return LucideIcons.coffee;
    default:
      return LucideIcons.shoppingBag;
  }
}

String _placeLabel(String type) {
  switch (type) {
    case 'park':
      return 'Dog Park';
    case 'groomer':
      return 'Groomer';
    case 'vet':
      return 'Veterinary';
    case 'cafe':
      return 'Dog Cafe';
    default:
      return 'Pet Store';
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
