import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest_clone/features/home/presentation/screens/pin_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../provider/photo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        context.read<PhotoProvider>().fetchMorePhotos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Consumer<PhotoProvider>(
    builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildPinterestAppBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshPhotos,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: MasonryGridView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,), 
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: provider.photos.length +
                          (provider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.photos.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final photo = provider.photos[index];
return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinDetailScreen(photo: photo),
      ),
    );
  },
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
ClipRRect(
  borderRadius: BorderRadius.circular(18),
  child: Hero(
    tag: photo.id,
    child: CachedNetworkImage(
      imageUrl: photo.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
    ),
  ),
),

      const SizedBox(height: 8),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                photo.photographer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                _showPinOptions(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showPinOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.push_pin_outlined),
              title: Text("Save"),
            ),
            ListTile(
              leading: Icon(Icons.share_outlined),
              title: Text("Share"),
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text("See more like this"),
            ),
            ListTile(
              leading: Icon(Icons.visibility_off_outlined),
              title: Text("See less like this"),
            ),
            ListTile(
              leading: Icon(Icons.report_outlined),
              title: Text("Report Pin"),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildPinterestAppBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
Row(
  children: [
    ClipOval(
      child: Image.asset(
        'lib/assets/images/pinterest_logo.jpeg',
        height: 32,
        width: 32,
        fit: BoxFit.cover,
      ),
    ),
    const SizedBox(width: 8),
    Text(
      'Pinterest',
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  ],
),
        const Row(
          children: [
            Icon(Icons.add, size: 26),
            SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline, size: 24),
          ],
        ),
      ],
    ),
  );
}
}