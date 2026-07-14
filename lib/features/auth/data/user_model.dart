class UserModel {
  final int id;
  final String nom;
  final String email;
  final String? photoProfil;

  UserModel({
    required this.id,
    required this.nom,
    required this.email,
    this.photoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      photoProfil: json['photo_profil'],
    );
  }
}
