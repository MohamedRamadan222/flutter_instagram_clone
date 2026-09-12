class DummySuggestedUser {
  final String username;
  final String fullName;
  final String imageUrl;
  bool isFollowing;

  DummySuggestedUser({
    required this.username,
    required this.fullName,
    required this.imageUrl,
    this.isFollowing = false,
  });
}

final List<DummySuggestedUser> dummySuggestedUsers = [
  DummySuggestedUser(
    username: "mohamed_ahmed",
    fullName: "Mohamed Ahmed",
    imageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "omar_khaled",
    fullName: "Omar Khaled",
    imageUrl:
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "yusuf_ali",
    fullName: "Yusuf Ali",
    imageUrl:
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "fatima_noor",
    fullName: "Fatima Noor",
    imageUrl:
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "aisha_mahmoud",
    fullName: "Aisha Mahmoud",
    imageUrl:
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "layla_hassan",
    fullName: "Layla Hassan",
    imageUrl:
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "bilal_ibrahim",
    fullName: "Bilal Ibrahim",
    imageUrl:
        "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=150&q=80",
  ),
  DummySuggestedUser(
    username: "hamza_yassin",
    fullName: "Hamza Yassin",
    imageUrl:
        "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=150&q=80",
  ),
];
