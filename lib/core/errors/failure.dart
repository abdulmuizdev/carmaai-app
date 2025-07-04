abstract class Failure {
  final String message;

  const Failure(this.message);
}

class GeneralFailure extends Failure {
  const GeneralFailure(String message) : super(message);
}
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class ParsingFailure extends Failure {
  ParsingFailure(String message) : super(message);
}


// class NetworkFailure extends Failure {
//   const NetworkFailure(String message) : super(message);
// }
//
// class ServerFailure extends Failure {
//   const ServerFailure(String message) : super(message);
// }
//
// class UnknownFailure extends Failure {
//   const UnknownFailure(String message) : super(message);
// }
