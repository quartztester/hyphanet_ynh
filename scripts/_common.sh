#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Mutable state lives under $data_dir; the node rewrites its own freenet.ini
FN_CONFIG="$data_dir/freenet.ini"
