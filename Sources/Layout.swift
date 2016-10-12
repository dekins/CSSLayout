//
//  CSSLayout.swift
//  CSSLayout
//
//  Created by Matias Cudich on 10/11/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import CoreGraphics
import CSSLayout

public struct Edges: Equatable {
  let left: Float
  let right: Float
  let bottom: Float
  let top: Float

  public init(left: Float = 0, right: Float = 0, bottom: Float = 0, top: Float = 0) {
    self.left = left
    self.right = right
    self.bottom = bottom
    self.top = top
  }

  public init(_ ref: CSSNodeRef, getEdge: (CSSNodeRef, CSSEdge) -> Float) {
    self.left = getEdge(ref, CSSEdgeLeft)
    self.right = getEdge(ref, CSSEdgeRight)
    self.top = getEdge(ref, CSSEdgeTop)
    self.bottom = getEdge(ref, CSSEdgeBottom)
  }

  public func apply(_ ref: CSSNodeRef, _ applyEdge: (CSSNodeRef, CSSEdge, Float) -> Void) {
    applyEdge(ref, CSSEdgeLeft, left)
    applyEdge(ref, CSSEdgeRight, right)
    applyEdge(ref, CSSEdgeTop, top)
    applyEdge(ref, CSSEdgeBottom, bottom)
  }
}

public func ==(lhs: Edges, rhs: Edges) -> Bool {
  return lhs.left == rhs.left && lhs.right == rhs.right && lhs.top == rhs.top && lhs.bottom == rhs.bottom
}

extension CSSSize: Equatable {}

public func ==(lhs: CSSSize, rhs: CSSSize) -> Bool {
  return lhs.height == rhs.height && lhs.width == rhs.width
}

public struct Layout {
  public let frame: CGRect
  public let children: [Layout]

  public init(nodeRef: CSSNodeRef) {
    let x = CGFloat(CSSNodeLayoutGetLeft(nodeRef))
    let y = CGFloat(CSSNodeLayoutGetTop(nodeRef))
    let width = CGFloat(CSSNodeLayoutGetWidth(nodeRef))
    let height = CGFloat(CSSNodeLayoutGetHeight(nodeRef))

    let children: [Layout] = (0..<CSSNodeChildCount(nodeRef)).map {
      let childRef = CSSNodeGetChild(nodeRef, UInt32($0))!
      return Layout(nodeRef: childRef)
    }

    self.frame = CGRect(x: x, y: y, width: width, height: height)
    self.children = children
  }
}

