#!/bin/bash

rm -f ./server/tmp/pids/server.pid

# setup client
 cd ./client && yarn install
# setup
cd server && bundle && ./bin/rails db:create && ./bin/rails db:migrate && ./bin/rails db:seed && ./bin/rails s -p 3000
