class EmpApi {
  List<Employees> employees;

  EmpApi({this.employees});

  EmpApi.fromJson(Map<String, dynamic> json) {
    if (json['employees'] != null) {
      employees = new List<Employees>();
      json['employees'].forEach((v) {
        employees.add(new Employees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employees != null) {
      data['employees'] = this.employees.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employees {
  String iD;
  String name;
  String arraivtime;
  String livvingtime;
  String datee;
  String day;
  String month;
  String year;

  Employees(
      {this.iD,
      this.name,
      this.arraivtime,
      this.livvingtime,
      this.datee,
      this.day,
      this.month,
      this.year});

  Employees.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    arraivtime = json['arraivtime'];
    livvingtime = json['livvingtime'];
    datee = json['datee'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['name'] = this.name;
    data['arraivtime'] = this.arraivtime;
    data['livvingtime'] = this.livvingtime;
    data['datee'] = this.datee;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}
