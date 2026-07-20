/// Représente un paiement passé (abonnement ou achat à l'unité).
/// Correspond à la classe UML `Paiement`.
class TransactionModel {
  final int id;
  final String description; // ex: "Abonnement Mensuel - Plan Formule"
  final double montant;
  final DateTime date;
  final String methodePaiement; // "Orange Money" | "Moov Money"
  final String statut; // "succes" | "echec" | "en_attente"

  TransactionModel({
    required this.id,
    required this.description,
    required this.montant,
    required this.date,
    required this.methodePaiement,
    required this.statut,
  });

  bool get estReussi => statut == 'succes';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      description: json['description'],
      montant: double.parse(json['montant'].toString()),
      date: DateTime.parse(json['date']),
      methodePaiement: json['methode_paiement'],
      statut: json['statut'],
    );
  }
}
