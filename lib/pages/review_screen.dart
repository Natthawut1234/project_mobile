// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class ReviewScreen extends StatefulWidget {
//   const ReviewScreen({super.key});

//   @override
//   State<ReviewScreen> createState() => _ReviewScreenState();
// }

// class _ReviewScreenState extends State<ReviewScreen> {
//   double _rating = 0.0; // ค่าเริ่มต้นของคะแนน

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("รีวิวร้านค้า")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("ให้คะแนนร้านค้า", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             RatingBar.builder(
//               initialRating: _rating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//               itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _rating = rating;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_rating > 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("คุณให้คะแนน $_rating ดาว ขอบคุณสำหรับรีวิว!")),
//                   );
//                 }
//               },
//               child: const Text("ส่งรีวิว"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
