/// Modelo para representar o usuário e seu progresso
class UserModel {
  String name;
  int points;
  List<String> badges;
  List<String> studiedFunctions;
  
  UserModel({
    required this.name,
    this.points = 0,
    List<String>? badges,
    List<String>? studiedFunctions,
  }) : badges = badges ?? [],
       studiedFunctions = studiedFunctions ?? [];
  
  // Método para adicionar pontos
  void addPoints(int pointsToAdd) {
    points += pointsToAdd;
  }
  
  // Método para adicionar uma medalha
  void addBadge(String badge) {
    if (!badges.contains(badge)) {
      badges.add(badge);
    }
  }
  
  // Método para adicionar uma função estudada
  void addStudiedFunction(String function) {
    if (!studiedFunctions.contains(function)) {
      studiedFunctions.add(function);
    }
  }
}