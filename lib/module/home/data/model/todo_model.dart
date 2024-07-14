
class TodoModel {
  final String id; // Document ID (optional)
  final String name;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String uid; // User ID

  TodoModel({
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.id = '',
    required this.uid,
  });

  // You can also add methods for converting to/from Map representation
  // for easier interaction with Firestore

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      // Store timestamps in milliseconds
      'uid': uid,
    };
  }

  static TodoModel fromMap(Map<String, dynamic> map, dynamic id) {
    return TodoModel(
      id: id,
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      isCompleted: map['isCompleted'] == null
          ? false
          : map['isCompleted'] == 0
              ? false
              : true,
      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uid: map['uid'] ?? "",
    );
  }
}
