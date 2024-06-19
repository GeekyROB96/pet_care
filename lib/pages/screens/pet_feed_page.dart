import 'package:flutter/material.dart';
import 'package:pet_care/constants/theme/light_colors.dart';
import 'package:provider/provider.dart';

import '../../provider/pet_feed_provider.dart'; // Adjust the path as per your project structure

class PetFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Petgram',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Changed text color
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: List.generate(
                5, // Adjust the number of avatars as needed
                (index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle avatar click action if needed
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(
                        'assets/images/pet${index + 1}.jpg', // Replace with your image asset path
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Consumer<PetFeedProvider>(
              builder: (context, feedProvider, child) {
                return ListView.builder(
                  itemCount: feedProvider.posts.length,
                  itemBuilder: (context, index) {
                    final post = feedProvider.posts[index];
                    return _buildPostItem(post, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black87,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              color: Colors.black87,
            ),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            label: 'Search',
          ),
        ],
        currentIndex: 0, // Set the initial index as needed
        onTap: (index) {
          // Handle navigation to different screens based on index
          // Example:
          if (index == 1) {
            // Navigate to add post screen
            // You can implement navigation logic here
          }
        },
      ),
    );
  }

  Widget _buildPostItem(Post post, BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            post.imageUrl,
            fit: BoxFit.cover,
            height: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.caption,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LightColors.textColor,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Implement like functionality
                        if (post.isLiked) {
                          Provider.of<PetFeedProvider>(context, listen: false)
                              .unlikePost(post.id);
                        } else {
                          Provider.of<PetFeedProvider>(context, listen: false)
                              .likePost(post.id);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        // Implement comment functionality
                        _showAddCommentDialog(context, post);
                      },
                    ),
                  ],
                ),
                _buildComments(post.comments),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComments(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) {
        return Text(
          '${comment.userId}: ${comment.content}',
          style: TextStyle(
            fontSize: 14.0,
          ),
        );
      }).toList(),
    );
  }

  void _showAddCommentDialog(BuildContext context, Post post) {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'Enter your comment',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  Provider.of<PetFeedProvider>(context, listen: false)
                      .addComment(
                    post.id,
                    Comment(
                      id: DateTime.now().toString(),
                      userId: 'user', // Replace with actual user ID or name
                      content: commentController.text,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