public class LayoutNode: Hashable {
  public var direction: CSSDirection {
    set {
      if newValue != direction {
        CSSNodeStyleSetDirection(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetDirection(nodeRef)
    }
  }

  public var flexDirection: CSSFlexDirection {
    set {
      if newValue != flexDirection {
        CSSNodeStyleSetFlexDirection(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetFlexDirection(nodeRef)
    }
  }

  public var justifyContent: CSSJustify {
    set {
      if newValue != justifyContent {
        CSSNodeStyleSetJustifyContent(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetJustifyContent(nodeRef)
    }
  }

  public var alignContent: CSSAlign {
    set {
      if newValue != alignContent {
        CSSNodeStyleSetAlignContent(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetAlignContent(nodeRef)
    }
  }

  public var alignItems: CSSAlign {
    set {
      if newValue != alignItems {
        CSSNodeStyleSetAlignItems(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetAlignItems(nodeRef)
    }
  }

  public var alignSelf: CSSAlign {
    set {
      if newValue != alignSelf {
        CSSNodeStyleSetAlignSelf(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetAlignSelf(nodeRef)
    }
  }

  public var positionType: CSSPositionType {
    set {
      if newValue != positionType {
        CSSNodeStyleSetPositionType(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetPositionType(nodeRef)
    }
  }

  public var flexWrap: CSSWrapType {
    set {
      if newValue != flexWrap {
        CSSNodeStyleSetFlexWrap(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetFlexWrap(nodeRef)
    }
  }

  public var overflow: CSSOverflow {
    set {
      if newValue != overflow {
        CSSNodeStyleSetOverflow(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetOverflow(nodeRef)
    }
  }

  public var flexGrow: Float {
    set {
      if newValue != flexGrow {
        CSSNodeStyleSetFlexGrow(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetFlexGrow(nodeRef)
    }
  }

  public var flexShrink: Float {
    set {
      if newValue != flexShrink {
        CSSNodeStyleSetFlexShrink(nodeRef, newValue)
      }
    }
    get {
      return CSSNodeStyleGetFlexShrink(nodeRef)
    }
  }

  public var margin: Edges {
    set {
      if newValue != margin {
        newValue.apply(nodeRef, CSSNodeStyleSetMargin)
      }
    }
    get {
      return Edges(nodeRef, getEdge: CSSNodeStyleGetMargin)
    }
  }

  public var position: Edges {
    set {
      if newValue != position {
        newValue.apply(nodeRef, CSSNodeStyleSetPosition)
      }
    }
    get {
      return Edges(nodeRef, getEdge: CSSNodeStyleGetPosition)
    }
  }

  public var padding: Edges {
    set {
      if newValue != padding {
        newValue.apply(nodeRef, CSSNodeStyleSetPadding)
      }
    }
    get {
      return Edges(nodeRef, getEdge: CSSNodeStyleGetPadding)
    }
  }

  public var size: CSSSize {
    set {
      if newValue.width != size.width {
        CSSNodeStyleSetWidth(nodeRef, newValue.width)
      }
      if newValue.height != size.height {
        CSSNodeStyleSetHeight(nodeRef, newValue.height)
      }
    }
    get {
      let width = CSSNodeStyleGetWidth(nodeRef)
      let height = CSSNodeStyleGetHeight(nodeRef)
      return CSSSize(width: width, height: height)
    }
  }

  public var minSize: CSSSize {
    set {
      if newValue.width != minSize.width {
        CSSNodeStyleSetMinWidth(nodeRef, newValue.width)
      }
      if newValue.height != minSize.height {
        CSSNodeStyleSetMinHeight(nodeRef, newValue.height)
      }
    }
    get {
      let width = CSSNodeStyleGetMinWidth(nodeRef)
      let height = CSSNodeStyleGetMinHeight(nodeRef)
      return CSSSize(width: width, height: height)
    }
  }

  public var maxSize: CSSSize {
    set {
      if newValue.width != maxSize.width {
        CSSNodeStyleSetMaxWidth(nodeRef, newValue.width)
      }
      if newValue.height != maxSize.height {
        CSSNodeStyleSetMaxHeight(nodeRef, newValue.height)
      }
    }
    get {
      let width = CSSNodeStyleGetMaxWidth(nodeRef)
      let height = CSSNodeStyleGetMaxHeight(nodeRef)
      return CSSSize(width: width, height: height)
    }
  }

  public var measure: CSSMeasureFunc? {
    set {
      CSSNodeSetMeasureFunc(nodeRef, newValue)
    }
    get {
      return CSSNodeGetMeasureFunc(nodeRef)
    }
  }

  public var context: UnsafeMutableRawPointer? {
    set {
      CSSNodeSetContext(nodeRef, newValue)
    }
    get {
      return CSSNodeGetContext(nodeRef)
    }
  }

  public var children: [LayoutNode] {
    set {
      var oldValue = children
      var remainingChildren = Set(oldValue)
      for (index, child) in newValue.enumerated() {
        if index < children.count && child != oldValue[index] {
          remainingChildren.remove(oldValue[index])
          removeChild(child: oldValue[index])
          insertChild(child: child, at: index)
        } else if index >= oldValue.count {
          insertChild(child: child, at: index)
        } else {
          remainingChildren.remove(oldValue[index])
        }
      }
      for child in remainingChildren {
        removeChild(child: child)
      }
    }
    get {
      let childCount = CSSNodeChildCount(nodeRef)
      return (0..<childCount).map {
        return LayoutNode(nodeRef: CSSNodeGetChild(nodeRef, $0))
      }
    }
  }

  public var hashValue: Int {
    return nodeRef.hashValue
  }

  public let nodeRef: CSSNodeRef

  public init() {
    self.nodeRef = CSSNodeNew()
  }

  public init(nodeRef: CSSNodeRef) {
    self.nodeRef = nodeRef
  }

  public init(direction: CSSDirection = CSSDirectionLTR, flexDirection: CSSFlexDirection = CSSFlexDirectionColumn, justifyContent: CSSJustify = CSSJustifyFlexStart, alignContent: CSSAlign = CSSAlignAuto, alignItems: CSSAlign = CSSAlignStretch, alignSelf: CSSAlign = CSSAlignStretch, positionType: CSSPositionType = CSSPositionTypeRelative, flexWrap: CSSWrapType = CSSWrapTypeNoWrap, overflow: CSSOverflow = CSSOverflowVisible, flexGrow: Float = 0, flexShrink: Float = 0, margin: Edges = Edges(), position: Edges = Edges(), padding: Edges = Edges(), size: CSSSize = CSSSize(width: Float.nan, height: Float.nan), minSize: CSSSize = CSSSize(width: 0, height: 0), maxSize: CSSSize = CSSSize(width: Float.greatestFiniteMagnitude, height: Float.greatestFiniteMagnitude), measure: CSSMeasureFunc? = nil, context: UnsafeMutableRawPointer? = nil, children: [LayoutNode] = []) {
    self.nodeRef = CSSNodeNew()

    self.direction = direction
    self.flexDirection = flexDirection
    self.justifyContent = justifyContent
    self.alignContent = alignContent
    self.alignItems = alignItems
    self.alignSelf = alignSelf
    self.positionType = positionType
    self.flexWrap = flexWrap
    self.overflow = overflow
    self.flexGrow = flexGrow
    self.flexShrink = flexShrink
    self.margin = margin
    self.position = position
    self.padding = padding
    self.size = size
    self.minSize = minSize
    self.maxSize = maxSize
    self.measure = measure
    self.context = context
    self.children = children
  }

  public func insertChild(child: LayoutNode, at index: Int) {
    CSSNodeInsertChild(nodeRef, child.nodeRef, UInt32(index))
  }

  public func removeChild(child: LayoutNode) {
    CSSNodeRemoveChild(nodeRef, child.nodeRef)
  }

  public func markDirty() {
    CSSNodeMarkDirty(nodeRef)
  }

  public func layout(availableWidth: Float = Float.nan, availableHeight: Float = Float.nan) -> Layout {
    CSSNodeCalculateLayout(nodeRef, availableWidth, availableHeight, CSSDirectionLTR)
    return Layout(nodeRef: nodeRef)
  }

  public func debugPrint() {
    let options = CSSPrintOptionsLayout.rawValue | CSSPrintOptionsStyle.rawValue | CSSPrintOptionsChildren.rawValue
    CSSNodePrint(nodeRef, CSSPrintOptions(options))
  }
}

public func ==(lhs: LayoutNode, rhs: LayoutNode) -> Bool {
  return lhs.nodeRef == rhs.nodeRef
}