import 'dart:math';

class Randoms {
  static int generateRand() {
    Random random = Random();
    int randomNumber = random.nextInt(999999) + 111111;
    return randomNumber;
  }
}
