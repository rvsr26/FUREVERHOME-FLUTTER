import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PetWikiPage extends StatelessWidget {
  const PetWikiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Pet Wiki',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F6EF), Color(0xFFF6FFF8), Color(0xFFD6EADF)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
          children: [
            Card(
              color: const Color(0xFFF6FFF8),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/profile.png', height: 48),
                        const SizedBox(width: 12),
                        const Text(
                          'Welcome to Pet Wiki!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E4839),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Find all you need to know about pets, breeds, care, and more. Explore videos, tips, and fun facts below!',
                      style: TextStyle(fontSize: 16, color: Color(0xFF3A6351)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _SectionTitle('Popular Pet Videos'),
            _VideoCard(
              title: 'Dog Breeds Explained',
              url: 'https://youtu.be/tuRl8moQbXU?si=WQRgG_UodRE3YxdR',
              thumbnail: 'assets/dog1.png',
            ),
            _VideoCard(
              title: 'How to Care for Cats',
              url: 'https://www.youtube.com/watch?v=uV1RMT_ld3k',
              thumbnail: 'assets/cat1.png',
            ),
            _VideoCard(
              title: 'Rabbit Care Tips',
              url: 'https://www.youtube.com/watch?v=QvQn5fFvQ1g',
              thumbnail: 'assets/rabbit1.png',
            ),
            const SizedBox(height: 24),
            _SectionTitle('Quick Facts & Tips'),
            _FactCard(
              icon: Icons.pets,
              fact:
                  'Dogs are known for their loyalty and can learn over 100 words and gestures.',
            ),
            _FactCard(
              icon: Icons.pets,
              fact: 'Cats sleep for 12-16 hours a day and love high places.',
            ),
            _FactCard(
              icon: Icons.pets,
              fact: 'Rabbits need plenty of hay and space to hop around.',
            ),
            const SizedBox(height: 24),
            _SectionTitle('Useful Resources'),
            _ResourceCard(
              title: 'Pet Adoption Guide',
              url: 'https://www.petfinder.com/pet-adoption/',
              icon: Icons.book,
            ),
            _ResourceCard(
              title: 'Pet Nutrition Tips',
              url: 'https://www.aspca.org/pet-care/cat-care/cat-nutrition-tips',
              icon: Icons.restaurant,
            ),
            _ResourceCard(
              title: 'Find a Vet Near You',
              url: 'https://www.google.com/maps/search/vet+near+me/',
              icon: Icons.local_hospital,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0E4839),
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String url;
  final String thumbnail;
  const _VideoCard({
    required this.title,
    required this.url,
    required this.thumbnail,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                thumbnail,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              color: Color(0xFF0E4839),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  final IconData icon;
  final String fact;
  const _FactCard({required this.icon, required this.fact});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8F6EF),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF0E4839), size: 28),
        title: Text(fact, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;
  const _ResourceCard({
    required this.title,
    required this.url,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF6FFF8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF0E4839), size: 28),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.open_in_new, color: Color(0xFF0E4839)),
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
