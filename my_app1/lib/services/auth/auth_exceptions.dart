//login exceptions:
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class InvalidCredentialsException implements Exception {}

class ChannelErrorException implements Exception {}

//register expetions:

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

//generic exceptions:

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
