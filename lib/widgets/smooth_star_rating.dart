// import 'package:flutter/material.dart';

// typedef void RatingChangeCallback(double rating);

// class SmoothStarRating extends StatelessWidget {
//   final int starCount;
//   final double rating;
//   final RatingChangeCallback onRatingChanged;
//   final Color color;
//   final Color borderColor;
//   final double size;
//   final bool allowHalfRating;
//   final double spacing;

//   SmoothStarRating({
//     this.starCount = 5,
//     this.rating = 0.0,
//     required this.onRatingChanged, // Making it required
//     required this.color, // Making it required
//     required this.borderColor, // Making it required
//     required this.size, // Making it required
//     this.spacing = 0.0,
//     this.allowHalfRating = true,
//   });

//   Widget buildStar(BuildContext context, int index) {
//     Icon icon;
//     if (index >= rating) {
//       icon = Icon(
//         Icons.star_border,
//         color: borderColor ?? Theme.of(context).primaryColor,
//         size: size ?? 25.0,
//       );
//     } else if (index > rating - (allowHalfRating ? 0.5 : 1.0) && index < rating) {
//       icon = Icon(
//         Icons.star_half,
//         color: color ?? Theme.of(context).primaryColor,
//         size: size ?? 25.0,
//       );
//     } else {
//       icon = Icon(
//         Icons.star,
//         color: color ?? Theme.of(context).primaryColor,
//         size: size ?? 25.0,
//       );
//     }

//     return GestureDetector(
//       onTap: () {
//         if (onRatingChanged != null) onRatingChanged(index + 1.0);
//       },
//       onHorizontalDragUpdate: (dragDetails) {
//         RenderBox? box = context.findRenderObject() as RenderBox?;
//         if (box != null) {
//           var _pos = box.globalToLocal(dragDetails.globalPosition);
//           var i = _pos.dx / size;
//           var newRating = allowHalfRating ? i : i.round().toDouble();
//           if (newRating > starCount) {
//             newRating = starCount.toDouble();
//           }
//           if (newRating < 0) {
//             newRating = 0.0;
//           }
//           if (onRatingChanged != null) onRatingChanged(newRating);
//         }
//       },
//       child: icon,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Wrap(
//         alignment: WrapAlignment.start,
//         spacing: spacing,
//         children: List.generate(starCount, (index) => buildStar(context, index)),
//       ),
//     );
//   }
// }
