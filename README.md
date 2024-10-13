# Event Scheduler App

## Tech stack

- OpenWeather [API](https://openweathermap.org/current)
- Ruby 3.3.5
- Ruby on Rails 7.2.1
- Stimulus
- Turbo
- Bootstrap 5.3.3
- Vue awesome paginate 1.1.46
- Postgresql 17
- Gems:
  - rubocop
  - devise
  - rspec
  - simple form
  - shoulda matchers
  - factory bot
  - jsonapi-serializer
  - will_paginate

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Configuration](#configuration)

## Overview
This is an event scheduling application built with **Ruby on Rails 7**. It allows users to create, manage, and view events, send email notifications, and retrieve weather information for events with specific locations. It includes a JSON-based API for easy integration with other platforms.

## Features
- **Event Management**: Users can create, edit, and delete events.
- **Participation**: Users can invite participants to events.
- **Weather Integration**: Real-time weather information for events with a specified location.
- **Email Notifications**: Users receive notifications for new events via email (using Mailgun).
- **API**: JSON API for event data and participant management.
- **Pagination**: Events are paginated using `will_paginate`.

## Installation

1. **Clone the Repository**:
    ```bash
    git clone git@github.com:SegundoRP/event_planner.git
    cd event_planner
    ```

2. **Install Dependencies**:
    ```bash
    bundle install
    ```

3. **Set Up Database**:
    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Set Up API Keys and passwords**:
    For weather data, set up your `OpenWeatherMap` API key in your environment variables:
    ```bash
    OPENWEATHER_API_KEY
    ```

    For sending emails, set up your `Mailgun` info in your environment variables:
    ```bash
    MAILGUN_PASSWORD
    MAILGUN_DOMAIN
    MAILGUN_USERNAME
    ```

5. **Run seeds**
   If you want to have users, run the seeds:
   ```bash
   rails db:seed
   ```

7. **Run the Application**:
    ```bash
    rails server
    ```

## Usage

### Creating Events
Users can create events through the web interface. Events must include a title, description, category, start and end time, and location (optional, if weather info is required).

### Event Participation
- The organizer can invite participants when creating the event.
- Use the search and filter functions to manage participants and events.

### Weather Information
- If an event has a location, weather data will be fetched from the **OpenWeatherMap** API and stored in the event record.
- This information is updated when the event is created or modified.

## API Endpoints

### List of Events
- **URL**: `/api/v1/events`
- **Method**: `GET`
- **Params**:
  - `participant_id`: Filters events by participant.
  - `page`: For pagination.

  ```bash
  curl -H "Content-Type: application/json" -X GET 'http://localhost:3000/api/v1/events?page=:page' | jq
  ```

  ```bash
  curl -H "Content-Type: application/json" -X GET 'http://localhost:3000/api/v1/events?participant_id=:participant_id' | jq
  ```

  |Parameter|Type|Description|
  |-----|----|----|
  |`page`|`integer`|Optional - number of page|
  |`participant_id`|`integer`|Optional - ID of the participant of the event|

### Show Event Details
- **URL**: `/api/v1/events/:id`
- **Method**: `GET`
- **Example**:

```bash
curl -H "Content-Type: application/json" -X GET 'http://localhost:3000/api/v1/events/:id'
```

|Parameter|Type|Description|
|-----|----|----|
|`id`|`integer`|Required - ID of the event|

## Testing

Run the test suite using RSpec:

```bash
bundle exec rspec
```

If you want, you can use spring for reduced the time of the tests:

```bash
spring start
```

## Configuration

### Environment Variables

- `OPENWEATHER_API_KEY`: API key for fetching weather data.
- `MAILGUN_DOMAIN`: SMTP domain for Mailgun email delivery.
- `MAILGUN_USERNAME`: SMTP username for Mailgun email delivery.
- `MAILGUN_PASSWORD`: SMTP password for Mailgun email delivery.
