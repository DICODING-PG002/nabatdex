enum ActivityType {
  penyiraman('Penyiraman'),
  memberiObat('Memberi Obat'),
  pemupukan('Pemupukan'),
  lainnya('Lainnya');

  final String displayName;

  const ActivityType(this.displayName);

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.displayName == value,
      orElse: () => ActivityType.lainnya,
    );
  }

  @override
  String toString() => displayName;
}

