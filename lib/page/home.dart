import 'package:flutter/material.dart';
import 'package:todo_app/constanst/toast.dart';
import 'package:todo_app/page/create_to_do.dart';
import '../constanst/color.dart';
import '../model/todo.dart';
import '../page/to_do_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  List<ToDo> _foundToDo = [];

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                SearchBox(),
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      child: const Text(
                        "Tất cả công việc!",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),
                    for (ToDo todoo in _foundToDo)
                      ToDoItem(
                        todo: todoo,
                        onToDoChange: _handleToDoChange,
                        onDeleteItem: _handleToDoDelete,
                        editToDoItem: _editToDoItem,
                      )
                  ],
                ))
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 0)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: tdGrey),
                        hintText: 'Thêm công việc!',
                        border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tbBlue,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 40, color: tdWhiteColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _runFilter(String keyword) {
    List<ToDo> results = [];
    if (keyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todoText!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      showCustomToastSuccess('Thay đổi trạng thái thành công!');
    });
  }

  void _handleToDoDelete(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm!'),
          content: const Text('Bạn có chắc muốn xóa công việc không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todosList.removeWhere((item) => item.id == id);
                  showCustomToastSuccess('Xóa thành công!');
                });
                Navigator.of(context).pop();
              },
              child: const Text('Có'),
            ),
          ],
        );
      },
    );
  }

  void _editToDoItem(String id) {
    int.parse(id);
    ToDo existingToDo = todosList.firstWhere((todo) => todo.id == id);
    int index = todosList.indexWhere((todo) => todo.id == id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateToDo(
          onAddToDo: (updatedToDo) {
            setState(() {
              todosList[index] = updatedToDo;
            });
            showCustomToastSuccess("Chỉnh sửa việc làm thành công!");
          },
          existingToDo: existingToDo,
          existingToDos: [],
        ),
      ),
    );
  }

  void _addToDoItem(String toDo) {
    String toDo = _todoController.text.trim();
    if (toDo.isNotEmpty) {
      bool isDuplicate = todosList
          .any((todo) => todo.todoText!.toLowerCase() == toDo.toLowerCase());

      if (isDuplicate) {
        showCustomToastErrors("Tiêu đề công việc đã tồn tại!");
      } else {
        setState(() {
          todosList.add(ToDo(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            todoText: toDo,
            description: '',
          ));
          _todoController.clear();
          showCustomToastSuccess("Tạo việc làm thành công!");
        });
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateToDo(
            onAddToDo: (newToDo) {
              setState(() {
                todosList.add(newToDo);
              });
              showCustomToastSuccess("Tạo việc làm thành công!");
            },
            existingToDos: todosList,
          ),
        ),
      ).then((result) {
        if (result == true) {
          showCustomToastSuccess("Tạo việc làm thành công!");
        }
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget SearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 220, 220),
          borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 30, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Tìm kiếm...',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: tdBGColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.bakery_dining_sharp,
          color: tdBlack,
          size: 30,
        ),
        const Text(
          "HungT",
          style: TextStyle(color: tdBlack),
        ),
        // const Spacer(),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar_2.jpg')),
        )
      ],
    ),
  );
}
