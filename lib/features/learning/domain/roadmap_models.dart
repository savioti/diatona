class RoadmapOption {
  const RoadmapOption({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.filename,
    required this.icon,
  });

  final String id;
  final String title;
  final String shortDescription;
  final String filename;
  final String icon;
}

class Roadmap {
  const Roadmap({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.sections,
  });

  final String id;
  final String title;
  final String shortDescription;
  final List<RoadmapSection> sections;

  int get totalTopics => sections.fold(0, (sum, s) => sum + s.topics.length);

  factory Roadmap.fromJson(Map<String, dynamic> json) {
    final rawSections = (json['sections'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(RoadmapSection.fromJson)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return Roadmap(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      sections: rawSections,
    );
  }
}

class RoadmapSection {
  const RoadmapSection({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.difficulty,
    required this.order,
    required this.topics,
  });

  final String id;
  final String title;
  final String shortDescription;
  final String difficulty;
  final int order;
  final List<RoadmapTopic> topics;

  factory RoadmapSection.fromJson(Map<String, dynamic> json) {
    final rawTopics = (json['topics'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(RoadmapTopic.fromJson)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return RoadmapSection(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      topics: rawTopics,
    );
  }
}

class RoadmapTopic {
  const RoadmapTopic({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.difficulty,
    required this.order,
    required this.estimatedTime,
    required this.objectives,
    required this.commonMistakes,
    required this.practiceTips,
    required this.resources,
    required this.tags,
    required this.assessments,
  });

  final String id;
  final String sectionId;
  final String title;
  final String shortDescription;
  final String longDescription;
  final String difficulty;
  final int order;
  final EstimatedTime estimatedTime;
  final List<String> objectives;
  final List<String> commonMistakes;
  final List<String> practiceTips;
  final List<TopicResource> resources;
  final List<String> tags;
  final List<Assessment> assessments;

  factory RoadmapTopic.fromJson(Map<String, dynamic> json) {
    return RoadmapTopic(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String? ?? '',
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      longDescription: json['longDescription'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      estimatedTime: json['estimatedTime'] != null
          ? EstimatedTime.fromJson(json['estimatedTime'] as Map<String, dynamic>)
          : const EstimatedTime(min: 0, max: 0, unit: ''),
      objectives: _stringList(json['objectives']),
      commonMistakes: _stringList(json['commonMistakes']),
      practiceTips: _stringList(json['practiceTips']),
      resources: (json['resources'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(TopicResource.fromJson)
          .toList(),
      tags: _stringList(json['tags']),
      assessments: (json['assessments'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Assessment.fromJson)
          .toList(),
    );
  }

  static List<String> _stringList(dynamic raw) =>
      (raw as List<dynamic>? ?? []).cast<String>();
}

class EstimatedTime {
  const EstimatedTime({
    required this.min,
    required this.max,
    required this.unit,
  });

  final int min;
  final int max;
  final String unit;

  bool get isEmpty => min == 0 && max == 0;

  factory EstimatedTime.fromJson(Map<String, dynamic> json) {
    return EstimatedTime(
      min: json['min'] as int? ?? 0,
      max: json['max'] as int? ?? 0,
      unit: json['unit'] as String? ?? '',
    );
  }
}

class TopicResource {
  const TopicResource({
    required this.id,
    required this.type,
    required this.url,
    required this.title,
    this.durationInMinutes,
  });

  final String id;
  final String type;
  final String url;
  final String title;
  final int? durationInMinutes;

  factory TopicResource.fromJson(Map<String, dynamic> json) {
    return TopicResource(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationInMinutes: json['durationInMinutes'] as int?,
    );
  }
}

class Assessment {
  const Assessment({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.questions,
  });

  final String id;
  final String type;
  final String title;
  final String description;
  final List<AssessmentQuestion> questions;

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(AssessmentQuestion.fromJson)
          .toList(),
    );
  }
}

class AssessmentQuestion {
  const AssessmentQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIds,
    required this.explanation,
  });

  final String id;
  final String questionText;
  final List<QuestionOption> options;
  final List<String> correctOptionIds;
  final String explanation;

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(QuestionOption.fromJson)
          .toList(),
      correctOptionIds:
          (json['correctOptionIds'] as List<dynamic>? ?? []).cast<String>(),
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class QuestionOption {
  const QuestionOption({required this.id, required this.optionText});

  final String id;
  final String optionText;

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String? ?? '',
      optionText: json['optionText'] as String? ?? '',
    );
  }
}
