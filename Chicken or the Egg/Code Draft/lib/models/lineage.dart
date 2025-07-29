class Lineage {
  final String id;
  final String name;
  final List<String> parentIds; // Can be used to map genetic relationships
  final String originCoop;
  final String notes;

  Lineage({
    required this.id,
    required this.name,
    required this.parentIds,
    required this.originCoop,
    required this.notes,
  });

  factory Lineage.fromFirestore(Map<String, dynamic> data, String id) {
    return Lineage(
      id: id,
      name: data['name'],
      parentIds: List<String>.from(data['parentIds']),
      originCoop: data['originCoop'],
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'parentIds': parentIds,
      'originCoop': originCoop,
      'notes': notes,
    };
  }
}
