import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemotion_mobile/src/common/widgets/video_player_widget.dart';
import 'package:wemotion_mobile/src/common/features/post_replies/data/provider/reply_provider.dart';
import 'package:wemotion_mobile/src/common/widgets/circle_widget.dart';
import 'package:wemotion_mobile/src/common/widgets/widget_button.dart';

class PostRepliesScreen extends StatefulWidget {
  final bool isNewLevel;
  const PostRepliesScreen({super.key, this.isNewLevel = false});

  @override
  State<PostRepliesScreen> createState() => _PostRepliesScreenState();
}

class _PostRepliesScreenState extends State<PostRepliesScreen> {
  int? currentIndex;
  String? above;
  String? below;
  final PageController _pageController = PageController();
  bool _isLoadingNewContent = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_scrollListener);
    _pageController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pageController.position.pixels ==
        _pageController.position.minScrollExtent) {
      // Handle top scroll position if needed
    }
  }

  Future<void> _handleHorizontalSwipe(DragEndDetails details) async {
    final postProvider = Provider.of<PostReplyProvider>(context, listen: false);
    final currentReplies = postProvider.currentReplies;

    if (details.primaryVelocity! < 0 &&
        currentReplies.isNotEmpty &&
        currentReplies[0].post[currentIndex ?? 0].childVideoCount > 0) {
      setState(() => _isLoadingNewContent = true);

      try {
        postProvider.currentId = currentReplies[0].post[currentIndex ?? 0].id;
        await postProvider.loadMorePostReplies(isNewLevel: true);

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostRepliesScreen(isNewLevel: true),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading replies: $e')));
      } finally {
        if (mounted) {
          setState(() => _isLoadingNewContent = false);
        }
      }
    } else if (details.primaryVelocity! > 0) {
      postProvider.goBackLevel();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostReplyProvider>(context, listen: true);
    final screenSize = MediaQuery.of(context).size;
    final currentReplies = postProvider.currentReplies;

    // Show loading if this is a new level and data isn't ready yet
    if (widget.isNewLevel &&
        (postProvider.isLoading || currentReplies.isEmpty)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: currentReplies.isNotEmpty
                ? currentReplies[0].post.length
                : 0,
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
                if (currentReplies.isNotEmpty) {
                  int totalPosts = currentReplies[0].post.length;
                  above = currentIndex?.toString() ?? 'H';
                  below = (totalPosts - currentIndex! - 1).toString();
                }
              });
            },
            itemBuilder: (context, index) {
              //
              final isCurrentItem = currentIndex == index;
              //
              return GestureDetector(
                onHorizontalDragEnd: _handleHorizontalSwipe,
                child: currentReplies.isEmpty
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : VideoPlayerWidget(
                        currentReplies[0].post[index].videoLink,
                        autoPlay: true,
                        isCurrentItem: isCurrentItem,
                      ),
              );
            },
          ),

          // Loading overlay
          if (_isLoadingNewContent)
            const Center(child: CircularProgressIndicator()),

          // Bottom UI controls
          if (currentReplies.isNotEmpty && currentReplies[0].post.isNotEmpty)
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: screenSize.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left side (user info)
                    SizedBox(
                      width: screenSize.width * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: currentReplies[0]
                                        .post[currentIndex ?? 0]
                                        .pictureUrl,
                                    width: 40,
                                    height: 40,
                                    errorWidget: (_, __, ___) =>
                                        const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${currentReplies[0].post[currentIndex ?? 0].firstName} '
                                  '${currentReplies[0].post[currentIndex ?? 0].lastName}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentReplies[0].post[currentIndex ?? 0].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),

                    // Right side (action buttons)
                    SizedBox(
                      width: screenSize.width * 0.3,
                      child: Column(
                        children: [
                          buildActionButton(Icons.favorite_border),
                          const SizedBox(height: 5),
                          buildActionButton(Icons.comment),
                          const SizedBox(height: 5),
                          buildActionButton(Icons.more_vert, isMore: true),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleWithFiveDirections(
                              pointNorth: above == '' || above == '0'
                                  ? 'H'
                                  : above ?? 'H',
                              pointWest: 'P',
                              pointSouth:
                                  below ??
                                  '${currentReplies[0].post.length - 1}',
                              pointEast:
                                  '${currentReplies[0].post[currentIndex ?? 0].childVideoCount}',
                              mainCircleColor: Colors.yellow,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
