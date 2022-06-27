class Utils {

  static String isEmpty(String input) {
    if (input.isNotEmpty) return input;
    return '';
  }

  static String getGender(String input) {
    if (input.isNotEmpty) {
     if(input == 'M') {
       return 'Male';
     } else if(input == 'F') {
       return 'Female';
     } else if(input == 'O') {
       return 'Other';
     }
    }
    return '';
  }
}