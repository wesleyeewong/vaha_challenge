# VAHA coding assignment

### Requirements

* Ruby
* SQlite

### Setup

Run `bin/setup`

### Seed

Run `bin/rails db:seed`

### Server

By default when starting the server via `bin/rails s` it is accessible only from localhost.

### Testing

    bin/rspec
    
### API Documentation

Swagger doc available at `localhost:3000/api-docs`


# Design and Implementation details

App is ran on SQLite for simplicity of setup, no features implemented are database dependent.

I did not use any special gems besides JWT, and bcrypt for simple authorizations.

For authorization, you can easily generate the token in console given a trainer/trainee id, instead of going through the login endpoints:
```ruby
payload = { "trainer_id or trainee_id" => 123 }
token = JWT.encode(payload, nil, "none")
```


## Design Patterns

I find that the code is more easily digestable when models, and controllers are not bloated with logic. And that's the reason why I used this two patterns. While not used here, typically I would also abstract out specific complex logics, into a service class.

### Interactors

The interactor class comes between controllers and models. I used it to validate data coming outside from the app, and validate model integrity, before saving it to db.

### Presenters

While presenters are typically used for view logics, formatting data etc, and I did use it for such cases here and there, I'm mainly using it to serialize the resources. To me I find it much easier to follow looking at the hashes, as they very much resemble JSON, than using jbuilder gem.

## API

I went with a heavy resource based RESTful API design, as I am looking at this app purely on an API level.
I would design the API differently if the clients are known, for example: mobile, web, or the vaha products.
Ultimately it's on a case by case basis, depending on circumstances.

Only specific users can see, create, and modify cetain resources:
* `Trainers` can
  * create, modify, and delete`Workout`
  * assign workout to `Trainees`
  * list all `Trainees`
* `Trainees` can
  * select a `Trainer`
  * see all `Assignments`

Full list of routes can be seen with this command `bin/rails routes`, or check out the swagger doc!

## Data model

All models are annotated with annotate gem. You'll be able to easily see what columns and data types present for each model.

### Users: Trainers, Trainees, PesonalClass

I've chosen to split the users by `Trainers`, and `Trainees` to distinguish between the different users of the app.
In the long run, I think this will be more scalable and cleaner as both models can grow independently from each other.
Implementing features specifically for `Trainers` or `Trainees` can happen easily as well.

I named the join table for `Trainers` and `Trainees`: `PersonalClass`

`Trainers` have many `Trainees`

`Trainees` have one `Trainer`

### Workouts, Exercises, and Workout Exercises

`Workouts`, and `Exercises` model are pretty simple.

`Trainers` have many `Workouts`

`Workouts` have many `Exercises`, through `WorkoutExercises`.

Essentially `WorkoutExercises` is a join table for `Workouts` and `Exercises`. It'll contain the details of the workout, duration of the exercises, types of exercises, etc.

### Assignments

`Assignments` is implemented with polymorphic capabilities, and using rails 6.1 `delegated_type` feature.

Decision to implement it this way is so that we can assign other types of assignments other than `Workouts`. For example, let's say we want to implement meditation features, or reading assignments, videos etc. We can model it with a similar interface, `Meditations`, `Articles`, `Videos`, etc, and assign them to users.

Conveniently it's all tracked under one table, and can be queried easily.

```ruby
# will have all assignables, workouts, meditations, etc
trainee.assignments

# get specific ones
trainee.assignments.workouts
trainee.assignments.meditations
```

The downside with this is that the specific assignables are located in different tables so if we need the details of the assignments, we'd need a separate query for that. Something like:

```ruby
ids = trainee.assignments.workouts.pluck(:id)
workouts = Workout.where(id: ids)
```

But we are only adding an additional query for each assignable types.

