#!/bin/bash -e

# setup database
mix ecto.setup

# run application server
mix phx.server