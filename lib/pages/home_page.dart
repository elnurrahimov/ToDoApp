import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> todoitems = [
    ['item1', false],
    ['item2', false]
  ];
  bool isChecked = false;
  TextEditingController _controller = TextEditingController();


  void initState() {
    super.initState();
    loadList(); // Load the list when the app starts
  }

  Future<void> saveList() async {
    var sp = await SharedPreferences.getInstance();
    List<String> stringList = todoitems
        .map((item) => jsonEncode(item)) // Serialize each item
        .toList();
    sp.setStringList("todolist", stringList);
  }

  Future<void> loadList() async {
    var sp = await SharedPreferences.getInstance();
    List<String>? stringList = sp.getStringList("todolist");
    if (stringList != null) {
      todoitems = stringList
          .map((item) => jsonDecode(item)) // Deserialize each item
          .toList()
          .cast<List<dynamic>>();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Center(child: Text("To-Do list")),
      backgroundColor: const Color(0xff2980b9),
    );
  }

  Widget _buildBody(BuildContext context){

    var screenWidth = MediaQuery.of(context).size.width; // Get the screen width

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: todoitems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth * 0.9, // Set the width as 90% of screen width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF6699CC),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to push items apart
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: todoitems[index][1], // Use the stored state
                              onChanged: (bool? value) {
                                _toggleItem(index, value);
                              },
                            ),
                            Text(
                              todoitems[index][0],
                              style: TextStyle(
                                fontSize: 18,
                                decoration: todoitems[index][1]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              maxLines: 1, // Limit the text to 1 line
                              overflow: TextOverflow.ellipsis, // Add ellipsis (...) if the text is too long
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () => _deleteItem(index), // Pass the index to delete the correct item
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 3.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey, width: 3.0),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      hintText: 'Enter your todo item',
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: _addItem,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addItem(){
    String newItem = _controller.text;
    newItem.isNotEmpty ?
    setState(() {
      todoitems.add([newItem, false]);
      _controller.clear();
    })
        : null;
    saveList();
  }

  void _toggleItem(int index, bool? value) {
    setState(() {
      todoitems[index][1] = value;
    });
    saveList();
  }
  void _deleteItem(int index){
    setState(() {
      todoitems.removeAt(index);
    });
    saveList();
  }
}

