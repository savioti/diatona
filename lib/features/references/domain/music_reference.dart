class MusicReference {
  const MusicReference({
    required this.id,
    required this.type,
    required this.title,
    required this.shortDescription,
    required this.howItWorks,
    required this.tags,
  });

  final String id;
  final String type;
  final String title;
  final String shortDescription;
  final String howItWorks;
  final List<String> tags;

  factory MusicReference.fromJson(Map<String, dynamic> json) => MusicReference(
        id: json['id'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        shortDescription: json['shortDescription'] as String,
        howItWorks: json['howItWorks'] as String,
        tags: (json['tags'] as List<dynamic>).cast<String>(),
      );
}
