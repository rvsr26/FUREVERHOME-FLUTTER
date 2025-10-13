import 'package:flutter/material.dart';
import 'adopt_pet_page.dart';

import 'Login_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_wiki_page.dart';
import 'services_page.dart';
import 'gemini_chat_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'know_the_sound_page.dart';
import 'dart:io';
import 'community_feed_page.dart';
import 'choosepet.dart';
import 'donate_volunteer_page.dart';

// In home_page.dart, add global list to store adopted pets
List<Map<String, String>> adoptedPets = [];

typedef ThemeChangedCallback = void Function(bool isDark);

class HomePage extends StatefulWidget {
  final int initialIndex; // initial category index
  final ThemeChangedCallback? onThemeChanged;
  final bool? isDark;

  const HomePage({
    super.key,
    this.initialIndex = 0,
    this.onThemeChanged,
    this.isDark,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  late int selectedIndex;
  String _avatarPath = "assets/avatar.png";
  bool _isAssetAvatar = true;

  final List<String> categories = ["Dogs", "Cats", "Birds", "Other"];

  final Map<String, List<Map<String, String>>> petsByCategory = {
    "Cats": [
      {
        "name": "Mono LaMi",
        "breed": "British Shorthair",
        "age": "1 year",
        "gender": "Female",
        "weight": "4.5kg",
        "food": "Royal Canin, Whiskas, Chicken",
        "other":
            "Calm, affectionate, loves to nap in sunny spots. Vaccinated, litter trained.",
        "image": "assets/cat1.png",
      },
      {
        "name": "Amila Marko",
        "breed": "LaPerm Cat",
        "age": "2 years",
        "gender": "Female",
        "weight": "3.8kg",
        "food": "Whiskas, Tuna, Salmon",
        "other": "Playful, curly fur, enjoys chasing toys. Good with children.",
        "image": "assets/cat2.png",
      },
      {
        "name": "Simba",
        "breed": "Maine Coon",
        "age": "3 years",
        "gender": "Male",
        "weight": "7.2kg",
        "food": "Royal Canin, Chicken, Turkey",
        "other":
            "Large, gentle, loves water and cuddles. Healthy, microchipped.",
        "image": "assets/cat3.png",
      },
      {
        "name": "Luna",
        "breed": "Siamese",
        "age": "2 years",
        "gender": "Female",
        "weight": "4.0kg",
        "food": "Whiskas, Fish, Chicken",
        "other": "Vocal, intelligent, loves attention. Indoor only, spayed.",
        "image": "assets/catto.jpg",
      },
      {
        "name": "Oliver",
        "breed": "Persian",
        "age": "4 years",
        "gender": "Male",
        "weight": "5.5kg",
        "food": "Royal Canin, Lamb, Chicken",
        "other":
            "Fluffy, quiet, prefers calm environments. Needs regular grooming.",
        "image": "assets/cat1.png",
      },
      {
        "name": "Milo",
        "breed": "Ragdoll",
        "age": "1 year",
        "gender": "Male",
        "weight": "5.0kg",
        "food": "Whiskas, Chicken, Tuna",
        "other": "Blue eyes, floppy, loves to be held. Good with other pets.",
        "image": "assets/cat2.png",
      },
      {
        "name": "Nala",
        "breed": "Bengal",
        "age": "5 years",
        "gender": "Female",
        "weight": "6.0kg",
        "food": "Royal Canin, Fish, Chicken",
        "other":
            "Energetic, loves climbing, beautiful markings. Needs space to play.",
        "image": "assets/cat3.png",
      },
    ],
    "Dogs": [
      {
        "name": "Rocky",
        "breed": "Golden Retriever",
        "age": "3 years",
        "gender": "Male",
        "weight": "32kg",
        "food": "Pedigree, Chicken, Rice",
        "other":
            "Friendly, loves fetch and swimming. Great with families, vaccinated.",
        "image": "assets/dog1.png",
      },
      {
        "name": "Bella",
        "breed": "German Shepherd",
        "age": "2 years",
        "gender": "Female",
        "weight": "28kg",
        "food": "Pedigree, Beef, Lamb",
        "other": "Loyal, intelligent, good guard dog. Trained, spayed.",
        "image": "assets/dog2.png",
      },
      {
        "name": "Max",
        "breed": "Labrador",
        "age": "4 years",
        "gender": "Male",
        "weight": "30kg",
        "food": "Pedigree, Chicken, Fish",
        "other":
            "Energetic, loves walks, gentle with kids. Needs daily exercise.",
        "image": "assets/dog3.png",
      },
      {
        "name": "Daisy",
        "breed": "Beagle",
        "age": "1 year",
        "gender": "Female",
        "weight": "10kg",
        "food": "Pedigree, Turkey, Carrots",
        "other": "Curious, loves sniffing, playful. Good for active owners.",
        "image": "assets/dog4.png",
      },
      {
        "name": "Charlie",
        "breed": "Pug",
        "age": "2 years",
        "gender": "Male",
        "weight": "8kg",
        "food": "Pedigree, Chicken, Rice",
        "other": "Comical, affectionate, loves cuddles. Indoor dog, healthy.",
        "image": "assets/dog5.png",
      },
      {
        "name": "Lucy",
        "breed": "Shih Tzu",
        "age": "3 years",
        "gender": "Female",
        "weight": "6kg",
        "food": "Pedigree, Lamb, Carrots",
        "other":
            "Small, sweet, loves laps. Needs regular grooming, vaccinated.",
        "image": "assets/doggo.jpg",
      },
      {
        "name": "Cooper",
        "breed": "Boxer",
        "age": "5 years",
        "gender": "Male",
        "weight": "27kg",
        "food": "Pedigree, Beef, Chicken",
        "other":
            "Athletic, playful, good with older kids. Neutered, microchipped.",
        "image": "assets/dog1.png",
      },
    ],
    "Birds": [
      {
        "name": "Kiwi",
        "breed": "Parrot",
        "age": "1 year",
        "gender": "Female",
        "weight": "0.9kg",
        "food": "Fruits, Seeds, Nuts",
        "other": "Talks, loves fruit, enjoys shoulder rides. Cage included.",
        "image": "assets/parrot.png",
      },
      {
        "name": "Coco",
        "breed": "Cockatiel",
        "age": "2 years",
        "gender": "Male",
        "weight": "0.1kg",
        "food": "Seeds, Millet, Apple",
        "other":
            "Whistles tunes, friendly, hand-tamed. Needs daily interaction.",
        "image": "assets/cock.png",
      },
      {
        "name": "Sunny",
        "breed": "Budgerigar",
        "age": "1 year",
        "gender": "Male",
        "weight": "0.04kg",
        "food": "Seeds, Greens, Carrot",
        "other": "Colorful, active, loves mirrors. Easy to care for.",
        "image": "assets/bud.png",
      },
      {
        "name": "Sky",
        "breed": "Lovebird",
        "age": "2 years",
        "gender": "Female",
        "weight": "0.05kg",
        "food": "Seeds, Fruits, Spinach",
        "other": "Social, loves company, beautiful feathers. Cage trained.",
        "image": "assets/bird4.png",
      },
      {
        "name": "Peach",
        "breed": "Finch",
        "age": "3 years",
        "gender": "Female",
        "weight": "0.02kg",
        "food": "Seeds, Eggfood, Greens",
        "other": "Small, sings, easy to keep. Good for beginners.",
        "image": "assets/finch.jpg",
      },
      {
        "name": "Blue",
        "breed": "Macaw",
        "age": "4 years",
        "gender": "Male",
        "weight": "1.2kg",
        "food": "Fruits, Seeds, Pellets",
        "other": "Large, intelligent, needs space. Trained, healthy.",
        "image": "assets/macaw.png",
      },
      {
        "name": "Mango",
        "breed": "Canary",
        "age": "2 years",
        "gender": "Male",
        "weight": "0.03kg",
        "food": "Seeds, Greens, Apple",
        "other": "Sings beautifully, bright yellow, easy care.",
        "image": "assets/bird2.png",
      },
    ],
    "Other": [
      {
        "name": "Bunny",
        "breed": "Rabbit",
        "age": "6 months",
        "gender": "Female",
        "weight": "1.5kg",
        "food": "Carrots, Hay, Pellets",
        "other": "Soft, gentle, loves carrots. Litter trained, cage included.",
        "image": "assets/rabbit1.png",
      },
      {
        "name": "Hammy",
        "breed": "Hamster",
        "age": "1 year",
        "gender": "Male",
        "weight": "0.08kg",
        "food": "Seeds, Nuts, Apple",
        "other":
            "Active at night, loves tunnels. Easy to care for, comes with wheel.",
        "image": "assets/hamster.png",
      },
      {
        "name": "Turtle",
        "breed": "Tortoise",
        "age": "5 years",
        "gender": "Female",
        "weight": "2.2kg",
        "food": "Leafy greens, Fruits, Pellets",
        "other": "Slow, peaceful, enjoys basking. Needs aquarium, healthy.",
        "image": "assets/turtle.png",
      },
      {
        "name": "Guinea",
        "breed": "Guinea Pig",
        "age": "2 years",
        "gender": "Male",
        "weight": "1.0kg",
        "food": "Veggies, Hay, Pellets",
        "other":
            "Social, squeaks, loves veggies. Good for kids, cage included.",
        "image": "assets/pg.png",
      },
      {
        "name": "Ferret",
        "breed": "Ferret",
        "age": "3 years",
        "gender": "Female",
        "weight": "1.2kg",
        "food": "Chicken, Turkey, Pellets",
        "other": "Playful, curious, loves tunnels. Needs time outside cage.",
        "image": "assets/ferret.png",
      },
      {
        "name": "Chinchilla",
        "breed": "Chinchilla",
        "age": "4 years",
        "gender": "Male",
        "weight": "0.6kg",
        "food": "Hay, Pellets, Raisins",
        "other": "Soft fur, jumps high, dust baths. Needs large cage.",
        "image": "assets/chin.png",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadAvatar();
    _saveLoginStatus();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString('avatarPath') ?? "assets/avatar.png";
      _isAssetAvatar = prefs.getBool('isAssetAvatar') ?? true;
    });
  }

  Future<void> _changeAvatar(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Avatar'),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick from Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0E4839),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('avatarPath', picked.path);
                    await prefs.setBool('isAssetAvatar', false);
                    setState(() {
                      _avatarPath = picked.path;
                      _isAssetAvatar = false;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Capture with Camera'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF6C00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('avatarPath', picked.path);
                    await prefs.setBool('isAssetAvatar', false);
                    setState(() {
                      _avatarPath = picked.path;
                      _isAssetAvatar = false;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedCategory = categories[selectedIndex];
    List<Map<String, String>> pets = petsByCategory[selectedCategory] ?? [];

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const choose()),
          (route) => false,
        );
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE8F6EF),
                    Color(0xFFF6FFF8),
                    Color(0xFFD6EADF),
                  ],
                ),
        ),
        child: Scaffold(
          backgroundColor: isDark
              ? Theme.of(context).colorScheme.background
              : Colors.transparent,
          appBar: AppBar(
            title: Text(
              "FurEver Home",
              style: TextStyle(
                fontFamily: "Boyers",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF0E4839),
            elevation: isDark ? 4 : 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.logout,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Logout'),
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', false);
                                  Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.image,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Change Avatar'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _changeAvatar(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.lock,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Change Password'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showChangePasswordDialog(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.list_alt,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Orders'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Ordered Pets'),
                                      content: adoptedPets.isEmpty
                                          ? const Text('No pets adopted yet.')
                                          : SizedBox(
                                              width: 300,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: adoptedPets.length,
                                                itemBuilder: (context, index) {
                                                  final pet =
                                                      adoptedPets[index];
                                                  return ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          AssetImage(
                                                            pet['image'] ?? '',
                                                          ),
                                                    ),
                                                    title: Text(
                                                      pet['name'] ?? '',
                                                    ),
                                                    subtitle: Text(
                                                      'Breed: ${pet['breed'] ?? ''}\nAge: ${pet['age'] ?? ''}\nWeight: ${pet['weight'] ?? ''}',
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.forum,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Community'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CommunityFeedPage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.volunteer_activism,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Donate / Volunteer'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DonateVolunteerPage(),
                                    ),
                                  );
                                },
                              ),
                              const Divider(),
                              SwitchListTile(
                                secondary: const Icon(
                                  Icons.dark_mode,
                                  color: Color(0xFF0E4839),
                                ),
                                title: const Text('Dark Mode'),
                                value: isDark,
                                onChanged: (val) {
                                  if (widget.onThemeChanged != null) {
                                    widget.onThemeChanged!(val);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: _isAssetAvatar
                        ? AssetImage(_avatarPath) as ImageProvider
                        : FileImage(File(_avatarPath)),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adopt your pet's here!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: isDark
                        ? Theme.of(context).colorScheme.surface
                        : const Color(0xFFE8F6EF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '“Until one has loved an animal, a part of one’s soul remains unawakened.”',
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: isDark
                                    ? Theme.of(context).colorScheme.secondary
                                    : const Color(0xFF3A6351),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = index == selectedIndex;
                        final icons = [
                          Icons.pets,
                          Icons.pets,
                          Icons.bug_report,
                          Icons.emoji_nature,
                        ];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.secondaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: isDark
                                            ? Colors.black26
                                            : Colors.orange.shade100,
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icons[index],
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer
                                      : Theme.of(context).colorScheme.primary,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryContainer
                                        : Theme.of(context).colorScheme.primary,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdoptPetPage(pet: pet),
                              ),
                            );
                          },
                          child: Card(
                            color: isDark
                                ? Theme.of(context).colorScheme.surface
                                : Colors.white,
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            margin: const EdgeInsets.only(bottom: 22),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomLeft: Radius.circular(24),
                                  ),
                                  child: Image.asset(
                                    pet["image"]!,
                                    width: 140,
                                    height: 130,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet["name"] ?? "",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Breed: ${pet["breed"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          "Age: ${pet["age"] ?? ""} | Gender: ${pet["gender"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          "Weight: ${pet["weight"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          "Food: ${pet["food"] ?? ""}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          pet["other"] ?? "",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.secondary
                                                : const Color(0xFF3A6351),
                                          ),
                                        ),
                                      ],
                                    ),
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
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(0.6),
              currentIndex: _bottomNavIndex,
              onTap: _onBottomNavTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.pets),
                  label: 'Choose Pet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.miscellaneous_services),
                  label: 'Services',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Pet Wiki',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: 'Know Sound',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.chat,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => GeminiChatSheet(),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onBottomNavTap(int index) async {
    setState(() => _bottomNavIndex = index);

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ServicesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetWikiPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KnowTheSoundPage()),
        );
        break;
    }
  }

  // Save login status
  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      emailController.text = user.email!;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email to receive a password reset link:'),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your email.')),
                  );
                  return;
                }
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: email,
                  );
                  // Log out user after sending reset email
                  await FirebaseAuth.instance.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password reset email sent! Please log in again.',
                      ),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  String msg = 'Failed to send reset email.';
                  if (e.code == 'user-not-found')
                    msg = 'No user found for that email.';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
