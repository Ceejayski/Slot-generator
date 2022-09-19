# README

Rails/React Application

## Setup

### Prerequisites

- Ruby 3.1.2
- Postgresql
- Node 16.13.0

### Setup Guides

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) - [Postgresql](https://www.postgresql.org/download/) - [Node](https://nodejs.org/en/download/) - [Yarn](https://classic.yarnpkg.com/en/docs/install/#mac-stable) - [Rails](https://guides.rubyonrails.org/getting_started.html) - [React](https://reactjs.org/docs/getting-started.html)

- Clone the repository
- cd into the project directory and then  into the server directory, then create a .env file and add the following variables
```bash
DB_USER=your_db_username
DB_PASS=your_db_password
SLOT_INTERVAL= desired slot interval in minutes
```
- then back into the root then run ./startup.sh to setup server and start the server process
- cd then run ```yarn start``` to start the client process


## Server Commands
  - run `rails server` to start the server
  - run `rails db:create` to create the database
  - run `rails db:migrate` to migrate the database
  - run `rails db:seed` to seed the database
  - run `bundle exec rspec` to run the tests

## Client Commands
  - run `yarn start` to start the client
  - run `yarn build` to build the client


## API Endpoints

### BookedSlots

- GET /booked_slots/query
- POST /booked_slots

#### GET /booked_slots/query

- Query params
  - day: Date string format (YYYY-MM-DD)| default: today
  - duration: Integer | default: 30
- Response
  - 200: Success
    - body: {available_slots: Array, error: Boolean}

#### POST /booked_slots

- Request body
  - slot: DateTime string format (YYYY-MM-DD HH:MM:SS)
  - duration: Integer
  - name: String
- Response
  - 201: Created
    - body: {slot: DateTime, error: Boolean}
  - 422: Unprocessable Entity
    - body: {errors: Array, error: Boolean}


