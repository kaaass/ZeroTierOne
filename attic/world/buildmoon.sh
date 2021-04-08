#!/bin/bash

c++ -std=c++11 -I../.. -I.. -g -o mkmoonworld ../../node/C25519.cpp ../../node/Salsa20.cpp ../../node/SHA512.cpp ../../node/Identity.cpp ../../node/Utils.cpp ../../node/InetAddress.cpp ../../osdep/OSUtils.cpp mkmoonworld.cpp -lm -static
