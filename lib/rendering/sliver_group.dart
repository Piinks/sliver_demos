// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// A sliver that lays out its sliver children along the main axis of the view port.
class RenderSliverFlex extends RenderSliver with ContainerRenderObjectMixin<RenderSliver, SliverPhysicalContainerParentData> {
  /// Creates a render object that lays out it children along the main axis of the viewport
  RenderSliverFlex({
    this.key,
    bool pushPinnedHeaders = true,
    double manualExtent = 0.0,
    List<RenderSliver> children,
  }) : _pushPinnedHeaders = pushPinnedHeaders,
       _manualExtent = manualExtent {
    addAll(children);
  }
  
  /// Doc
  final Key key;

  /// Doc
  bool get pushPinnedHeaders => _pushPinnedHeaders; 
  bool _pushPinnedHeaders;
  set pushPinnedHeaders(bool newValue) {
    assert(newValue != null);
    if (newValue == _pushPinnedHeaders)
      return;
    _pushPinnedHeaders = newValue;
    markNeedsLayout();
  }

  /// Doc
  double get manualExtent => _manualExtent; 
  double _manualExtent;
  set manualExtent(double newValue) {
    assert(newValue >= 0.0);
    if (newValue == _manualExtent)
      return;
    _manualExtent = newValue;
    markNeedsLayout();
  }


