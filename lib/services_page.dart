import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'reservation_confirm_dialog.dart';

List<Map<String, String>> reservedServices = [];

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  void _showReservedServices() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('My Reserved Services'),
          content: reservedServices.isEmpty
              ? const Text('No reservations yet.')
              : SizedBox(
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reservedServices.length,
                    itemBuilder: (context, index) {
                      final res = reservedServices[index];
                      final isVet = res['service'] == 'Veterinary Care';
                      return ListTile(
                        leading: const Icon(
                          Icons.bookmark,
                          color: Colors.green,
                        ),
                        title: Text(res['service'] ?? ''),
                        subtitle: Text(
                          'Time: ${res['time'] ?? ''}\nContact: ${res['contact'] ?? ''}',
                        ),
                        trailing: isVet
                            ? IconButton(
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF0E4839),
                                ),
                                tooltip: 'Find Vets Near Me',
                                onPressed: () async {
                                  final url = Uri.parse(
                                    'https://maps.app.goo.gl/AJSrNCb4iGc1jmgG9',
                                  );
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                              )
                            : null,
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F6EF), // soft mint
            Color(0xFFF6FFF8), // light cream
            Color(0xFFD6EADF), // pale green
          ],
        ),
        image: DecorationImage(
          image: AssetImage('assets/paw_bone_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0x14FFFFFF), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Pet Services',
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
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark),
              tooltip: 'My Reserved Services',
              onPressed: _showReservedServices,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Available Services',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ServiceCard(
              icon: Icons.local_hospital,
              title: 'Veterinary Care',
              description:
                  'Find trusted vets for checkups, vaccinations, and emergencies.',
              cost: '₹1200',
              onReserve: (time, contact) {
                setState(() {
                  reservedServices.add({
                    'service': 'Veterinary Care',
                    'time': time,
                    'contact': contact,
                  });
                });
              },
            ),
            ServiceCard(
              icon: Icons.pets,
              title: 'Pet Grooming',
              description:
                  'Book grooming sessions for your pet’s hygiene and style.',
              cost: '₹700',
              onReserve: (time, contact) {
                setState(() {
                  reservedServices.add({
                    'service': 'Pet Grooming',
                    'time': time,
                    'contact': contact,
                  });
                });
              },
            ),
            ServiceCard(
              icon: Icons.directions_car,
              title: 'Pet Transport',
              description: 'Safe and comfortable transport for your pets.',
              cost: '₹1500',
              onReserve: (time, contact) {
                setState(() {
                  reservedServices.add({
                    'service': 'Pet Transport',
                    'time': time,
                    'contact': contact,
                  });
                });
              },
            ),
            ServiceCard(
              icon: Icons.hotel,
              title: 'Pet Boarding',
              description:
                  'Find reliable boarding facilities for your pets when you travel.',
              cost: '₹900',
              onReserve: (time, contact) {
                setState(() {
                  reservedServices.add({
                    'service': 'Pet Boarding',
                    'time': time,
                    'contact': contact,
                  });
                });
              },
            ),
            ServiceCard(
              icon: Icons.school,
              title: 'Training & Obedience',
              description: 'Professional trainers for behavior and obedience.',
              cost: '₹1800',
              onReserve: (time, contact) {
                setState(() {
                  reservedServices.add({
                    'service': 'Training & Obedience',
                    'time': time,
                    'contact': contact,
                  });
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'More services coming soon!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String cost;
  final void Function(String time, String contact)? onReserve;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.cost,
    this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 14),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFF6FFF8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          final _formKey = GlobalKey<FormState>();
          final TextEditingController dateController = TextEditingController();
          final TextEditingController contactController =
              TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                backgroundColor: const Color(0xFFF6FFF8),
                title: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF0E4839), size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Book $title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Preferred Date',
                            hintText: 'Select a date',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xFF0E4839),
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF0E4839),
                                      onPrimary: Colors.white,
                                      surface: Color(0xFFF6FFF8),
                                      onSurface: Color(0xFF0E4839),
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Color(0xFF0E4839),
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              dateController.text =
                                  '${picked.day}/${picked.month}/${picked.year}';
                            }
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select a date'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: contactController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Details',
                            hintText: 'Phone or Email',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xFF0E4839),
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter contact details'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF0E4839)),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E4839),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.pop(context);
                        if (onReserve != null) {
                          onReserve!(
                            dateController.text,
                            contactController.text,
                          );
                        }
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierLabel: 'Reservation',
                          pageBuilder: (context, anim1, anim2) {
                            return ReservationConfirmDialog(
                              timeSlot: dateController.text,
                              contact: contactController.text,
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0E4839),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E4839),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3A6351),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A6351),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cost,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
