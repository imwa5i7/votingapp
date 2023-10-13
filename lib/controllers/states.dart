class States<T> {
  Status status;
  T? data;
  String? message;
  States.initial(this.message) : status = Status.initial;
  States.loading(this.message) : status = Status.loading;
  States.buttonLoading(this.message) : status = Status.buttonLoading;
  States.completed(this.data) : status = Status.completed;
  States.error(this.message) : status = Status.error;
  States.noInternet(this.message) : status = Status.noInternet;
  States.unAuthorised(this.message) : status = Status.unAuthorised;
  States.timeout(this.message) : status = Status.timeout;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status {
  initial,
  loading,
  buttonLoading,
  completed,
  error,
  noInternet,
  unAuthorised,
  timeout
}
