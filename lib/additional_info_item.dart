import 'package:flutter/material.dart';


class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
            width: 118,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12)
            ),
              child: Column(
                children: [
                 const SizedBox(height: 16),
                   Icon(
                    icon,
                    size: 38,
                    ),
                   const SizedBox(height: 16),
                  Text(label,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                  ),
                 const SizedBox(height: 16),
                  Text(value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ],
              ),
            ),
    );
  }
}

