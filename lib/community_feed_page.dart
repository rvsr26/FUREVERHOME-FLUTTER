import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CommunityFeedPage extends StatefulWidget {
  const CommunityFeedPage({super.key});

  @override
  State<CommunityFeedPage> createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends State<CommunityFeedPage> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;
  bool _isPosting = false;
  String? _errorMsg;

  // Demo posts to show as fake users
  final List<Map<String, dynamic>> demoPosts = [
    {
      'text': 'Meet Bella! She just learned a new trick today 🐶✨',
      'imageAsset': 'assets/dog1.png',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'likes': 5,
      'user': 'Priya',
    },
    {
      'text': 'Adopted this cutie last week. She loves to nap in the sun! 😻',
      'imageAsset': 'assets/cat1.png',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'likes': 8,
      'user': 'Amit',
    },
    {
      'text': 'First walk in the park with Rocky. He made so many friends!',
      'imageAsset': 'assets/dog2.png',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'likes': 3,
      'user': 'Sara',
    },
    {
      'text': 'Kiwi the parrot said "hello" for the first time today! 🦜',
      'imageAsset': 'assets/bird1.png',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'likes': 4,
      'user': 'Ravi',
    },
  ];

  // User posts (added at runtime, not deleted)
  final List<Map<String, dynamic>> userPosts = [];

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.trim().isEmpty && _selectedImage == null) return;
    setState(() {
      _isPosting = true;
      _errorMsg = null;
    });
    try {
      userPosts.insert(0, {
        'text': _postController.text.trim(),
        'timestamp': DateTime.now(),
        'likes': 0,
        'user': 'You',
        'imageFile': _selectedImage,
      });
      setState(() {
        _postController.clear();
        _selectedImage = null;
      });
    } catch (e) {
      setState(() => _errorMsg = 'Failed to post: $e');
    } finally {
      setState(() => _isPosting = false);
    }
  }

  Widget _buildPostTile({
    required String text,
    String? user,
    DateTime? time,
    int? likes,
    String? imageAsset,
    File? imageFile,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: imageFile != null
            ? CircleAvatar(backgroundImage: FileImage(imageFile))
            : imageAsset != null
            ? CircleAvatar(backgroundImage: AssetImage(imageAsset))
            : const CircleAvatar(child: Icon(Icons.pets)),
        title: Text(text),
        subtitle: Text(
          '${user ?? 'User'} • ${time != null ? formatTimeAgo(time) : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 20),
            Text(' ${likes ?? 0}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Combine user posts (newest first) and demo posts
    final allPosts = [...userPosts, ...demoPosts];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Feed'),
        backgroundColor: const Color(0xFF0E4839),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: const InputDecoration(
                      hintText: 'Share your pet story...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                _isPosting
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _submitPost,
                      ),
              ],
            ),
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image.file(_selectedImage!, height: 100),
            ),
          if (_errorMsg != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _errorMsg!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, i) {
                final post = allPosts[i];
                return _buildPostTile(
                  text: post['text'] ?? '',
                  user: post['user'],
                  time: post['timestamp'],
                  likes: post['likes'],
                  imageAsset: post['imageAsset'],
                  imageFile: post['imageFile'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
