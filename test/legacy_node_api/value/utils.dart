// Copyright 2018 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:js_util';

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:sass/src/node/function.dart';

import '../api.dart';
import '../utils.dart';

/// Parses [source] by way of a function call.
T parseValue<T>(String source) {
  late T value;
  renderSync(RenderOptions(
      data: "a {b: foo(($source))}",
      functions: jsify({
        r"foo($value)": allowInterop(expectAsync1((T value_) {
          value = value_;
          return sass.types.Null.NULL;
        }))
      })));
  return value;
}

final _jsInstanceOf =
    JSFunction("value", "type", "return value instanceof type;");

/// A matcher that matches values that are JS `instanceof` [type].
Matcher isJSInstanceOf(Object type) => predicate(
    (value) => _jsInstanceOf.call(value, type) as bool,
    "to be an instance of $type");
