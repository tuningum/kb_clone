import 'package:flutter/material.dart';

class EditableOverlay extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool editMode;
  final VoidCallback? onTap;

  const EditableOverlay({
    super.key,
    required this.text,
    required this.style,
    required this.editMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: editMode ? onTap : null,
      child: Container(
        padding: editMode
            ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
            : EdgeInsets.zero,
        decoration: editMode
            ? BoxDecoration(
                color: const Color(0xCCFFFFFF),
                border: Border.all(color: const Color(0xFF2D55B0), width: 1.5),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Text(text, style: style),
      ),
    );
  }
}

Future<String?> showEditDialog(
  BuildContext context, {
  required String title,
  required String currentValue,
  TextInputType keyboardType = TextInputType.text,
}) async {
  final controller = TextEditingController(text: currentValue);
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      content: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}