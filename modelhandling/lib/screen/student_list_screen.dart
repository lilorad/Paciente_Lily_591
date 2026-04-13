import 'package:flutter/material.dart';
import 'package:modelhandling/model/student.dart';

// Define StudentService here or in studentdata.dart
class StudentService {
  Future<List<Student>> fetchStudent() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return mock student data
    return [
      Student(id: '1000', name: 'Alice', course: 'Math', gpa: 3.5),
      Student(id: '2000', name: 'Bob', course: 'Science', gpa: 3.8),
      Student(id: '3000', name: 'Charlie', course: 'History', gpa: 3.2),
    ];
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();

  List<Student> students = [];
  bool loading = false;
  String? errorMessage;

  Future<void> loadStudents() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final loadedStudents = await _studentService.fetchStudent();
      setState(() {
        students = loadedStudents;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load students.";
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : students.isEmpty
                  ? const Center(child: Text('No students available.'))
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return ListTile(
                          title: Text(student.name),
                          subtitle: Text(
                              'Course: ${student.course} | GPA: ${student.gpa.toStringAsFixed(2)}'),
                        );
                      },
                    ),
    );
  }
}
