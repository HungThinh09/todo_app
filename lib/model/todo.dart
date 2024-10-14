class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String? description;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    this.description,
  });
  static List<ToDo> todoList() {
    return [
      ToDo(
          id: '01',
          todoText: 'Play the game',
          isDone: false,
          description:
              'GameVui khuyên bạn: Chơi game lành mạnh, vui vẻ, sắp xếp thời gian hợp lý, tận hưởng cuộc sống lành mạnh, học tập tốt và lao động tốt.'),
    ];
  }
}
