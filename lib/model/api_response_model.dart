class ApiResponseModel<T> {
  int? status;
  String? title;
  int? timestamp;
  Pagination? pagination;
  T? data;

  ApiResponseModel({this.status, this.title, this.timestamp, this.pagination, this.data});

  factory ApiResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return ApiResponseModel<T>(
      status: json['status'],
      title: json['title'],
      timestamp: json['timestamp'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class Pagination {
  int? page;
  int? size;
  int? total;
  int? totalPages;

  Pagination({this.page, this.size, this.total, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json)
      : page = json['page'],
        size = json['size'],
        total = json['total'],
        totalPages = json['totalPages'];

  Map<String, dynamic> toJson() => {
    'page': page,
    'size': size,
    'total': total,
    'totalPages': totalPages,
  };
}