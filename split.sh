#!/bin/sh
split --bytes=5M "$1" "$1.part"
