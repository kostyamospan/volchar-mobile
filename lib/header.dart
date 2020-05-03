import 'package:deplom/widgets/publication.dart';
import 'package:flutter/material.dart';
import 'package:deplom/models/publication.dart';
import 'widgets/publication_full_modal.dart';

final RegExp loginReg =
    new RegExp(r'^[a-z0-9_][A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*$');
final RegExp pasReg =
    new RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$');
final RegExp emailReg = new RegExp(
    r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()\.,;\s@\"]+\.{0,1})+[^<>()\.,;:\s@\"]{2,})$');

const String passError = 'Must be longer then 8 and less then 32 char. long';
const String reqError = "The field is requared";

const String domenName = "56483eaa.ngrok.io";
const String fullDomen = "https://$domenName";
const String apiURL = "$fullDomen/api";

double displayWidth(BuildContext context) => MediaQuery.of(context).size.width;

void navigateToRoute(BuildContext context, String route) {
  Navigator.pushNamedAndRemoveUntil(
      context, route, (Route<dynamic> route) => false);
}
toModal(BuildContext context, Publication data, PublicationCardState card) {
  Navigator.of(context).push(PublicationFullInfo(data,card));
}
