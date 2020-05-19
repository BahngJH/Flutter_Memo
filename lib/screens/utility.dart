
class Utility {
  String timeCheckAmPm (String editTime) {
    int parseTime = int.parse(editTime.substring(11,13));
    String amPm = parseTime > 12 ? "오후 ":"오전 ";
    parseTime = parseTime > 12 ? parseTime -12 : parseTime;
    editTime = editTime.substring(0, 16).replaceAll("-", "/");

    return editTime.substring(0,11)
        + "\n" + amPm + parseTime.toString() +":"+ editTime.substring(14);
  }
}