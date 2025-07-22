import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/bottom_navigation_component.dart';
import '../services/bluetooth_permission_service.dart';

class DevicePairingScreen extends StatefulWidget {
  const DevicePairingScreen({super.key});

  @override
  State<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends State<DevicePairingScreen> {
  bool _isScanning = false;
  bool _bluetoothEnabled = false;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _connectedDevice;
  
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _checkBluetoothState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final hasPermissions = await BluetoothPermissionService.requestBluetoothPermissions(context);
    if (!hasPermissions && mounted) {
      // 권한이 없는 경우에도 계속 진행하되, 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some features may be limited. Please allow permissions in settings.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _checkBluetoothState() async {
    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      setState(() {
        _bluetoothEnabled = adapterState == BluetoothAdapterState.on;
      });
      
      if (_bluetoothEnabled) {
        _getBondedDevices();
      }
    } catch (e) {
      print('Error checking bluetooth state: $e');
    }
  }

  Future<void> _getBondedDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluePlus.bondedDevices;
      setState(() {
        _devicesList = devices;
      });
    } catch (e) {
      print('Error getting bonded devices: $e');
    }
  }

  Future<void> _enableBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
      await _checkBluetoothState();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bluetooth enabled'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable Bluetooth: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _scanForDevices() async {
    if (!_bluetoothEnabled) return;

    setState(() {
      _isScanning = true;
      _devicesList.clear(); // 새로운 스캔 시작 시 기존 목록 클리어
    });

    try {
      // 먼저 페어링된 디바이스 가져오기
      await _getBondedDevices();
      
      // 스캔 시작
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      
      // 스캔 결과 수신
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          bool existAlready = _devicesList.any((element) => element.remoteId == result.device.remoteId);
          if (!existAlready) {
            setState(() {
              _devicesList.add(result.device);
            });
          }
        }
      });

      // 스캔 완료 대기
      await Future.delayed(Duration(seconds: 4));
      
      setState(() {
        _isScanning = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found ${_devicesList.length} devices'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
      }

      await device.connect();
      
      setState(() {
        _connectedDevice = device;
      });

      final deviceName = device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to $deviceName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      final deviceName = device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to $deviceName: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _disconnectDevice() async {
    try {
      final deviceName = _connectedDevice?.platformName.isNotEmpty == true 
          ? _connectedDevice!.platformName 
          : 'Unknown Device';
      
      await _connectedDevice?.disconnect();
      setState(() {
        _connectedDevice = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnected from $deviceName'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Disconnect failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Device Pairing',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 스캐닝 상태 또는 연결된 디바이스
            if (_connectedDevice != null) 
              _buildConnectedDeviceSection()
            else
              _buildScanningSection(),
            
            const SizedBox(height: 72),
            
            // 디바이스 목록
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _devicesList.isEmpty
                    ? _buildEmptyDeviceList()
                    : _buildDevicesList(),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationComponent(currentRoute: '/device-pairing'),
    );
  }

  Widget _buildConnectedDeviceSection() {
    if (_connectedDevice == null) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Column(
        children: [
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(62),
            ),
            child: Icon(
              Icons.bluetooth_connected,
              size: 60,
              color: Colors.green.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Connected to ${_connectedDevice!.platformName.isNotEmpty ? _connectedDevice!.platformName : 'Unknown Device'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _disconnectDevice,
            child: const Text(
              'Disconnect',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _bluetoothEnabled ? _scanForDevices : _enableBluetooth,
            child: Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: _bluetoothEnabled ? Colors.blue.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(62),
                border: Border.all(
                  color: _bluetoothEnabled ? Colors.blue.shade200 : Colors.red.shade200,
                  width: 2,
                ),
              ),
              child: _isScanning
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      _bluetoothEnabled ? Icons.bluetooth_searching : Icons.bluetooth_disabled,
                      size: 60,
                      color: _bluetoothEnabled ? Colors.blue.shade600 : Colors.red.shade600,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isScanning 
                ? 'connecting...' 
                : _bluetoothEnabled 
                    ? 'Tap to scan for devices'
                    : 'Tap to enable Bluetooth',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDeviceList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices,
            size: 48,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No devices found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your device is in pairing mode',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesList() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: _devicesList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final device = _devicesList[index];
              return _buildDeviceListItem(device);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceListItem(BluetoothDevice device) {
    final isConnected = _connectedDevice?.remoteId == device.remoteId;
    final deviceName = device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';
    
    return GestureDetector(
      onTap: isConnected ? null : () => _connectToDevice(device),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isConnected ? 'Connected' : 'Not connected',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isConnected ? Colors.green.shade300 : const Color(0xFFCBCBCB),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () => _showDeviceInfo(device),
              child: Container(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.info_outline,
                  size: 24,
                  color: const Color(0xFF29A8FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeviceInfo(BluetoothDevice device) {
    final deviceName = device.platformName.isNotEmpty ? device.platformName : 'Unknown Device';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(deviceName),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Device ID: ${device.remoteId}'),
            const SizedBox(height: 8),
            Text('Status: ${_connectedDevice?.remoteId == device.remoteId ? 'Connected' : 'Not connected'}'),
            const SizedBox(height: 16),
            const Text(
              'Connection Tips:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Make sure the device is in pairing mode'),
            const Text('• Check if Bluetooth is enabled'),
            const Text('• Try restarting both devices if connection fails'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (_connectedDevice?.remoteId != device.remoteId)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _connectToDevice(device);
              },
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}
