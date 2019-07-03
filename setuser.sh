#!/bin/bash

# Note that we don't actually care if someone runs this as root.
# That is their business. We are just trying to sort out their
# file permissions. 
# This will only work if they run the build as told to in the README.
# Obviously they can run as root by specifying that the command
# bash is run instead. But the aim is not to stop them having root,
# merely to stop them being confused by being root.
shopt -s extglob
groupadd -g $(stat -c '%g' !(MathAltNotes)) mathaltuser
useradd -r -u $(stat -c '%u' !(MathAltNotes)) -g mathaltuser mathaltuser
chown -R mathaltuser:mathaltuser /home/mathaltuser/
runuser -p -s /bin/bash mathaltuser
