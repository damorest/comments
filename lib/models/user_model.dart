class UserModel {
  final String userId;
  final String name;
  final String email;
  final double rating;
  final List<Comment> comments;
  bool isAdmin;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.rating,
    required this.comments,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comments: (data['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromMap(comment))
          .toList() ??
          [],
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'rating': rating,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'isAdmin': isAdmin,
    };
  }
}

class Comment {
  final String commentId;
  final String userId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<dynamic, dynamic> data) {
    return Comment(
      commentId: data['commentId'] ?? '',
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

List<Comment> filterCommentsByUser(String currentUserId, List<Comment> comments) {
  return comments.where((comment) => comment.userId == currentUserId).toList();
}
