String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "이메일을 입력해주세요.";
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(value)) {
    return "유효하지 않은 이메일 형식입니다.";
  }
  return null;
}
