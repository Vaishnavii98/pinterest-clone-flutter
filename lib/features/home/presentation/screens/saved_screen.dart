import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/features/home/presentation/provider/saved_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../home/presentation/screens/pin_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Consumer<SavedProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              const SizedBox(height: 16),

              // Profile Header
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),

              const SizedBox(height: 8),

              const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${provider.savedPins.length} saved",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: provider.savedPins.isEmpty
                    ? const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.bookmark_border, size: 50, color: Colors.grey),
      SizedBox(height: 10),
      Text(
        "No saved pins yet",
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
)
                    : MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.savedPins.length,
                        itemBuilder: (context, index) {
                          final photo = provider.savedPins[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PinDetailScreen(photo: photo),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: photo.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
}