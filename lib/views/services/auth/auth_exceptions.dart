// login exc

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//reg exc
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exc
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
