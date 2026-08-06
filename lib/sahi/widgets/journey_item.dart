class JourneyItem {
  final String id;
  bool active;
  bool completed;

  JourneyItem({
    required this.id,
    this.active = false,
    this.completed = false,
  });
}
