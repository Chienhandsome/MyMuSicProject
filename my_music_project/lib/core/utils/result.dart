/// Result class for handling operations that can fail
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  /// Create a success result
  factory Result.success(T data) {
    return Result._(
      data: data,
      isSuccess: true,
    );
  }

  /// Create a failure result
  factory Result.failure(String error) {
    return Result._(
      error: error,
      isSuccess: false,
    );
  }

  /// Check if result is successful
  bool get isFailure => !isSuccess;

  /// Get data or throw if failure
  T get dataOrThrow {
    if (isFailure) {
      throw Exception(error ?? 'Unknown error');
    }
    return data!;
  }

  /// Map the data if successful
  Result<R> map<R>(R Function(T data) mapper) {
    if (isFailure) {
      return Result.failure(error ?? 'Unknown error');
    }
    try {
      return Result.success(mapper(data!));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  /// Execute callback if successful
  Result<T> onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) {
      callback(data!);
    }
    return this;
  }

  /// Execute callback if failure
  Result<T> onFailure(void Function(String error) callback) {
    if (isFailure && error != null) {
      callback(error!);
    }
    return this;
  }
}