import 'package:tradeable_learn_widget/level_complete_screen/recommendation_model.dart';

class Level {
  final String levelInternalName;
  final int levelId;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final String status;
  List<Node>? graph;
  final bool isDemo;
  final List<String>? tickers;
  final Recommendations? recommendations;

  Level({
    required this.levelInternalName,
    required this.levelId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.status,
    this.graph,
    required this.isDemo,
    this.tickers,
    this.recommendations,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      levelInternalName: json['level_internal_name'] ?? "",
      levelId: json['level_id'] ?? "",
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      type: json['type'],
      status: json['status'] ?? "",
      graph: (json['graph'] as List?)?.map((e) => Node.fromJson(e)).toList(),
      isDemo: json['is_demo'],
      tickers: (json['tickers'] as List?)?.map((e) => e as String).toList(),
      recommendations: json['recommendations'] != null
          ? Recommendations.fromJson(
              json['recommendations'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelInternalName': levelInternalName,
      'levelId': levelId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'status': status,
      'graph': graph?.map((e) => e.toJson()).toList(),
      'is_demo': isDemo,
      'tickers': tickers,
      'recommendations': recommendations?.toJson(),
    };
  }
}

enum Type { start, end, intermediate }

class Node {
  final int nodeId;
  final Type type;
  final String? model;
  final List<Edge>? edges;
  bool? isVisited;
  dynamic data;

  Node(
      {required this.nodeId,
      required this.type,
      this.model,
      this.edges,
      this.isVisited = false,
      this.data});

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
        nodeId: json['node_id'],
        type: Type.values
            .firstWhere((e) => e.toString() == 'Type.${json['type']}'),
        // model: json['model'] != null
        //     ? ExperienceBaseModel.fromJson(json['model'])
        //     : null,
        model: json["model_type"],
        edges: (json['edges'] as List?)?.map((e) => Edge.fromJson(e)).toList(),
        isVisited: json['isVisited'] ?? false,
        data: json["data"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'nodeId': nodeId,
      'type': type.toString().split('.').last,
      'model': model,
      'edges': edges?.map((e) => e.toJson()).toList(),
      'isVisited': isVisited,
    };
  }
}

class Edge {
  final String pathId;
  final int endNodeId;
  final double xp;

  Edge({required this.pathId, required this.endNodeId, required this.xp});

  factory Edge.fromJson(Map<String, dynamic> json) {
    return Edge(
      pathId: json['edgeId'],
      endNodeId: json['endNodeId'],
      xp: (json['xp'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'edgeId': pathId,
      'endNodeId': endNodeId,
      'xp': xp,
    };
  }
}

class ExperienceBaseModel {
  final String type;
  final dynamic data;

  ExperienceBaseModel({required this.type, this.data});

  factory ExperienceBaseModel.fromJson(Map<String, dynamic> json) {
    return ExperienceBaseModel(
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }
}
