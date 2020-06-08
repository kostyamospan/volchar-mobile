extension StringDateParsing on DateTime {
  String toFormatedDate() {
   return "${this.day < 10 ? '0' + this.day.toString() : this.day.toString()}." +
          "${this.month < 10 ? '0' + this.month.toString() : this.month.toString()}." +
          "${this.year}";
  }
}
