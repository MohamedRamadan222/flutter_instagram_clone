class DummyData {
  static Map<String, dynamic> currentUser = accounts.first;

  static const List<Map<String, dynamic>> accounts = [
    {
      'username': 'mohamed.ahmed',
      'profilePic':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=400&auto=format&fit=crop',
      'name': 'Mohamed Ahmed',
      'bio': 'Digital Creator ✨\nPhotography lover 📸\nExploring the world 🌍',
      'followers': 12450,
      'following': 432,
      'isCurrent': true,
      'gender': 'Male',
    },
    {
      'username': 'omar.khaled',
      'profilePic':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop',
      'name': 'Omar Khaled',
      'bio': 'UI Designer 🎨\nFlutter lover 💙',
      'followers': 5421,
      'following': 301,
      'isCurrent': false,
      'gender': 'Male',
    },
    {
      'username': 'fatima.noor',
      'profilePic':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',
      'name': 'Fatima Noor',
      'bio': 'Travel blogger ✈️',
      'followers': 23100,
      'following': 612,
      'isCurrent': false,
      'gender': 'Female',
    },
    {
      'username': 'aisha.mahmoud',
      'profilePic':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop',
      'name': 'Aisha Mahmoud',
      'bio': 'Food blogger 🍩\nSharing sweet moments ✨',
      'followers': 8930,
      'following': 540,
      'isCurrent': false,
      'gender': 'Female',
    },
    {
      'username': 'yusuf.ali',
      'profilePic':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop',
      'name': 'Yusuf Ali',
      'bio': 'Photographer 📷\nCapturing the unseen 🌙',
      'followers': 15200,
      'following': 289,
      'isCurrent': false,
      'gender': 'Male',
    },
    {
      'username': 'layla.hassan',
      'profilePic':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto=format&fit=crop',
      'name': 'Layla Hassan',
      'bio': 'Fashion lover 👗\nNew collection soon 💫',
      'followers': 31200,
      'following': 720,
      'isCurrent': false,
      'gender': 'Female',
    },
    {
      'username': 'bilal.ibrahim',
      'profilePic':
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=400&auto=format&fit=crop',
      'name': 'Bilal Ibrahim',
      'bio': 'Latest tech updates 🚀',
      'followers': 98100,
      'following': 45,
      'isCurrent': false,
      'gender': 'Male',
    },
    {
      'username': 'hamza.yassin',
      'profilePic':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=400&auto=format&fit=crop',
      'name': 'Hamza Yassin',
      'bio': 'Fitness coach 💪\nTrain every day 🔥',
      'followers': 7640,
      'following': 355,
      'isCurrent': false,
      'gender': 'Male',
    },
  ];

  static const List<Map<String, dynamic>> exploreMedia = [
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=800&auto=format&fit=crop",
    },
    {
      "type": "video",
      "url":
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    },
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=800&auto=format&fit=crop",
    },
    {
      "type": "video",
      "url":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    },
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?q=80&w=800&auto=format&fit=crop",
    },
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800&auto=format&fit=crop",
    },
  ];

  static const followers = [
    {
      "username": "omar.khaled",
      "name": "Omar Khaled",
      "profilePic":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "fatima.noor",
      "name": "Fatima Noor",
      "profilePic":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "yusuf.ali",
      "name": "Yusuf Ali",
      "profilePic":
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "layla.hassan",
      "name": "Layla Hassan",
      "profilePic":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "hamza.yassin",
      "name": "Hamza Yassin",
      "profilePic":
          "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=400&auto=format&fit=crop",
    },
  ];

  static const following = [
    {
      "username": "aisha.mahmoud",
      "name": "Aisha Mahmoud",
      "profilePic":
          "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "bilal.ibrahim",
      "name": "Bilal Ibrahim",
      "profilePic":
          "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=400&auto=format&fit=crop",
    },
    {
      "username": "omar.khaled",
      "name": "Omar Khaled",
      "profilePic":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop",
    },
  ];

  static const List<Map<String, dynamic>> suggestedUsers = [
    {
      "username": "yusuf.ali",
      "name": "Yusuf Ali",
      "image":
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop",
      "mutual": 3,
    },
    {
      "username": "fatima.noor",
      "name": "Fatima Noor",
      "image":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop",
      "mutual": 5,
    },
    {
      "username": "layla.hassan",
      "name": "Layla Hassan",
      "image":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto=format&fit=crop",
      "mutual": 1,
    },
    {
      "username": "omar.khaled",
      "name": "Omar Khaled",
      "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop",
      "mutual": 8,
    },
    {
      "username": "hamza.yassin",
      "name": "Hamza Yassin",
      "image":
          "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=400&auto=format&fit=crop",
      "mutual": 2,
    },
  ];

  static const List<Map<String, dynamic>> savedPosts = [
    {
      "id": "post1",
      "image":
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post2",
      "image":
          "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post3",
      "image":
          "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post4",
      "image":
          "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post5",
      "image":
          "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post6",
      "image":
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post7",
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=800&auto=format&fit=crop",
    },
    {
      "id": "post8",
      "image":
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=800&auto=format&fit=crop",
    },
  ];

  /// COLLECTIONS
  static const List<Map<String, dynamic>> collections = [
    {
      "name": "Travel",
      "privacy": "Private",
      "posts": ["post1", "post4", "post8"],
    },
    {
      "name": "Design",
      "privacy": "Public",
      "posts": ["post2"],
    },
    {
      "name": "Workout",
      "privacy": "Private",
      "posts": ["post3", "post5", "post6", "post7"],
    },
  ];

  /// GET LAST POST IMAGE OF COLLECTION
  static String getCollectionPreview(String collectionName) {
    final collection = collections.firstWhere(
      (c) => c["name"] == collectionName,
    );

    final List posts = collection["posts"];

    if (posts.isEmpty) {
      return "";
    }

    final lastPostId = posts.last;

    final post = savedPosts.firstWhere((p) => p["id"] == lastPostId);

    return post["image"];
  }

  static List<Map<String, dynamic>> getPostsByCollection(
    String collectionName,
  ) {
    /// Find collection
    final collection = collections.firstWhere(
      (c) => c["name"] == collectionName,
    );

    final List postIds = collection["posts"];

    /// Filter savedPosts
    return savedPosts.where((post) {
      return postIds.contains(post["id"]);
    }).toList();
  }
}
