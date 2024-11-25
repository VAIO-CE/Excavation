import 'package:excavator/services/http_service.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  final HttpService httpService = HttpService(baseUrl: "http://vaio.local");

  Future<void> changeControlState(String? state) async {
    // TO-DO
    final body = {
      'state': state,
    };

    try {
      final response = await httpService.postRequest(
        "/changeControlState",
        body: body,
        contentType: 'application/x-www-form-urlencoded',
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mode changed to: $state")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bad request.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request: ${e}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              _buildControlCard(
                icon: Icons.autorenew,
                label: 'Automatic Control',
                state: 'AUTO_CONTROL',
              ),
              _buildControlCard(
                icon: Icons.pan_tool,
                label: 'Gyro Control',
                state: 'GYRO_CONTROL',
              ),
              _buildControlCard(
                icon: Icons.gamepad,
                label: 'DS4 Control',
                state: 'DS4_CONTROL',
              ),
              _buildControlCard(
                icon: Icons.privacy_tip,
                label: 'FAQs & Terms',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlCard(
      {required IconData icon, required String label, String? state}) {
    return GestureDetector(
      onTap: () => {if (state != null) changeControlState(state)},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
