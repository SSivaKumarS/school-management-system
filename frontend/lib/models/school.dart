class School {
  final int id;
  final String name;
  final String location;
  final String board;
  final int fees;
  final String image;
  final String description;
  final int established;
  final int students;
  final int teachers;
  final List<String> facilities;
  final double rating;
  final String contact;
  final String website;
  final String address;

  School({
    required this.id,
    required this.name,
    required this.location,
    required this.board,
    required this.fees,
    required this.image,
    required this.description,
    required this.established,
    required this.students,
    required this.teachers,
    required this.facilities,
    required this.rating,
    required this.contact,
    required this.website,
    required this.address,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      board: json['board'] as String,
      fees: json['fees'] as int,
      image: json['image'] as String,
      description: json['description'] as String? ?? '',
      established: json['established'] as int? ?? 2000,
      students: json['students'] as int? ?? 0,
      teachers: json['teachers'] as int? ?? 0,
      facilities: List<String>.from(json['facilities'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      contact: json['contact'] as String? ?? '',
      website: json['website'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'board': board,
      'fees': fees,
      'image': image,
      'description': description,
      'established': established,
      'students': students,
      'teachers': teachers,
      'facilities': facilities,
      'rating': rating,
      'contact': contact,
      'website': website,
      'address': address,
    };
  }
}
