# frozen_string_literal: true

ApplicationRecord.transaction do
  yoga = Trainer.create!(
    first_name: "Nama", last_name: "Ste", email: "nama.ste@vaha.com", expertise: "yoga", password: "secret"
  )
  strength = Trainer.create!(
    first_name: "Dooya", last_name: "Lift", email: "dooya.lift@vaha.com", expertise: "strength", password: "secret"
  )
  fitness = Trainer.create!(
    first_name: "Sweat", last_name: "Alot", email: "sweat.alot@vaha.com", expertise: "fitness", password: "secret"
  )

  wesley = Trainee.create!(
    first_name: "Wesley", last_name: "Wong", email: "wesley.wong@train.com", password: "secret"
  )
  kevin = Trainee.create!(
    first_name: "Kevin", last_name: "Wong", email: "kevin.wong@train.com", password: "secret"
  )
  ron = Trainee.create!(
    first_name: "Ron", last_name: "Weaseley", email: "ron.weaseley@hogwarts.edu", password: "secret"
  )
  harry = Trainee.create!(
    first_name: "Harry", last_name: "Potter", email: "harry.potter@hogwards.edu", password: "secret"
  )
  severus = Trainee.create!(
    first_name: "Severus", last_name: "Snape", email: "severus.snape@hogwarts.edu", password: "secret"
  )
  dwayne = Trainee.create!(
    first_name: "Dwayne", last_name: "Johnson", email: "dwayne.johnson@therock.man", password: "secret"
  )
  peter = Trainee.create!(
    first_name: "Peter", last_name: "Parker", email: "peter.parker@nyu.edu", password: "secret"
  )

  PersonalClass.create!(trainer: yoga, trainee: wesley)
  PersonalClass.create!(trainer: yoga, trainee: kevin)
  PersonalClass.create!(trainer: strength, trainee: ron)
  PersonalClass.create!(trainer: strength, trainee: harry)
  PersonalClass.create!(trainer: fitness, trainee: severus)
  PersonalClass.create!(trainer: fitness, trainee: dwayne)

  exercises = Exercise.create!(
    [
      { slug: "pushups" },
      { slug: "pullups" },
      { slug: "planks" },
      { slug: "squats" },
      { slug: "step-ups" },
      { slug: "overhead-squats" },
      { slug: "squat-holds" }
    ]
  )

  Workout.create!(slug: "yoga-workout", trainer: yoga, state: "draft")
  Workout.create!(slug: "strength-workout", trainer: strength, state: "draft")
  Workout.create!(slug: "fitness-workout", trainer: fitness, state: "draft")
  yoga_workout = Workout.create!(slug: "yoga-workout-2", trainer: yoga, state: "published")
  strength_workout = Workout.create!(slug: "strength-workout", trainer: strength, state: "published")
  fitness_workout = Workout.create!(slug: "fitness-workout", trainer: fitness, state: "published")

  WorkoutExercise.create!(
    [
      { workout: yoga_workout, exercise: exercises[2], duration: 30, order: 1 }, # 30s planks
      { workout: yoga_workout, exercise: exercises[6], duration: 30, order: 2 }, # 30s squat holds
      { workout: yoga_workout, exercise: exercises[2], duration: 45, order: 3 }, # 45s planks
      { workout: yoga_workout, exercise: exercises[6], duration: 45, order: 4 }, # 45s squat holds

      { workout: strength_workout, exercise: exercises[0], duration: 30, order: 1 }, # 30s pushups
      { workout: strength_workout, exercise: exercises[1], duration: 30, order: 2 }, # 30s pullups
      { workout: strength_workout, exercise: exercises[3], duration: 45, order: 3 }, # 45s squats
      { workout: strength_workout, exercise: exercises[5], duration: 45, order: 4 }, # 45s overhead squats

      { workout: fitness_workout, exercise: exercises[3], duration: 30, order: 1 }, # 30s squats
      { workout: fitness_workout, exercise: exercises[4], duration: 30, order: 2 }, # 30s step ups
      { workout: fitness_workout, exercise: exercises[3], duration: 45, order: 3 }, # 45s squats
      { workout: fitness_workout, exercise: exercises[4], duration: 45, order: 4 }, # 45s step ups
    ]
  )
end
