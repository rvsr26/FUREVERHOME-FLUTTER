import 'package:flutter/material.dart';
import 'home_page.dart'; // ✅ Import HomePage
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const choose());
}

class choose extends StatelessWidget {
  const choose({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0E4839),
        fontFamily: "Poppins",
      ),
      home: const CategorySelectionPage(), // ✅ first screen
    );
  }
}

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ make Scaffold transparent
      appBar: AppBar(
        elevation: 6,
        title: const Text(
          "FurEver Home",
          style: TextStyle(
            fontFamily: "Boyers",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
      ),
      body: Container(
        // ✅ Gradient background for whole page
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0), // very light peach
              Color(0xFFFFE0B2), // soft orange cream
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 🐾 Paw bones background only at the top
              Container(
                height: 285, // 👈 covers from top until a bit below banner
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/paw_bone_background.png"),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    const Text(
                      "Find your forever friend 🐾",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ✅ Banner (with gradient overlay)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(4, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/Banner.png",
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 55),

                    // ✅ Categories Grid
                    Expanded(
                      child: GridView.builder(
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.9,
                            ),
                        itemBuilder: (context, index) {
                          final categories = [
                            ["Dogs", Icons.pets, Colors.orange],
                            ["Cats", FontAwesomeIcons.cat, Colors.purple],
                            ["Birds", Icons.flutter_dash, Colors.green],
                            ["Other Animals", Icons.other_houses, Colors.blue],
                          ];
                          return _buildCategoryCard(
                            context,
                            categories[index][0] as String,
                            categories[index][1] as IconData,
                            categories[index][2] as Color,
                            index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Category Card with Background Image
  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int categoryIndex,
  ) {
    // 👇 Map each category to an image
    final images = [
      "assets/doggo.jpg", // Dogs
      "assets/catto.jpg", // Cats
      "assets/birdo.jpg", // Birds
      "assets/buno.jpg", // Other Animals
    ];

    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(initialIndex: categoryIndex),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(images[categoryIndex]),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(3, 5),
              ),
            ],
          ),
          child: Container(
            // 👇 dark overlay for text readability
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.35),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 40, color: Colors.white), // still shows icon
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
