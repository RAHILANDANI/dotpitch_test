import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  List<dynamic> apps = [];

  Future<void> _fetchApps() async {
    final response = await http.get(
      Uri.parse('https://itunes.apple.com/search?term=spaceo&entity=software'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        apps = jsonData['results'];
      });
    } else {
      throw Exception('Failed to load apps');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchApps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viteb Apps'),
      ),
      body: apps.isEmpty
          ? Center(
        child: Lottie.asset('assets/Animation - 1736162817396.json', width: 150, height: 150),
      )
          : ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return ListTile(
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  app['formattedPrice'] ?? 'Free',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            leading: Image.network(
              app['artworkUrl100'] ?? '',
              width: 50,
              height: 50,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Lottie.asset('assets/Animation - 1736162817396.json', width: 50, height: 50);
              },
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 50),
            ),
            title: Text(app['trackName'] ?? 'No Name'),
            subtitle: Text(app['description'] ?? 'No Description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppDetailPage(app: app),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AppDetailPage extends StatelessWidget {
  final Map<String, dynamic> app;

  const AppDetailPage({required this.app, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app['trackName'] ?? 'App Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  app['artworkUrl512'] ?? '',
                  width: 150,
                  height: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Lottie.asset('assets/Animation - 1736162817396.json', width: 150, height: 150);
                  },
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 150),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                app['trackName'] ?? 'No Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                app['description'] ?? 'No Description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Price: ${app['formattedPrice'] ?? 'Free'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Screenshots:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (app['screenshotUrls'] as List<dynamic>?)?.length ?? 0,
                  itemBuilder: (context, index) {
                    final screenshotUrl = app['screenshotUrls'][index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        screenshotUrl,
                        width: 150,
                        height: 200,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Lottie.asset('assets/Animation - 1736162817396.json', width: 150, height: 150);
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 150),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
