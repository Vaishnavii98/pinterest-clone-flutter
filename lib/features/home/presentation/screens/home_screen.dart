import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_shimmer.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pinterest_loader.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/photo_provider.dart';
import 'pin_detail_screen.dart';

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
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<PhotoProvider>().fetchMorePhotos();
    }
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
                _buildAppBar(),
                Expanded(
                  child: provider.isLoading && provider.photos.isEmpty
                      ? const PinShimmer()
                      : RefreshIndicator(
                          onRefresh: provider.refreshPhotos,
                          child: MasonryGridView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: provider.photos.length +
                                (provider.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= provider.photos.length) {
                                return const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: PinterestLoader(
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final photo = provider.photos[index];

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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: photo.id,
                                            child: CachedNetworkImage(
                                              imageUrl: photo.imageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              placeholder: (context, url) =>
                                                  Container(
                                                height: 200,
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                _showPinOptions(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.35),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.more_horiz,
                                                  size: 18,
                                                ),
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

  Widget _buildAppBar() {
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
