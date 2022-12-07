#!/bin/bash

cd /$PROJNAME
symfony server:start

exec bash -c "while true;do sleep 10;done"

