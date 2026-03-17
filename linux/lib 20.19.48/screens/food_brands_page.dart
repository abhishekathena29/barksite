import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme.dart';

class FoodBrandsPage extends StatefulWidget {
  const FoodBrandsPage({super.key});

  @override
  State<FoodBrandsPage> createState() => _FoodBrandsPageState();
}

class _FoodBrandsPageState extends State<FoodBrandsPage> {
  String _searchTerm = '';
  String _priceFilter = 'all';
  String _typeFilter = 'all';

  final List<_Brand> _brands = [
    _Brand(
      id: 1,
      name: 'Royal Canin',
      type: 'International',
      price: 'Premium',
      rating: 4.8,
      description: 'Scientifically formulated nutrition for specific breeds and life stages',
      features: ['Breed-specific formulas', 'Veterinary recommended', 'High digestibility'],
      priceRange: '\$60-80',
      availability: 'Nationwide',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 2,
      name: "Hill's Science Diet",
      type: 'International',
      price: 'Premium',
      rating: 4.7,
      description: 'Clinically proven nutrition backed by veterinary science',
      features: ['Veterinary exclusive', 'Therapeutic formulas', 'Clinical studies'],
      priceRange: '\$55-75',
      availability: 'Veterinary clinics',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 3,
      name: 'Blue Buffalo',
      type: 'Local',
      price: 'Mid-range',
      rating: 4.5,
      description: 'Natural ingredients with real meat as the first ingredient',
      features: ['No by-product meals', 'Natural ingredients', 'LifeSource Bits'],
      priceRange: '\$45-60',
      availability: 'Pet stores nationwide',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 4,
      name: 'Purina Pro Plan',
      type: 'International',
      price: 'Mid-range',
      rating: 4.6,
      description: 'Advanced nutrition with real meat as the #1 ingredient',
      features: ['Sport formulas', 'Probiotics', 'Targeted nutrition'],
      priceRange: '\$40-55',
      availability: 'Major retailers',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 5,
      name: 'Orijen',
      type: 'International',
      price: 'Premium',
      rating: 4.9,
      description: 'Biologically appropriate nutrition with fresh, local ingredients',
      features: ['85% meat inclusion', 'Fresh ingredients', 'No grain meals'],
      priceRange: '\$80-120',
      availability: 'Specialty pet stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 6,
      name: 'Wellness Core',
      type: 'Local',
      price: 'Premium',
      rating: 4.4,
      description: 'Grain-free, protein-rich nutrition for optimal health',
      features: ['Grain-free', 'High protein', 'Natural ingredients'],
      priceRange: '\$50-70',
      availability: 'Independent pet stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 7,
      name: 'Taste of the Wild',
      type: 'Local',
      price: 'Mid-range',
      rating: 4.3,
      description: 'Inspired by nature with real roasted meat and novel proteins',
      features: ['Grain-free', 'Novel proteins', 'Probiotics'],
      priceRange: '\$35-50',
      availability: 'Farm stores and online',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 8,
      name: 'Merrick',
      type: 'Local',
      price: 'Premium',
      rating: 4.5,
      description: 'Real whole foods with deboned meat as the first ingredient',
      features: ['Real whole foods', 'Grain-free options', 'USA made'],
      priceRange: '\$55-75',
      availability: 'Local pet retailers',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 9,
      name: 'Pedigree',
      type: 'International',
      price: 'Budget',
      rating: 4.1,
      description: 'Complete and balanced nutrition for everyday feeding',
      features: ['Affordable nutrition', 'Widely available', 'Variety of flavors'],
      priceRange: '\$15-25',
      availability: 'Supermarkets nationwide',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 10,
      name: "Kibbles 'n Bits",
      type: 'Local',
      price: 'Budget',
      rating: 3.9,
      description: 'Tasty chunks and kibbles with real meat and vegetables',
      features: ['Colorful pieces', 'Real meat', 'Budget-friendly'],
      priceRange: '\$12-20',
      availability: 'Grocery stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 11,
      name: 'Iams',
      type: 'International',
      price: 'Budget',
      rating: 4.2,
      description: 'Proactive health nutrition with quality protein sources',
      features: ['Proactive health', 'Quality protein', 'Digestive health'],
      priceRange: '\$18-30',
      availability: 'Pet stores and supermarkets',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 12,
      name: 'Purina ONE',
      type: 'International',
      price: 'Budget',
      rating: 4.3,
      description: 'SmartBlend of high-quality ingredients for optimal nutrition',
      features: ['SmartBlend formula', 'Real meat', 'Omega fatty acids'],
      priceRange: '\$20-35',
      availability: 'Major retailers',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 13,
      name: 'Diamond Naturals',
      type: 'Local',
      price: 'Mid-range',
      rating: 4.4,
      description: 'Premium nutrition with cage-free chicken and sweet potatoes',
      features: ['Cage-free chicken', 'Sweet potatoes', 'Probiotics'],
      priceRange: '\$30-45',
      availability: 'Farm and feed stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 14,
      name: 'Rachael Ray Nutrish',
      type: 'Local',
      price: 'Budget',
      rating: 4.0,
      description: 'Real meat recipes with no meat by-products or fillers',
      features: ['No by-products', 'Real recipes', 'Celebrity endorsed'],
      priceRange: '\$22-32',
      availability: 'Grocery and pet stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 15,
      name: "Nature's Recipe",
      type: 'Local',
      price: 'Budget',
      rating: 4.1,
      description: 'Simple, wholesome nutrition with easy-to-recognize ingredients',
      features: ['Simple ingredients', 'Limited ingredients', 'Natural nutrition'],
      priceRange: '\$25-35',
      availability: 'Pet specialty stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
    _Brand(
      id: 16,
      name: 'Old Roy',
      type: 'Local',
      price: 'Budget',
      rating: 3.8,
      description: 'Complete nutrition at an affordable price for all life stages',
      features: ['All life stages', 'Affordable', 'Complete nutrition'],
      priceRange: '\$10-18',
      availability: 'Walmart stores',
      imageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _brands.where((brand) {
      final matchesSearch = brand.name.toLowerCase().contains(_searchTerm.toLowerCase()) ||
          brand.description.toLowerCase().contains(_searchTerm.toLowerCase());
      final matchesPrice = _priceFilter == 'all' || brand.price.toLowerCase() == _priceFilter;
      final matchesType = _typeFilter == 'all' || brand.type.toLowerCase() == _typeFilter;
      return matchesSearch && matchesPrice && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Dog Food Brands', style: TextStyle(fontWeight: FontWeight.w700)),
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
              const Text(
                'Discover local and international premium dog food brands selected for quality and nutrition.',
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
                          hintText: 'Search brands...',
                          prefixIcon: Icon(LucideIcons.search, size: 18),
                        ),
                        onChanged: (value) => setState(() => _searchTerm = value),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _FilterDropdown(
                              label: 'Price Range',
                              value: _priceFilter,
                              items: const ['all', 'budget', 'mid-range', 'premium'],
                              onChanged: (value) => setState(() => _priceFilter = value ?? 'all'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _FilterDropdown(
                              label: 'Brand Type',
                              value: _typeFilter,
                              items: const ['all', 'local', 'international'],
                              onChanged: (value) => setState(() => _typeFilter = value ?? 'all'),
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
                    const Text('No brands found matching your criteria.', style: TextStyle(color: AppTheme.mutedText)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _searchTerm = '';
                        _priceFilter = 'all';
                        _typeFilter = 'all';
                      }),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA6A2B), foregroundColor: Colors.white),
                      child: const Text('Clear Filters'),
                    ),
                  ],
                )
              else
                ...filtered.map((brand) => _BrandCard(brand: brand)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.brand});
  final _Brand brand;

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
              children: [
                Expanded(
                  child: Text(brand.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF9A5A1E))),
                ),
                Row(
                  children: [
                    const Icon(LucideIcons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(brand.rating.toStringAsFixed(1), style: const TextStyle(color: AppTheme.mutedText)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: [
                _Pill(text: brand.price, color: _priceColor(brand.price)),
                _Pill(text: brand.type, color: _typeColor(brand.type)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(brand.imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(brand.description, style: const TextStyle(color: AppTheme.mutedText)),
            const SizedBox(height: 10),
            const Text('Key Features:', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF9A5A1E), fontSize: 12)),
            const SizedBox(height: 6),
            Column(
              children: brand.features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.award, size: 14, color: Color(0xFFEA6A2B)),
                          const SizedBox(width: 6),
                          Expanded(child: Text(feature, style: const TextStyle(fontSize: 12, color: AppTheme.mutedText))),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            _InfoRow(icon: LucideIcons.dollarSign, label: 'Price Range', value: brand.priceRange),
            _InfoRow(icon: LucideIcons.mapPin, label: 'Available', value: brand.availability),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/brand-stores', arguments: {'brand': brand.name});
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA6A2B), foregroundColor: Colors.white),
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFFEA6A2B)),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: AppTheme.mutedText, fontSize: 12)),
            ],
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF9A5A1E), fontSize: 12)),
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
      child: Text(text, style: const TextStyle(fontSize: 11)),
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
              child: Text(
                item == 'all' ? 'All' : _capitalize(item),
                style: const TextStyle(fontSize: 12),
              ),
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

Color _priceColor(String price) {
  switch (price.toLowerCase()) {
    case 'premium':
      return const Color(0xFFF3E8FF);
    case 'mid-range':
      return const Color(0xFFE0F2FE);
    case 'budget':
      return const Color(0xFFDCFCE7);
    default:
      return const Color(0xFFF1F5F9);
  }
}

Color _typeColor(String type) {
  return type == 'Local' ? const Color(0xFFFFEDD5) : const Color(0xFFE0E7FF);
}

class _Brand {
  const _Brand({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
    required this.description,
    required this.features,
    required this.priceRange,
    required this.availability,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String type;
  final String price;
  final double rating;
  final String description;
  final List<String> features;
  final String priceRange;
  final String availability;
  final String imageUrl;
}
