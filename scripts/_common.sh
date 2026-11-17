#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Mutable state (node identity, store, freenet.ini) lives under $data_dir,
# not $install_dir, because ynh_setup_source wipes the latter on upgrades.
