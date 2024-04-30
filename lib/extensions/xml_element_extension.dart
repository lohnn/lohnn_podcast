import 'package:xml/xml.dart';

extension XmlElementExtension on XmlElement {
  String? getElementContent(String name) => getElement(name)?.innerText;
}
