String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "패스워드는 공백이 들어갈 수 없습니다.";
  } else if (value.length > 12) {
    return "패스워드의 최대 길이는 12자 입니다.";
  } else if (value.length < 4) {
    return "패스워드의 최소 길이는 4자 입니다.";
  }
  return null;
}
