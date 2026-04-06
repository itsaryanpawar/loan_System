class LoanApplication {
  String? loanType;
  String? name;
  String? phoneNumber;
  String? city;
  String? monthlyIncome;
  String? employmentType;
  bool? isApproved;
  DateTime? createdAt;

  LoanApplication({
    this.loanType,
    this.name,
    this.phoneNumber,
    this.city,
    this.monthlyIncome,
    this.employmentType,
    this.isApproved,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'loanType': loanType,
      'name': name,
      'phoneNumber': phoneNumber,
      'city': city,
      'monthlyIncome': monthlyIncome,
      'employmentType': employmentType,
      'isApproved': isApproved,
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      loanType: json['loanType'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      city: json['city'],
      monthlyIncome: json['monthlyIncome'],
      employmentType: json['employmentType'],
      isApproved: json['isApproved'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  bool get isComplete {
    return loanType != null &&
        name != null &&
        phoneNumber != null &&
        city != null &&
        monthlyIncome != null &&
        employmentType != null;
  }
}
