import 'package:flutter/material.dart';

enum DeleteFileAction {
  deleteFromDevice,
  hideInApp,
  cancel,
}

Future<DeleteFileAction?> showDeleteFileActionDialog(BuildContext context) {
  return showDialog<DeleteFileAction>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1C1C2E),
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFFC857),
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bạn muốn làm gì với file này?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DeleteActionTile(
              icon: Icons.delete_rounded,
              iconColor: Colors.redAccent,
              label: 'Xóa file này ra khỏi thiết bị',
              labelColor: Colors.redAccent,
              onTap: () {
                Navigator.of(dialogContext).pop(
                  DeleteFileAction.deleteFromDevice,
                );
              },
            ),
            const SizedBox(height: 8),
            _DeleteActionTile(
              icon: Icons.visibility_off_outlined,
              iconColor: Color(0xFF8F7CFF),
              label: 'Ẩn file này trên ứng dụng',
              onTap: () {
                Navigator.of(dialogContext).pop(DeleteFileAction.hideInApp);
              },
            ),
            const SizedBox(height: 8),
            _DeleteActionTile(
              icon: Icons.close_rounded,
              iconColor: Colors.white70,
              label: 'Hủy',
              onTap: () {
                Navigator.of(dialogContext).pop(DeleteFileAction.cancel);
              },
            ),
          ],
        ),
      );
    },
  );
}

class _DeleteActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _DeleteActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
