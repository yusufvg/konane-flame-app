import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// App level theme info.

const themeColor = Colors.green;

/// Game level visual info.

// Colors.

const gameBackgroundColor = Colors.white;
const blackPieceColor = Colors.black;
const blackPieceBorderColor = Color.fromARGB(255, 48, 48, 48);
const whitePieceColor = Colors.white;
const whitePieceBorderColor = Color.fromARGB(255, 193, 193, 193);
const spaceColor = Colors.grey;
const boardColor = Color.fromARGB(255, 133, 94, 66);

// Sizes.

const double pieceRadius = 60.0;
final Vector2 pieceSize = Vector2.all(pieceRadius * 2);
const pieceCircle = Radius.circular(pieceRadius);
const double pieceBorderWidth = 7.0;

const double spaceRadius = 75.0;
const double spaceGap = 25.0;
const double spacePadding = spaceRadius - pieceRadius;
final Vector2 spaceSize = Vector2.all(spaceRadius * 2);
const spaceCircle = Radius.circular(spaceRadius);

const double boardPadding = 35.0;
const double boardRadius = 25.0;

const double gamePadding = 80.0;
