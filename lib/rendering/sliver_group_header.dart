// /// A sliver with a [RenderBox] child which never scrolls off the viewport in
// /// the positive scroll direction, and which first scrolls on at a full size but
// /// then shrinks as the viewport continues to scroll.
// ///
// /// This sliver avoids overlapping other earlier slivers where possible.
// abstract class RenderSliverPinnedPersistentHeader extends RenderSliverPersistentHeader {
//   /// Creates a sliver that shrinks when it hits the start of the viewport, then
//   /// stays pinned there.
//   RenderSliverPinnedPersistentHeader({
//     RenderBox child,
//   }) : super(child: child);

//   // Distance from our leading edge to the child's leading edge, in the axis
//   // direction. Negative if we're scrolled off the top.
//   double _childPosition;

//   @override
//   void performLayout() {
//     print(constraints);
//     final double maxExtent = this.maxExtent;
//     final bool overlapsContent = constraints.overlap > 0.0;
//     excludeFromSemanticsScrolling = overlapsContent || (constraints.scrollOffset > maxExtent - minExtent);
//     layoutChild(constraints.scrollOffset, maxExtent, overlapsContent: overlapsContent);
//     final double layoutExtent = (maxExtent - constraints.scrollOffset).clamp(0.0, constraints.remainingPaintExtent);
//     geometry = SliverGeometry(
//       scrollExtent: maxExtent,
//       paintOrigin: constraints.overlap,
//       paintExtent: math.min(childExtent, constraints.remainingPaintExtent),
//       layoutExtent: layoutExtent,
//       maxPaintExtent: maxExtent,
//       maxScrollObstructionExtent: minExtent,
//       cacheExtent: layoutExtent > 0.0 ? -constraints.cacheOrigin + layoutExtent : layoutExtent,
//       hasVisualOverflow: true, // Conservatively say we do have overflow to avoid complexity.
//     );
//     //_childPosition = math.min(0.0, layoutExtent - childExtent);
//   }

//   @override
//   double childMainAxisPosition(RenderBox child) {
//     assert(child == this.child);
// //    print(constraints.flexExtent);
//     if (constraints.flexExtent < 0.0 && constraints.flexExtent.abs() <= maxExtent) {
//       _childPosition = -(maxExtent + constraints.flexExtent);
//     } else {
//       _childPosition = 0.0; //_childPosition;
//     }
// //    print(_childPosition);
//     return _childPosition;
//   }
// }