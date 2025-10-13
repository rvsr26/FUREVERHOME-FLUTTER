import 'package:flutter/material.dart';
import 'pet_adoption_confirmation.dart';
import 'home_page.dart';

class AdoptPetPage extends StatelessWidget {
  final Map<String, String> pet;

  const AdoptPetPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E4839),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // set your arrow color here
        ),
        title: const Text(
          "Pet Adopt",
          textAlign: TextAlign.center,
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                pet["image"]!,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              pet["name"] ?? "",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Breed: ${pet["breed"] ?? ""}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Age: ${pet["age"] ?? pet["details"] ?? ""}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Weight: ${pet["weight"] ?? "25kg"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Food: ${pet["food"] ?? "Pedigree"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Other Info: ${pet["other"] ?? "Eats a lot of Food"}",
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E4839),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  adoptedPets.add(pet);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PetAdoptionConfirmation(pet: pet),
                    ),
                  );
                },
                child: const Text(
                  "Adopt This Pet",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
