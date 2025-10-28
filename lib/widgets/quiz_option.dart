import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigoAccent.withOpacity(0.8) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.indigo, width: 1.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
