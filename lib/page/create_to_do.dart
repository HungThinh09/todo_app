import 'package:flutter/material.dart';
import 'package:todo_app/constanst/color.dart';
import 'package:todo_app/constanst/toast.dart';
import '../model/todo.dart';

class CreateToDo extends StatefulWidget {
  final Function(ToDo) onAddToDo;
  final String? id;
  final ToDo? existingToDo;
  final List<ToDo> existingToDos;

  const CreateToDo({
    Key? key,
    required this.onAddToDo,
    this.id,
    this.existingToDo,
    required this.existingToDos,
  }) : super(key: key);

  @override
  _CreateToDoState createState() => _CreateToDoState();
}

class _CreateToDoState extends State<CreateToDo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingToDo != null) {
      _titleController.text = widget.existingToDo!.todoText ?? '';
      _descriptionController.text = widget.existingToDo!.description ?? '';
      _isDone = widget.existingToDo!.isDone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingToDo == null ? 'Tạo công việc' : 'Sửa công việc',
          style: const TextStyle(color: tdWhiteColor, fontSize: 20),
        ),
        backgroundColor: tdBGColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tên công việc',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Mời nhập tên công việc!',
                  hintStyle: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 16),
            const Text('Mô tả',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Mời nhập mô tả công việc!',
                  hintStyle: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isDone = !_isDone;
                });
              },
              child: Row(
                children: [
                  const Text(
                    'Đã xong',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Checkbox(
                    value: _isDone,
                    onChanged: (bool? value) {
                      setState(() {
                        _isDone = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String titleText = _titleController.text.trim();

                  bool isDuplicateTitle = widget.existingToDos.any((todo) {
                    if (widget.existingToDo != null &&
                        widget.existingToDo!.id == todo.id) {
                      return false;
                    }
                    return todo.todoText!.toLowerCase() ==
                        titleText.toLowerCase();
                  });

                  if (titleText.isNotEmpty) {
                    if (isDuplicateTitle) {
                      showCustomToastErrors("Tiêu đề công việc đã tồn tại!");
                    } else {
                      ToDo newToDo = ToDo(
                        id: widget.existingToDo?.id ??
                            DateTime.now().microsecondsSinceEpoch.toString(),
                        todoText: _titleController.text,
                        description: _descriptionController.text,
                        isDone: _isDone,
                      );
                      widget.onAddToDo(newToDo);
                      Navigator.pop(context);
                    }
                  } else {
                    showCustomToastErrors("Tên công việc không được bỏ trống");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tbBlue,
                  minimumSize: const Size(60, 60),
                  elevation: 10,
                ),
                child: Text(
                  widget.existingToDo == null ? 'Thêm' : 'Sửa',
                  style: const TextStyle(fontSize: 20, color: tdWhiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
