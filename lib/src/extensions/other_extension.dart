import 'package:flutter/material.dart'
    show EdgeInsets, EdgeInsetsDirectional, EdgeInsetsGeometry;

///
extension SimpleUtilsEdgeInsetsGeometryX on EdgeInsetsGeometry? {
  ///
  double get left => switch (this) {
        EdgeInsets(:final double left) => left,
        EdgeInsetsDirectional(:final double start) => start,
        _ => 0.0,
      };

  ///
  double get top => switch (this) {
        EdgeInsets(:final double top) => top,
        EdgeInsetsDirectional(:final double top) => top,
        _ => 0.0,
      };

  ///
  double get right => switch (this) {
        EdgeInsets(:final double right) => right,
        EdgeInsetsDirectional(:final double end) => end,
        _ => 0.0,
      };

  ///
  double get bottom => switch (this) {
        EdgeInsets(:final double bottom) => bottom,
        EdgeInsetsDirectional(:final double bottom) => bottom,
        _ => 0.0,
      };
}
