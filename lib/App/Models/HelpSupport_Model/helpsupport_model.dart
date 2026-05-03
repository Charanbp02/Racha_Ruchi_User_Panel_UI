class FaqModel {
  final String id;
  final String category;
  final String question;
  final String answer;

  FaqModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });
}

class SupportTicketModel {
  final String id;
  final String subject;
  final String status;
  final String createdAt;
  final String lastUpdated;

  SupportTicketModel({
    required this.id,
    required this.subject,
    required this.status,
    required this.createdAt,
    required this.lastUpdated,
  });
}

class ContactInfo {
  final String email;
  final String phone;
  final String whatsapp;
  final String address;
  final String workingHours;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.address,
    required this.workingHours,
  });
}
