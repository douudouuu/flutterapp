import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String selectedCategory = "Personal";
  String selectedPriority = "Medium";
  DateTime? selectedDueDate;

  List<String> categories = ["Work", "Personal", "Shopping"];
  List<String> priorities = ["High", "Medium", "Low"];

  List toDoList = [
    ['Take medicines', true, "Personal", "Low", DateTime.now().add(Duration(days: 1))],
    ['Prepare reports', true, "Work", "High", DateTime.now().add(Duration(days: 2))],
    ['Doctor Appointment', false, "Personal", "High", DateTime.now()],
    ['Do the groceries', false, "Shopping", "Medium", DateTime.now().subtract(Duration(days: 1))],
  ];

  void sortTasksByPriority() {
    setState(() {
      toDoList.sort((a, b) {
        int priorityA = priorities.indexOf(a[3]);
        int priorityB = priorities.indexOf(b[3]);
        return priorityA.compareTo(priorityB);
      });
    });
  }

  void saveNewTask() {
    if (_controller.text.isNotEmpty && selectedDueDate != null) {
      setState(() {
        toDoList.add([
          _controller.text,
          false,
          selectedCategory,
          selectedPriority,
          selectedDueDate,
        ]);
        _controller.clear();
        selectedDueDate = null;
      });
      sortTasksByPriority();
    }
  }

  void deleteTask(int index) {
    String taskName = toDoList[index][0];
    setState(() {
      toDoList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task '$taskName' deleted"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void editTask(int index) {
    final task = toDoList[index];
    final TextEditingController editController = TextEditingController(text: task[0]);
    String editCategory = task[2];
    String editPriority = task[3];
    DateTime? editDueDate = task[4];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: editController,
                  decoration: const InputDecoration(labelText: "Task Name"),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: editCategory,
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      editCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: editPriority,
                  items: priorities
                      .map((priority) => DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      editPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: editDueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        editDueDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    editDueDate == null
                        ? "Select Due Date"
                        : DateFormat('yyyy-MM-dd').format(editDueDate!),
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  toDoList[index] = [
                    editController.text,
                    task[1],
                    editCategory,
                    editPriority,
                    editDueDate,
                  ];
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My To-Do List'),
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: "Sort by priority",
            onPressed: sortTasksByPriority,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add a new to do item',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedPriority,
                      items: priorities
                          .map((priority) => DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDueDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        selectedDueDate == null
                            ? "Select Due Date"
                            : DateFormat('yyyy-MM-dd').format(selectedDueDate!),
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: saveNewTask,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                final task = toDoList[index];
                final isOverdue = task[4].isBefore(DateTime.now()) && !task[1];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: isOverdue ? Colors.red.shade100 : Colors.white,
                  child: ListTile(
                    title: Text(
                      task[0],
                      style: TextStyle(
                        decoration: task[1] ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${task[2]}"),
                        Text("Priority: ${task[3]}"),
                        Text("Due: ${DateFormat('yyyy-MM-dd').format(task[4])}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(index),
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      value: task[1],
                      onChanged: (value) {
                        setState(() {
                          task[1] = value!;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
