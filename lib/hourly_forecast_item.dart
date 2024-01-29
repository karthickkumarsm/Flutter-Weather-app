import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 6,
                    child: Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(time,style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                          ),
                         const SizedBox(height:16),
                         Icon(
                          icon,
                          size: 38,
                         ),
                        const SizedBox(height:16),
                        Text(temp,style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}