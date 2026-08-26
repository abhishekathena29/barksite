import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const _settingsCollection = 'settings';
  static const _settingsDocument = 'gemini';

  static Future<_GeminiConfig> _loadConfig({
    FirebaseFirestore? firestore,
  }) async {
    final instance = firestore ?? FirebaseFirestore.instance;
    final snapshot = await instance
        .collection(_settingsCollection)
        .doc(_settingsDocument)
        .get();

    if (!snapshot.exists) {
      throw StateError(
        'Missing Firestore config at $_settingsCollection/$_settingsDocument.',
      );
    }

    final data = snapshot.data();
    if (data == null) {
      throw StateError(
        'Gemini config at $_settingsCollection/$_settingsDocument is empty.',
      );
    }

    final apiKey = data['apiKey']?.toString().trim() ?? '';
    final modelName =
        (data['modelName'] ?? data['model'])?.toString().trim() ?? '';

    if (apiKey.isEmpty) {
      throw StateError(
        'Missing "apiKey" in Firestore config at $_settingsCollection/$_settingsDocument.',
      );
    }

    if (modelName.isEmpty) {
      throw StateError(
        'Missing "modelName" in Firestore config at $_settingsCollection/$_settingsDocument.',
      );
    }

    return _GeminiConfig(apiKey: apiKey, modelName: modelName);
  }

  static Future<List<Map<String, dynamic>>> generateDietPlans({
    required String dogName,
    required String breed,
    required String age,
    required String weight,
    required String activityLevel,
    String? healthConditions,
    String? allergies,
    String? foodPreference,
    String? notes,
    FirebaseFirestore? firestore,
  }) async {
    final config = await _loadConfig(firestore: firestore);
    final model = GenerativeModel(
      model: config.modelName,
      apiKey: config.apiKey,
    );

    final prompt =
        '''
Generate 6 personalized dog diet plans suited for India for the following dog:
Name: $dogName
Breed: $breed
Age: $age years
Weight: $weight kg
Activity Level: $activityLevel
Health Conditions: ${healthConditions?.isNotEmpty == true ? healthConditions : 'None'}
Allergies: ${allergies?.isNotEmpty == true ? allergies : 'None'}
Food Preference: ${foodPreference?.isNotEmpty == true ? foodPreference : 'No preference'}
Additional Notes: ${notes?.isNotEmpty == true ? notes : 'None'}

Return ONLY a valid JSON object with no markdown, no extra text, in this exact structure:
{
  "plans": [
    {
      "id": "unique_snake_case_id",
      "name": "Plan Name",
      "description": "Short one-line description",
      "calories": 1200,
      "protein": "25-30%",
      "meals": 2,
      "recommended": true,
      "features": ["feature1", "feature2", "feature3", "feature4"],
      "proteins": ["Chicken 20%", "Fish 15%", "Eggs 10%"],
      "carbs": ["Brown rice", "Sweet potato", "Moong dal"],
      "supplements": ["Turmeric", "Calcium", "Omega-3"],
      "schedule": {
        "morning": "7:00-8:00 AM (50%)",
        "evening": "6:00-7:00 PM (50%)"
      }
    }
  ]
}

Important guidelines:
- Use Indian ingredients widely available across India
- Proteins: Chicken, Mutton (in moderation), Rohu/Catla/Pomfret fish, Eggs, Paneer (vegetarian option), Moong dal
- Carbs: Basmati rice, Brown rice, Ragi (finger millet), Jowar (sorghum), Sweet potato, Oats, Boiled potato
- Supplements: Turmeric (haldi), Coconut oil, Neem, Triphala, Calcium from bone broth or eggshell, Ashwagandha
- Calculate calories appropriate for the dog weight in kg (RER = 70 × weight^0.75, then multiply by activity factor)
- Activity factors: low=1.2, moderate=1.6, high=2.0, very-high=2.4; reduce 10% for seniors (age>7), increase 50% for puppies (age<1)
- Only ONE plan should have "recommended": true — pick the most suitable for this dog's profile
- Vary meals/day: 2 for adults, 3 for active/weight-management, 4 for puppies
- Schedule times should be in IST (India Standard Time) context
- Plans should cover different needs: balanced, high-protein, senior care (if applicable), weight management, grain-free or home-cooked, puppy growth (if applicable), sensitive stomach, joint health, etc.
- Adapt plans based on health conditions and allergies provided
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';

    String jsonStr = text.trim();
    // Strip markdown code fences if Gemini wraps the JSON
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr
          .replaceAll(RegExp(r'```json?\s*'), '')
          .replaceAll('```', '')
          .trim();
    }

    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['plans'] as List);
  }
}

class _GeminiConfig {
  const _GeminiConfig({required this.apiKey, required this.modelName});

  final String apiKey;
  final String modelName;
}
