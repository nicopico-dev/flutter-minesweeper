#!/bin/bash
grep 'version: ' pubspec.yaml | sed 's/version: //'