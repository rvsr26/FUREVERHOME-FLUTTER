import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class KnowTheSoundPage extends StatefulWidget {
  const KnowTheSoundPage({super.key});

  @override
  State<KnowTheSoundPage> createState() => _KnowTheSoundPageState();
}

class _KnowTheSoundPageState extends State<KnowTheSoundPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> animals = [
    {
      "name": "Dog",
      "image": "assets/dog1.png",
      "sound": "sounds/dog_bark.mp3", // TODO: Add this sound file
    },
    {
      "name": "Cat",
      "image": "assets/cat1.png",
      "sound": "sounds/cat_meow.mp3", // TODO: Add this sound file
    },
    {
      "name": "Parrot",
      "image": "assets/parrot.png",
      "sound": "sounds/parrot_talk.mp3", // TODO: Add this sound file
    },
    {
      "name": "Rabbit",
      "image": "assets/rabbit1.png",
      "sound": "sounds/rabbit_squeak.mp3", // TODO: Add this sound file
    },
    {
      "name": "Horse",
      "image": "assets/horse.png", // Using a general animal image
      "sound": "sounds/horse_neigh.mp3", // TODO: Add this sound file
    },
    {
      "name": "Cow",
      "image": "assets/cow.png", // Using a general animal image
      "sound": "sounds/cow_moo.mp3", // TODO: Add this sound file
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String soundAsset) async {
    try {
      await _audioPlayer.play(AssetSource(soundAsset));
    } catch (e) {
      print("Error playing sound: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not play sound. Make sure the audio file is in assets/sounds/',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Know the Sound'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: animals.length,
        itemBuilder: (context, index) {
          final animal = animals[index];
          return GestureDetector(
            onTap: () => _playSound(animal['sound']!),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(animal['image']!, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      animal['name']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
