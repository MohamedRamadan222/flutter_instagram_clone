import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// P6-3: single entry point for gallery reads.
///
/// `image_picker` brings its own system sheet on mobile, but when the user
/// has denied / permanently denied photo access we must explain and offer
/// Settings instead of silently returning null.
enum MediaKind { photo, video }

/// Returns true when the gallery may be opened. Shows a SnackBar and
/// returns false when access is denied. Desktop / unsupported platforms
/// fall through to true and let `image_picker` decide.
Future<bool> ensureMediaPermission(
  BuildContext context,
  MediaKind kind,
) async {
  final Permission permission =
      kind == MediaKind.photo ? Permission.photos : Permission.videos;
  PermissionStatus status;
  try {
    status = await permission.status;
  } catch (_) {
    // Desktop / web: no runtime permission model — proceed.
    return true;
  }
  if (status.isGranted || status.isLimited) return true;

  try {
    status = await permission.request();
  } catch (_) {
    return true;
  }
  if (status.isGranted || status.isLimited) return true;
  if (!context.mounted) return false;

  final label = kind == MediaKind.photo ? 'photos' : 'videos';
  final messenger = ScaffoldMessenger.of(context);
  if (status.isPermanentlyDenied) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Allow $label access in Settings to pick media.',
        ),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: openAppSettings,
        ),
      ),
    );
  } else {
    messenger.showSnackBar(
      SnackBar(content: Text('$label access is needed to pick media.')),
    );
  }
  return false;
}
