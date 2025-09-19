import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTestSimple extends StatefulWidget {
  const FirebaseTestSimple({super.key});

  @override
  State<FirebaseTestSimple> createState() => _FirebaseTestSimpleState();
}

class _FirebaseTestSimpleState extends State<FirebaseTestSimple> {
  bool _isLoading = false;
  String _statusMessage = 'Chưa kiểm tra';
  String _errorMessage = '';
  bool _isConnected = false;

  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Đang kiểm tra...';
      _errorMessage = '';
    });

    try {
      // Test Firebase Core (already initialized in main.dart)
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase not initialized');
      }
      
      // Test Firestore
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('test').limit(1).get();
      
      // Test Auth
      FirebaseAuth.instance;
      
      setState(() {
        _isConnected = true;
        _statusMessage = '✅ Firebase kết nối thành công!';
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isConnected = false;
        _statusMessage = '❌ Kết nối thất bại';
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              _isConnected ? Icons.cloud_done : Icons.cloud_off,
              size: 80,
              color: _isConnected ? Colors.green : Colors.red,
            ),
            
            const SizedBox(height: 30),
            
            // Status Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isConnected ? Colors.green[200]! : Colors.red[200]!,
                ),
              ),
              child: Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isConnected ? Colors.green[800] : Colors.red[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Test Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _testFirebaseConnection,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Đang kiểm tra...' : 'Test Firebase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Error Message
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Chi tiết lỗi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
