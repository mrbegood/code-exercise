#!/bin/bash -e

# setup database
/app/bin/migrate

# run application server
/app/bin/server