// /// To be used in conjunction with the changes proposed on the Piinks-sliverFlex
// /// branch.

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';

// import '../rendering/sliver_group.dart';

// /// A sliver that lays out multiple sliver children along the main axis of the viewport.
// class SliverFlex extends MultiChildRenderObjectWidget {
//   /// Creates a sliver that lays out it children along the main axis of the viewport
//   SliverFlex({
//     Key key,
//     @required List<Widget> slivers,
//     bool pushPinnedHeaders = true,
//     double overrideGroupMaxExtent = 0.0,
//   }) : _pushPinnedHeaders = pushPinnedHeaders,
//        _overrideGroupMaxExtent = overrideGroupMaxExtent,
//        super(children: slivers, key: key);

//   final bool _pushPinnedHeaders;
//   final double _overrideGroupMaxExtent;

//   @override
//   RenderSliverFlex createRenderObject(BuildContext context) {
//     return RenderSliverFlex(
//       key: key,
//       pushPinnedHeaders: _pushPinnedHeaders,
//       overrideGroupMaxExtent: _overrideGroupMaxExtent,
//     );
//   }

//   @override
//   void updateRenderObject(BuildContext context, RenderSliverFlex renderObject) {
//     renderObject.pushPinnedHeaders = _pushPinnedHeaders;
//     renderObject.overrideGroupMaxExtent = _overrideGroupMaxExtent;
//   }
// }

// class SliverGroup extends SliverFlex {
//   SliverGroup({
//     Key key,
//     List<Widget> slivers = const <Widget>[],
//     bool pushPinnedHeaders = true,
//     double overrideGroupMaxExtent = 0.0,
//   }) : super(
//     key: key, 
//     slivers: slivers, 
//     pushPinnedHeaders: pushPinnedHeaders,
//     overrideGroupMaxExtent: overrideGroupMaxExtent,
//   );
// }

// class SliverExpanded extends ParentDataWidget<SliverFlex> {
//   const SliverExpanded({
//     this.flex = 1,
//     Widget child,
//   }) : super(child: child);

//   /// The flex factor to use for this child
//   final int flex;

//   @override
//   void applyParentData(RenderObject renderObject) {
//     assert(renderObject.parentData is SliverPhysicalParentData);
//     final SliverPhysicalContainerParentData parentData = renderObject.parentData;
//     bool needsLayout = false;

//     if (parentData.flex != flex) {
//       parentData.flex = flex;
//       needsLayout = true;
//     }

//     if (needsLayout) {
//       final AbstractNode targetParent = renderObject.parent;
//       if (targetParent is RenderObject)
//         targetParent.markNeedsLayout();
//     }
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(IntProperty('flex', flex));
//   }
// }

// class SliverSpacer extends StatelessWidget {
//   const SliverSpacer({
//     Key key, 
//     this.flex = 1
//   }) : assert(flex != null),
//       assert(flex > 0),
//       super(key: key);
      
//   final int flex;

//   @override
//   Widget build(BuildContext context) {
//     return SliverExpanded(
//       flex: flex,
//       child: SliverToBoxAdapter(child:SizedBox.shrink()),
//     );
//   }
// }