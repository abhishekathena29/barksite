import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../theme.dart';

class BrandStoresPage extends StatefulWidget {
  const BrandStoresPage({super.key});

  @override
  State<BrandStoresPage> createState() => _BrandStoresPageState();
}

class _BrandStoresPageState extends State<BrandStoresPage> {
  String _searchTerm = '';
  String _locationFilter = 'all';
  String _storeTypeFilter = 'all';

  final List<_Store> _stores = [
    _Store(
      id: 1,
      name: 'PetSmart',
      type: 'Chain Store',
      location: 'Downtown',
      address: '123 Main Street, City Center',
      phone: '(555) 123-4567',
      hours: 'Mon-Sat: 9AM-9PM, Sun: 10AM-7PM',
      brandsCarried: ['Royal Canin', "Hill's Science Diet", 'Blue Buffalo', 'Purina Pro Plan', 'Iams'],
      specialties: ['Large selection', 'Grooming services', 'Veterinary clinic'],
      distance: '0.5 miles',
    ),
    _Store(
      id: 2,
      name: 'Petco',
      type: 'Chain Store',
      location: 'Mall District',
      address: '456 Shopping Center Blvd',
      phone: '(555) 234-5678',
      hours: 'Mon-Sat: 9AM-9PM, Sun: 10AM-6PM',
      brandsCarried: ['Wellness Core', 'Merrick', 'Blue Buffalo', 'Taste of the Wild', "Nature's Recipe"],
      specialties: ['Training classes', 'Adoption center', 'Full-service grooming'],
      distance: '1.2 miles',
    ),
    _Store(
      id: 3,
      name: 'Local Pet Paradise',
      type: 'Independent Store',
      location: 'Westside',
      address: '789 Pet Lover Lane',
      phone: '(555) 345-6789',
      hours: 'Mon-Fri: 10AM-7PM, Sat: 9AM-8PM, Sun: 11AM-5PM',
      brandsCarried: ['Orijen', 'Wellness Core', 'Merrick', 'Diamond Naturals', 'Taste of the Wild'],
      specialties: ['Premium brands', 'Nutritional consulting', 'Local favorites'],
      distance: '2.1 miles',
    ),
    _Store(
      id: 4,
      name: 'Farm and Feed Supply',
      type: 'Farm Store',
      location: 'Rural Route',
      address: '321 Country Road',
      phone: '(555) 456-7890',
      hours: 'Mon-Sat: 8AM-6PM, Sun: 10AM-4PM',
      brandsCarried: ['Diamond Naturals', 'Taste of the Wild', 'Purina Pro Plan', 'Purina ONE'],
      specialties: ['Bulk pricing', 'Farm delivery', 'Working dog nutrition'],
      distance: '5.3 miles',
    ),
    _Store(
      id: 5,
      name: 'Walmart Supercenter',
      type: 'Big Box Store',
      location: 'North Side',
      address: '654 Highway 10',
      phone: '(555) 567-8901',
      hours: '24 hours',
      brandsCarried: ['Pedigree', 'Old Roy', 'Iams', 'Purina ONE', 'Rachael Ray Nutrish'],
      specialties: ['Budget-friendly', '24/7 availability', 'Pharmacy pickup'],
      distance: '3.7 miles',
    ),
    _Store(
      id: 6,
      name: 'VetCare Animal Hospital',
      type: 'Veterinary Clinic',
      location: 'Medical District',
      address: '987 Health Plaza',
      phone: '(555) 678-9012',
      hours: 'Mon-Fri: 8AM-6PM, Sat: 9AM-2PM',
      brandsCarried: ["Hill's Science Diet", 'Royal Canin', 'Purina Pro Plan Veterinary Diets'],
      specialties: ['Prescription diets', 'Veterinary consultation', 'Therapeutic nutrition'],
      distance: '1.8 miles',
    ),
    _Store(
      id: 7,
      name: 'Healthy Paws Boutique',
      type: 'Specialty Store',
      location: 'Uptown',
      address: '147 Trendy Street',
      phone: '(555) 789-0123',
      hours: 'Tue-Sat: 11AM-7PM, Sun: 12PM-5PM',
      brandsCarried: ['Orijen', 'Wellness Core', 'Merrick', 'Blue Buffalo'],
      specialties: ['Organic options', 'Raw food diets', 'Holistic nutrition'],
      distance: '2.8 miles',
    ),
    _Store(
      id: 8,
      name: 'Tractor Supply Co.',
      type: 'Farm Store',
      location: 'Industrial Area',
      address: '258 Industrial Parkway',
      phone: '(555) 890-1234',
      hours: 'Mon-Sat: 8AM-8PM, Sun: 9AM-7PM',
      brandsCarried: ['Diamond Naturals', 'Taste of the Wild', 'Purina Pro Plan', "Nature's Recipe"],
      specialties: ['Large bags', 'Livestock feed', 'Rural delivery'],
      distance: '4.2 miles',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final brandName = args?['brand'] as String? ?? 'All Brands';

    final filtered = _stores.where((store) {
      final matchesSearch = store.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          store.location.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          store.brandsCarried.any((b) => b.toLowerCase().contains(_searchTerm.toLowerCase()));
      final matchesLocation = _locationFilter == 'all' || store.location.toLowerCase().contains(_locationFilter);
      final matchesType = _storeTypeFilter == 'all' || store.type.toLowerCase().contains(_storeTypeFilter);
      final matchesBrand = brandName == 'All Brands' || store.brandsCarried.contains(brandName);
      return matchesSearch && matchesLocation && matchesType && matchesBrand;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Locations', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/food-brands'),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF2E5), Color(0xFFFFF6DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (brandName != 'All Brands')
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Stores carrying $brandName',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9A5A1E)),
                  ),
                ),
              const Text(
                'Find local stores, pet shops, and retailers where you can purchase premium dog food brands near you.',
                style: TextStyle(color: AppTheme.mutedText),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search stores or brands...',
                          prefixIcon: Icon(LucideIcons.search, size: 18),
                        ),
                        onChanged: (value) => setState(() => _searchTerm = value),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _FilterDropdown(
                              label: 'Location',
                              value: _locationFilter,
                              items: const ['all', 'downtown', 'mall', 'westside', 'north', 'uptown'],
                              onChanged: (value) => setState(() => _locationFilter = value ?? 'all'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _FilterDropdown(
                              label: 'Store Type',
                              value: _storeTypeFilter,
                              items: const ['all', 'chain', 'independent', 'farm', 'veterinary', 'specialty'],
                              onChanged: (value) => setState(() => _storeTypeFilter = value ?? 'all'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text('No stores found matching your criteria.', style: TextStyle(color: AppTheme.mutedText)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _searchTerm = '';
                        _locationFilter = 'all';
                        _storeTypeFilter = 'all';
                      }),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA6A2B), foregroundColor: Colors.white),
                      child: const Text('Clear Filters'),
                    ),
                  ],
                )
              else
                ...filtered.map((store) => _StoreCard(store: store)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});
  final _Store store;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(store.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF9A5A1E))),
                _Pill(text: store.type, color: _storeTypeColor(store.type)),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(icon: LucideIcons.mapPin, value: store.address),
            _InfoRow(icon: LucideIcons.phone, value: store.phone),
            _InfoRow(icon: LucideIcons.clock, value: store.hours),
            _InfoRow(icon: LucideIcons.navigation, value: '${store.distance} away', bold: true),
            const SizedBox(height: 10),
            const Text('Brands Available:', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF9A5A1E), fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: store.brandsCarried.map((b) => _Pill(text: b, color: AppTheme.muted)).toList(),
            ),
            const SizedBox(height: 10),
            const Text('Store Specialties:', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF9A5A1E), fontSize: 12)),
            const SizedBox(height: 6),
            Column(
              children: store.specialties
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFEA6A2B), shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(s, style: const TextStyle(fontSize: 12, color: AppTheme.mutedText))),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA6A2B), foregroundColor: Colors.white),
                    child: const Text('Get Directions'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Call Store'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value, this.bold = false});
  final IconData icon;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFEA6A2B)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: bold ? const Color(0xFF9A5A1E) : AppTheme.mutedText, fontWeight: bold ? FontWeight.w600 : FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.label, required this.value, required this.items, required this.onChanged});

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item == 'all' ? 'All' : _capitalize(item), style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

Color _storeTypeColor(String type) {
  switch (type) {
    case 'Chain Store':
      return const Color(0xFFDBEAFE);
    case 'Independent Store':
      return const Color(0xFFDCFCE7);
    case 'Farm Store':
      return const Color(0xFFFDE68A);
    case 'Veterinary Clinic':
      return const Color(0xFFE9D5FF);
    case 'Specialty Store':
      return const Color(0xFFFBCFE8);
    case 'Big Box Store':
      return const Color(0xFFF1F5F9);
    default:
      return const Color(0xFFF1F5F9);
  }
}

class _Store {
  const _Store({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.address,
    required this.phone,
    required this.hours,
    required this.brandsCarried,
    required this.specialties,
    required this.distance,
  });

  final int id;
  final String name;
  final String type;
  final String location;
  final String address;
  final String phone;
  final String hours;
  final List<String> brandsCarried;
  final List<String> specialties;
  final String distance;
}
