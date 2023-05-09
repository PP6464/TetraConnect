RegExp password = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#$&*~]).{10,}$");
RegExp whitespaces = RegExp(r"\s");
RegExp nameQueryParameter = RegExp(r"name=.+?(?=&)");