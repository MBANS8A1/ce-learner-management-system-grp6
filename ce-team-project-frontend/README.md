# Northcoders Learners Frontend

This is the frontend for adding/editing/deleting learners from our system.

## Running the app

### Running with Docker

The application can be run with Docker by firstly building the images

```
docker build -t learners-frontend .
```

And then running the container

```
docker run -p 80:80 learners-frontend
```

Then you should be able to visit:

[http://localhost:80](http://localhost:80)

### Running locally

The instructions assume you have Node and NPM installed

Instructions have been tested against Node version `v18.12.1`

To run the application use the command

```
npm install
```

followed by:

```
npm start
```

## Running the tests

Yeah erm....we didn't create any just yet 🙈