  /// Doc all of these
  double _spacePerFlex;
  double _originalScrollExtent;
  double _flexedScrollExtent = 0.0;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalContainerParentData)
      child.parentData = SliverPhysicalContainerParentData();
  }

  int _getFlex(RenderSliver child) {
    final SliverPhysicalContainerParentData childParentData = child.parentData;
    return childParentData.flex ?? 0;
  }

  @override
  void performLayout() {
    assert(constraints != null);
    geometry = SliverGeometry.zero;
    double groupLayoutExtent = 0;
    double groupMaxPaintOffset = constraints.overlap;
    double groupPrecedingScrollExtent = constraints.precedingScrollExtent;
    double groupScrollOffset = constraints.scrollOffset;
    int groupTotalFlex = 0;

    RenderSliver child = firstChild;
    while (child != null) {
      final double childScrollOffset = math.max(0, groupScrollOffset - groupLayoutExtent);
      int childFlexFactor = _getFlex(child);
      groupTotalFlex += childFlexFactor;

      // FirstChild is SliverPersistentHeader
      if (child == firstChild && child is RenderSliverPersistentHeader) {
        print('GOtcha!');
      }

      child.layout(
        constraints.copyWith(
          scrollOffset: childScrollOffset,
          precedingScrollExtent: groupPrecedingScrollExtent,
          overlap: groupMaxPaintOffset - groupLayoutExtent,
          remainingPaintExtent: math.max(0, constraints.remainingPaintExtent - groupLayoutExtent),
          remainingCacheExtent: math.max(0, constraints.remainingCacheExtent - groupLayoutExtent),
          cacheOrigin: math.max(-childScrollOffset, constraints.cacheOrigin),
          flexExtent: childFlexFactor > 0 && _spacePerFlex != null ? childFlexFactor * _spacePerFlex : 0.0,
        ),
        parentUsesSize: true
      );

      final SliverPhysicalContainerParentData childParentData = child.parentData;
      final SliverGeometry childGeometry = child.geometry;
      
      geometry = SliverGeometry(
        scrollExtent: geometry.scrollExtent + childGeometry.scrollExtent,
        paintExtent: math.max(geometry.paintExtent, groupLayoutExtent + childGeometry.paintOrigin + childGeometry.paintExtent),
        layoutExtent: geometry.layoutExtent + childGeometry.layoutExtent,
        maxPaintExtent: geometry.maxPaintExtent + childGeometry.maxPaintExtent,
        maxScrollObstructionExtent: geometry.maxScrollObstructionExtent + childGeometry.maxScrollObstructionExtent,
        hitTestExtent: geometry.hitTestExtent + childGeometry.hitTestExtent,
        visible: geometry.visible || childGeometry.visible,
        hasVisualOverflow: geometry.hasVisualOverflow || childGeometry.hasVisualOverflow,
        scrollOffsetCorrection: childGeometry.scrollOffsetCorrection,
        cacheExtent: geometry.cacheExtent + childGeometry.cacheExtent,
      );

      // Scroll offset will be adjusted, and layout rerun.
      if (geometry.scrollOffsetCorrection != null) {
        return;
      }

      final double effectiveLayoutOffset = groupLayoutExtent + childGeometry.paintOrigin;

      childParentData.paintOffset = _computeAbsolutePaintOffset(child, effectiveLayoutOffset);

      groupMaxPaintOffset = math.max(effectiveLayoutOffset + childGeometry.paintExtent, groupMaxPaintOffset);

      groupLayoutExtent = groupLayoutExtent + math.min(constraints.remainingPaintExtent, childGeometry.layoutExtent);
      groupPrecedingScrollExtent += childGeometry.scrollExtent;
      groupScrollOffset -= childGeometry.scrollExtent;

      child = childParentData.nextSibling;
    }

    // Flex Factoring
    double scrollOffsetForFlex = constraints.scrollOffset;
    if (_originalScrollExtent == null) {
      _originalScrollExtent = geometry.layoutExtent + constraints.precedingScrollExtent;
      if (_originalScrollExtent < constraints.scrollOffset) {
        _originalScrollExtent += geometry.scrollExtent;
        scrollOffsetForFlex = 0.0;
      }
    }
    
    if(_originalScrollExtent < constraints.viewportMainAxisExtent && groupTotalFlex > 0 && _spacePerFlex == null) {
      _spacePerFlex = (constraints.viewportMainAxisExtent - (_originalScrollExtent + scrollOffsetForFlex) )/groupTotalFlex;
      performLayout();
    }

    // Persistent Headers
    double headerPushExtent = -(geometry.scrollExtent - constraints.scrollOffset) + constraints.overlap;
    print('$key Push: $headerPushExtent');
    double groupOffset = 0.0;
    if (headerPushExtent < 0.0 && headerPushExtent.abs() <= firstChild.geometry.scrollExtent) {
      groupOffset = -(firstChild.geometry.scrollExtent + headerPushExtent);
    } else if (headerPushExtent > 0.0) {
      groupOffset = -firstChild.geometry.scrollExtent;
    }
    print('$key groupOffset: $groupOffset');
    if (pushPinnedHeaders && firstChild is RenderSliverPinnedPersistentHeader && groupOffset != 0.0) {
      firstChild.layout(firstChild.constraints.copyWith(flexExtent: groupOffset));
      geometry = SliverGeometry(
        scrollExtent: geometry.scrollExtent,//_flexedScrollExtent,
        paintExtent: geometry.paintExtent + groupOffset,
        layoutExtent: math.min(geometry.layoutExtent, geometry.paintExtent + groupOffset),
        maxPaintExtent: geometry.maxPaintExtent,
        maxScrollObstructionExtent: geometry.maxScrollObstructionExtent ,
        hitTestExtent: geometry.hitTestExtent,
        visible: geometry.visible,
        hasVisualOverflow: geometry.hasVisualOverflow,
        scrollOffsetCorrection: geometry.scrollOffsetCorrection,
        cacheExtent: geometry.cacheExtent,
      );
    }
    _flexedScrollExtent = geometry.scrollExtent;
  }

  Offset _computeAbsolutePaintOffset(RenderSliver child, double layoutOffset) {
    assert(child != null);
    assert(child.geometry != null);
    switch (applyGrowthDirectionToAxisDirection(constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
      case AxisDirection.down:
        return Offset(0.0, layoutOffset);
      case AxisDirection.right:
      case AxisDirection.left:
        return Offset(layoutOffset, 0.0);
    }
    return null;
  }

  // @override
  // double childMainAxisPosition(RenderObject child) {
  //   assert(child.parent == this);
  //   final SliverPhysicalContainerParentData childParentData = child.parentData;
  //   // TODO: implement childMainAxisPosition
  // }

  // @override
  // double childScrollOffset(RenderObject child) {
  //   assert(child.parent == this);
  //   print()
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final RenderSliver child in _childrenInPaintOrder) {
      final SliverPhysicalContainerParentData childParentData = child.parentData;
      if (child.geometry.visible) {
        context.paintChild(child, offset + childParentData.paintOffset);
      }
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {@required double mainAxisPosition, @required double crossAxisPosition}) {
    assert(mainAxisPosition != null);
    assert(crossAxisPosition != null);
    for (final RenderSliver child in _childrenInPaintOrder) {
      if (child.geometry.visible &&
          child.hitTest(
            result,
            mainAxisPosition: _computeChildMainAxisPosition(child, mainAxisPosition),
            crossAxisPosition: crossAxisPosition,
          )
      ) {
        return true;
      }
    }
    return false;
  }

  double _computeChildMainAxisPosition(RenderSliver child, double parentMainAxisPosition) {
    assert(child != null);
    assert(child.constraints != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    switch (applyGrowthDirectionToAxisDirection(child.constraints.axisDirection, child.constraints.growthDirection)) {
      case AxisDirection.down:
        return parentMainAxisPosition - childParentData.paintOffset.dy;
      case AxisDirection.right:
        return parentMainAxisPosition - childParentData.paintOffset.dx;
      case AxisDirection.up:
        return child.geometry.paintExtent - (parentMainAxisPosition - childParentData.paintOffset.dy);
      case AxisDirection.left:
        return child.geometry.paintExtent - (parentMainAxisPosition - childParentData.paintOffset.dx);
    }
    return 0.0;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    childParentData.applyPaintTransform(transform);
  }

  Iterable<RenderSliver> get _childrenInPaintOrder sync* {
    RenderSliver child = lastChild;
    while (child != null) {
      yield child;
      child = childBefore(child);
    }
  }
}