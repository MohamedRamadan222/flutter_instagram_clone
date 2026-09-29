class MessagesDummyData {
  static const List<Map<String, dynamic>> chats = [
    {
      'chatId': 'c1',
      'username': 'omar.khaled',
      'profilePic':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop',
      'lastMessage': 'That shot is incredible bro',
      'timeAgo': '2m',
      'unread': 2,
      'messages': [
        {'fromMe': false, 'text': 'Hey, loved your last post', 'time': '10:01'},
        {'fromMe': true, 'text': 'Thanks man!', 'time': '10:02'},
        {'fromMe': false, 'text': 'That shot is incredible bro', 'time': '10:03'},
      ],
    },
    {
      'chatId': 'c2',
      'username': 'fatima.noor',
      'profilePic':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop',
      'lastMessage': 'Send me the location please',
      'timeAgo': '1h',
      'unread': 0,
      'messages': [
        {'fromMe': false, 'text': 'Where was this taken?', 'time': '09:10'},
        {'fromMe': true, 'text': 'Dubai marina', 'time': '09:12'},
        {'fromMe': false, 'text': 'Send me the location please', 'time': '09:15'},
      ],
    },
    {
      'chatId': 'c3',
      'username': 'layla.hassan',
      'profilePic':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400&auto=format&fit=crop',
      'lastMessage': 'New drop tomorrow!',
      'timeAgo': '3h',
      'unread': 1,
      'messages': [
        {'fromMe': false, 'text': 'New drop tomorrow!', 'time': '08:00'},
      ],
    },
    {
      'chatId': 'c4',
      'username': 'yusuf.ali',
      'profilePic':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=400&auto=format&fit=crop',
      'lastMessage': '35mm forever',
      'timeAgo': '1d',
      'unread': 0,
      'messages': [
        {'fromMe': true, 'text': 'Which lens?', 'time': 'Yesterday'},
        {'fromMe': false, 'text': '35mm forever', 'time': 'Yesterday'},
      ],
    },
  ];
}
