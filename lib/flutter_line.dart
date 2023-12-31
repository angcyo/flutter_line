library flutter_line;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2023/12/15
///

class Line extends LeafRenderObjectWidget {
  /// 是否强制指定线条的大小
  final double? lineSize;

  /// 线条的厚度
  final double thickness;

  /// 线条的方向
  final Axis axis;

  /// 缩进
  final double? indent;
  final double? endIndent;

  /// 线条的颜色
  final Color color;

  /// 线条的外边距
  final EdgeInsets? margin;

  final StrokeCap lineStrokeCap;
  final StrokeJoin lineStrokeJoin;

  const Line({
    super.key,
    this.lineSize,
    this.thickness = 1,
    this.color = Colors.grey,
    this.axis = Axis.horizontal,
    this.indent,
    this.endIndent,
    this.margin,
    this.lineStrokeCap = StrokeCap.round,
    this.lineStrokeJoin = StrokeJoin.round,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => LineRender(this);

  @override
  void updateRenderObject(BuildContext context, LineRender renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.line = this;
  }
}

/// 线条渲染
class LineRender extends RenderBox {
  Line line;

  LineRender(this.line);

  @override
  void performLayout() {
    //super.performLayout();
    var constraints = this.constraints;

    double width = line.thickness;
    double height = line.thickness;
    if (line.axis == Axis.horizontal) {
      //横线
      if (line.lineSize == null) {
        //自适应线宽
        if (constraints.maxWidth == double.infinity) {
          var siblingSize = _findSiblingSize();
          width = siblingSize?.width ?? 0;
        } else {
          width = constraints.maxWidth;
        }
      } else {
        width = line.lineSize!;
      }
      width = width - (line.indent ?? 0) - (line.endIndent ?? 0);
    } else {
      //竖线
      if (line.lineSize == null) {
        //自适应线高
        if (constraints.maxHeight == double.infinity) {
          var siblingSize = _findSiblingSize();
          height = siblingSize?.height ?? 0;
        } else {
          height = constraints.maxHeight;
        }
      } else {
        height = line.lineSize!;
      }
      height = height - (line.indent ?? 0) - (line.endIndent ?? 0);
    }
    size = Size(width + (line.margin?.horizontal ?? 0),
        height + (line.margin?.vertical ?? 0));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    var size = this.size;
    var canvas = context.canvas;
    var paint = Paint()
      ..color = line.color
      ..strokeWidth = line.thickness
      ..strokeCap = line.lineStrokeCap
      ..strokeJoin = line.lineStrokeJoin
      ..style = PaintingStyle.stroke;
    var leftMargin = line.margin?.left ?? 0;
    var topMargin = line.margin?.top ?? 0;
    var rightMargin = line.margin?.right ?? 0;
    var bottomMargin = line.margin?.bottom ?? 0;
    if (line.axis == Axis.horizontal) {
      //var lineHeight = size.height - topMargin - bottomMargin;
      canvas.drawLine(
          offset.translate(line.indent ?? 0 + leftMargin + line.thickness / 2,
              topMargin + line.thickness / 2),
          offset.translate(
              size.width -
                  (line.endIndent ?? 0) -
                  rightMargin -
                  line.thickness / 2,
              topMargin + line.thickness / 2),
          paint);
    } else {
      //var lineWidth = size.width - leftMargin - rightMargin;
      canvas.drawLine(
          offset.translate(leftMargin + line.thickness / 2,
              line.indent ?? 0 + topMargin + line.thickness / 2),
          offset.translate(
              leftMargin + line.thickness / 2,
              size.height -
                  (line.endIndent ?? 0) -
                  bottomMargin -
                  line.thickness / 2),
          paint);
    }
  }

  /// 查找同级的小部件最大的大小
  Size? _findSiblingSize() {
    Size? result;
    if (parent != null) {
      for (var child in parent!.childrenList) {
        if (child == this) {
          continue;
        }
        var renderSize = child.renderSize ?? child.measureRenderSize();
        if (renderSize != null) {
          if (result == null) {
            result = renderSize;
          } else {
            if (renderSize.width * renderSize.height >
                result.width * result.height) {
              result = renderSize;
            }
          }
        }
      }
    }
    return result;
  }
}

extension RenderObjectMixinEx on RenderObject {
  /// 遍历当前渲染对象的所有子元素
  Iterable<RenderObject> get childrenList sync* {
    RenderObject? child;
    if (this is ContainerRenderObjectMixin) {
      child = (this as ContainerRenderObjectMixin).firstChild;
      while (child != null) {
        yield child;
        child = (this as ContainerRenderObjectMixin?)?.childAfter(child);
      }
    }
  }

  /// 尝试获取[RenderObject]的大小
  Size? get renderSize {
    if (this is RenderBox) {
      try {
        if ((this as RenderBox).hasSize) {
          return (this as RenderBox).size;
        }
      } catch (e) {
        debugPrint('$e');
        return null;
      }
    }
    return null;
  }

  /// 测量一下渲染对象的大小大小, 并尝试返回
  Size? measureRenderSize({
    Constraints constraints = const BoxConstraints(),
    bool parentUsesSize = false,
  }) {
    if (this is RenderBox && constraints is BoxConstraints) {
      return (this as RenderBox).getDryLayout(constraints);
    }
    //layout(constraints, parentUsesSize: parentUsesSize);
    return renderSize;
  }
}
