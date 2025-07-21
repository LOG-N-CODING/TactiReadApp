import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class BluetoothPermissionService {
  static Future<bool> requestBluetoothPermissions(BuildContext context) async {
    try {
      final permissions = [
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.location,
        Permission.locationWhenInUse,
      ];

      // 권한 상태 확인
      Map<Permission, PermissionStatus> statuses = await permissions.request();
      
      // 모든 권한이 승인되었는지 확인
      bool allGranted = statuses.values.every((status) => status.isGranted);
      
      if (!allGranted) {
        // 거부된 권한이 있는 경우 사용자에게 알림
        _showPermissionDialog(context, statuses);
        return false;
      }
      
      return true;
    } catch (e) {
      print('Error requesting Bluetooth permissions: $e');
      return false;
    }
  }

  static void _showPermissionDialog(BuildContext context, Map<Permission, PermissionStatus> statuses) {
    final deniedPermissions = statuses.entries
        .where((entry) => entry.value.isDenied || entry.value.isPermanentlyDenied)
        .map((entry) => _getPermissionName(entry.key))
        .join(', ');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('권한이 필요합니다'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('TactiRead가 점자 디스플레이와 연결하려면 다음 권한이 필요합니다:'),
              const SizedBox(height: 16),
              const Text('• 블루투스 액세스'),
              const Text('• 블루투스 스캔'),
              const Text('• 블루투스 연결'),
              const Text('• 위치 정보 (블루투스 검색용)'),
              const SizedBox(height: 16),
              if (deniedPermissions.isNotEmpty)
                Text(
                  '거부된 권한: $deniedPermissions',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('나중에'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        );
      },
    );
  }

  static String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.bluetooth:
        return '블루투스';
      case Permission.bluetoothConnect:
        return '블루투스 연결';
      case Permission.bluetoothScan:
        return '블루투스 스캔';
      case Permission.location:
      case Permission.locationWhenInUse:
        return '위치 정보';
      default:
        return permission.toString();
    }
  }

  static Future<bool> checkBluetoothPermissions() async {
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.locationWhenInUse,
    ];

    for (Permission permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }
}
