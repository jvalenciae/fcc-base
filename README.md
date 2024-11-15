# URL Shortening API

This is a URL shortening API built using Ruby on Rails, designed to allow users to shorten long URLs and track their usage. The project uses Docker for containerization and includes a number of endpoints to manage short URLs, including creation, redirection, and tracking of the most visited URLs.

## Technologies Used

- **Ruby 3.1.2**: The backend framework used to develop the API.
- **Ruby on Rails 7**: The backend framework used to develop the API.
- **PostgreSQL 14**: The relational database used to store URL data.
- **Redis**: Used for caching and tracking the number of visits to shortened URLs.
- **Docker**: Containerization platform for creating a reproducible development and production environment.
- **RSpec**: Testing framework for writing unit tests.

## Features

- **Shorten URLs**: Convert long URLs into short and easy-to-share links.
- **Top 100 URLs**: Retrieve a list of the most visited shortened URLs.
- **URL Redirection**: Redirect users to the original URL based on the shortened URL.
- **Visit Tracking**: Track the number of times a shortened URL has been visited.

## Getting Started

### Prerequisites

Make sure you have the following tools installed:

- Docker
- Docker Compose

### Running the Application with Docker Compose

```bash
docker compose up
```

## Available Endpoints

### `POST /api/v1/short_urls`
- **Create a new shortened URL**.
- **Request body**: 
  ```json
  { "url": "http://example.com" }
  ```

### `GET /api/v1/short_urls/top100`
- **Get the top 100 most visited shortened URLs**.


### `GET /:shortened_url`
- **Redirect to the original URL based on the shortened URL**.
- **Response**: A 301 redirect to the original URL.

---

## Running Tests

To run the tests with Docker Compose:

```bash
docker compose exec backend bundle exec rspec
```

---

## Algorithm for URL Shortening

The URL shortening algorithm involves the following steps:

1. **Generate a Shortened Code**:
   - When a user submits a long URL, the system generates a unique shortened code.
   - The shortened code is a string that is generated using a base-62 encoding (lowercase letters, uppercase letters, and numbers).
   
   The process of generating a short URL involves:
   - **Converting the ID**: Taking the ShortUrl generated ID and converting it to base62.
   - **Mapping the base62 ID**: Next we want to map that base62 number to out base62 string.
   - **Example**: ID: 123456789 (base10) -> iwaUH base(62) -> short_url: /iwaUH

2. **Generating Shortened URLs**:
   - The shortened URL is constructed by combining a base URL (e.g., `http://localhost:3000/`) with the shortened code (e.g., `abc123`).
   - Example: `http://localhost:3000/abc123`
