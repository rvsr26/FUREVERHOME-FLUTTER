import 'package:flutter/material.dart';

class _ReservationConfirmDialog extends StatefulWidget {
  final String timeSlot;
  final String contact;
  const _ReservationConfirmDialog({
    required this.timeSlot,
    required this.contact,
  });

  @override
  State<_ReservationConfirmDialog> createState() =>
      _ReservationConfirmDialogState();
}

class _ReservationConfirmDialogState extends State<_ReservationConfirmDialog> {
  bool confirmed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        confirmed = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: confirmed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Reservation Confirmed!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your slot: ${widget.timeSlot}\nContact: ${widget.contact}',
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Confirming your reservation...',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        color: Color(0xFF0E4839),
                        strokeWidth: 6,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
