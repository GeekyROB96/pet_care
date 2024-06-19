import 'package:flutter/foundation.dart';

class PetFeedProvider with ChangeNotifier {
  List<Post> _posts = [
    Post(
      id: '1',
      imageUrl: 'assets/images/pet2.jpg',
      caption: 'Cute doggy!',
      likes: 20,
      comments: [
        Comment(id: '1', userId: 'user1', content: 'So adorable!'),
        Comment(id: '2', userId: 'user2', content: 'Love it!'),
      ],
      isLiked: false, // Initially not liked
    ),
    Post(
      id: '2',
      imageUrl: 'assets/images/pet5.jpg',
      caption: 'Sunday stroll with my buddy.',
      likes: 15,
      comments: [
        Comment(id: '1', userId: 'user3', content: 'Beautiful day!'),
      ],
      isLiked: false, // Initially not liked
    ),
    // Add more posts as needed
  ];

  List<Post> get posts => _posts;

  void addPost(Post post) {
    _posts.add(post);
    notifyListeners();
  }

  void addComment(String postId, Comment comment) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.comments.add(comment);
    notifyListeners();
  }

  void likePost(String postId) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].likes++;
      _posts[postIndex].isLiked = true;
      notifyListeners();
    }
  }

  void unlikePost(String postId) {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      _posts[postIndex].likes--;
      _posts[postIndex].isLiked = false;
      notifyListeners();
    }
  }

  void deletePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }
}

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final List<Comment> comments;
  int likes;
  bool isLiked; // Added to track like status

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    this.comments = const [],
    this.likes = 0,
    this.isLiked = false, // Added default value
  });
}

class Comment {
  final String id;
  final String userId;
  final String content;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
  });
}
