Rounded rectangle with smoother transition between straight and curved parts used in macOS and iOS.

Below is a cupertino rounded rectangle (squircle) in blue color overlayed on top of a regular rounded rectangle with the same corner radius (100) in red:

<img src="https://github.com/widgetforge/cupertino_rrect/assets/96958/65246aa4-3633-4eff-9e02-411a1d617e19" width="200">

Path algorithm is based on [this article](https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles).

## Usage

### Creating "Cupertino" rounded rectangle path:

```dart
  import 'package:cupertino_rrect/cupertino_rrect.dart';

  final path = Path();
  path.addCupertinoRRect(rrect);
```

### Using `CupertinoRectangleBorder`:

```dart
  import 'package:cupertino_rrect/cupertino_rrect.dart';

  Container(
    decoration: ShapeDecoration(
      shape: CupertinoRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  ),
```

## Additional information

Example app is located in `example` directory. Also available [online](https://widgetbakery.github.io/cupertino_rrect/).
