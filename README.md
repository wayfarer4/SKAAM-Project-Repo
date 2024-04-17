# OccupEYE

OccupEYE is our university space management app, consisting of three Docker containers:

1. MySQL 8 container
2. Python Flask container for REST API implementation
3. Local AppSmith Server

This app facilitates various functionalities:

- Students can book spaces for study or events.
- Teachers can manage classes and request assistance.
- Building managers can oversee spaces and bookings.

## Setup and Container Launch

**Prerequisites:** Docker Desktop installation required.

1. Clone this repository.
2. Create a file named `db_root_password.txt` in the `secrets/` folder and add the MySQL root password.
3. Create a file named `db_password.txt` in the `secrets/` folder and add the password for the non-root user named "webapp."
4. Open a terminal or command prompt and navigate to the folder with the `docker-compose.yml` file.
5. Build the images with `docker compose build`.
6. Start the containers with `docker compose up`. To run in detached mode, use `docker compose up -d`.

# Project Members

- Amulya Jayam
- Aniket Chaudhry
- Karina Mehta
- Sarayu Pininti
- Melissa Rejuan
