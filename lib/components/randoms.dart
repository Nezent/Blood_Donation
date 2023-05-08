import 'dart:math';

class Randoms {
  static int generateRand() {
    Random random = Random();
    int randomNumber = 111111 + random.nextInt(900000 - 111111);
    return randomNumber;
  }
}
