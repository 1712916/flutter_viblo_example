void main() {
  List<int> numbers = [1, 2, 3, 4, 5];

  print('first number: ${numbers.first}');

  numbers.first = 0;

  print('first number: ${numbers.first}');

  List<int> reAssignNumbers = [...numbers];

  print('first reassign number: ${reAssignNumbers.first}');

  numbers.first = -1;

  reAssignNumbers.first = -2;

  print('first number: ${numbers.first}');

  print('first reassign number: ${reAssignNumbers.first}');
}
