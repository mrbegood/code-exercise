# GetLoan

# Documentation for Running the Application with Docker Compose

## Installing Docker and Docker Compose

1. Go to the official Docker website: https://docs.docker.com/get-docker/
2. Follow the instructions for your operating system (Windows, macOS, Linux).
3. After installing Docker, Docker Compose is usually installed automatically. To check, run:
  ```
  docker-compose --version
  ```

## Running the Application

1. Open a terminal and navigate to your project directory.
2. Run the following command to start the application:
  ```
  docker-compose up
  ```
  To run in detached mode, use:
  ```
  docker-compose up -d
  ```
3. To stop the application, run:
  ```
  docker-compose down
  ```

4. To open the application in your browser, navigate to http://localhost:4000

## Notes

- To update containers, use:
  ```
  docker-compose pull
  docker-compose up --build
  ```