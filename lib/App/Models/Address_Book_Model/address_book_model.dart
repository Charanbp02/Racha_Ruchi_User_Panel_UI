class AddressModel {
  final String id;
  final String type;
  final String name;
  final String phone;
  final String? alternatePhone;
  final String addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final String country;
  bool isDefault;
  final double? latitude;
  final double? longitude;

  AddressModel({
    required this.id,
    required this.type,
    required this.name,
    required this.phone,
    this.alternatePhone,
    required this.addressLine1,
    this.addressLine2,
    this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });
}
