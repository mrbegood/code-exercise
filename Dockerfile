FROM elixir:1.18

# Set the working directory inside the container
WORKDIR /app

# Install Hex and Rebar, which are essential for Elixir dependency management
RUN mix local.hex --force && \
    mix local.rebar --force

RUN apt-get update && apt-get install -y inotify-tools \
    chromium && \
    rm -rf /var/lib/apt/lists/*

# Copy the mix.exs and mix.lock files to install dependencies
COPY mix.exs mix.lock ./

# Fetch and compile Elixir dependencies
RUN mix deps.get && \
    mix deps.compile

# Copy the remaining application code
COPY . .

# Compile the Phoenix application
RUN mix compile

EXPOSE 4000

ENTRYPOINT ["/app/docker-entrypoint.sh"]