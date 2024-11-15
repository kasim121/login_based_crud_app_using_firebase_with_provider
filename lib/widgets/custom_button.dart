import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Size? minimumSize; // Optional parameter for custom button size.

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.minimumSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 9, 35, 113)),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
        minimumSize: MaterialStateProperty.all(
          minimumSize ?? Size(MediaQuery.of(context).size.width / 1.6, 50),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;

//   const CustomButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ButtonStyle(
//         backgroundColor:
//             MaterialStateProperty.all(const Color.fromARGB(255, 9, 35, 113)),
//         textStyle: MaterialStateProperty.all(
//           const TextStyle(color: Colors.white),
//         ),
//         minimumSize: MaterialStateProperty.all(
//           Size(MediaQuery.of(context).size.width / 1.6, 50),
//         ),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//       ),
//     );
//   }
// }
