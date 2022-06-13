
class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;

  Chat ({
    this.name = '',
    this.lastMessage = '',
    this.image = '',
    this.time = '',
    this.isActive = false
  });
}

List chatsData = [
  Chat(
    name: "USER1",
    lastMessage:"Hello World",
    image: "assets/images/NUS_LOGO.png",
    time:"5d ago",
    isActive: true,
  ),
  Chat(
    name: "USER2",
    lastMessage:"Welcome to this world",
    image: "assets/images/NUS_LOGO.png",
    time:"5d ago",
    isActive: true,
  )
];