import 'package:flutter_test/flutter_test.dart';
import 'package:argus_core/argus_core.dart';

void main() {
  test('User model JSON serialization and deserialization', () {
    const user = User(
      id: 'USR-001',
      email: 'test@example.com',
      name: 'John Doe',
      role: UserRole.staff,
      plantId: 'PLT-123',
    );

    final json = user.toJson();
    expect(json['id'], 'USR-001');
    expect(json['email'], 'test@example.com');
    expect(json['name'], 'John Doe');
    expect(json['role'], 'staff');
    expect(json['plant_id'], 'PLT-123');

    final deserialized = User.fromJson(json);
    expect(deserialized, user);
  });
}
