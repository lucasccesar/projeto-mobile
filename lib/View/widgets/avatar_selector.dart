import 'package:flutter/material.dart';
import 'package:projeto_mobile/config/app_colors.dart';

class AvatarSelector extends StatelessWidget {
  final int? selectedAvatarId;
  final ValueChanged<int> onSelected;

  const AvatarSelector({
    super.key,
    required this.selectedAvatarId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FOTO DE PERFIL',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final id = index + 1;
            final isSelected = selectedAvatarId == id;
            return GestureDetector(
              onTap: () => onSelected(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.perfil : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/images/avatars/pfp$id.png'),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}