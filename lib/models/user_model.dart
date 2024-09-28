class UserModel {
  final String userId;
  final String name;
  final String email;
  int rating;
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
      rating: (data['rating'] ?? 0).toInt(),
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
  void addComment(Comment comment) {
    comments.add(comment);
  }
  UserModel copyWith({
    String? name,
    String? email,
    int? rating,
    List<Comment>? comments,
    bool? isAdmin,
  }) {
    return UserModel(
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      comments: comments ?? this.comments,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
  void calculateAverageRating() {
    if (comments.isNotEmpty) {
      int totalRating = comments.fold(0, (sum, comment) => sum + comment.rating);
      rating = (totalRating / comments.length).round();
    } else {
      rating = 0;
    }
  }

}

class Comment {
  final String commentId;
  final String userId;
  final String content;
  final DateTime timestamp;
  final int rating;

  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.rating,
  });

  factory Comment.fromMap(Map<dynamic, dynamic> data) {
    return Comment(
      commentId: data['commentId'] ?? '',
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
      rating: (data['rating'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'rating' : rating
    };
  }
}

