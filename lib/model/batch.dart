class Batch {
  String author;
  String description;
  String id;
  String name;
  String timeCreated;
  Batch(
      {this.author = '',
      this.description = '',
      this.id = '',
      this.name = '',
      this.timeCreated = ''});
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'id': id,
      'name': name,
      'timecCreated': timeCreated,
      'desc': description
    };
  }
}
