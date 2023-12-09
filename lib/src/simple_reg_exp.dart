//      Regex Fragment                | Meaning
//      ------------------------------------------------------------
//      []                            | Matches any character...
//      a-ZA-Z                        | ... a letter,
//            0-9                     | ... a number,
//               _                    | ... or and underscore,
//                {3,16}              | Min length 3, max length 16
//                      $             | Match every character

///
class SimpleRegExp {
  ///
  static final email = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  ///
  static final phone = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');

  ///
  static final lowercase = RegExp('^.*[a-z].*');

  ///
  static final uppercase = RegExp('^.*[A-Z].*');

  ///
  static final number = RegExp('^.*[0-9].*');

  ///
  static final specialCharacters = RegExp(r'^.*[!@#$%^&*(),.?":{}|<>].*');
}
