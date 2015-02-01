# Classifier

### Description
***
This is a simple application that leverages a Naive Bayesian Classifier to make gender predictions.

### Usage
***
To use the application, first ```git clone``` the repository to your local machine, and then cd to the application directory.

Once in the directory, install all the required gems and create your database:
```
$ bundle install; rake db:migrate;
```
To ensure all tests pass:
```
$ rake test
```
To verify all examples:
```
$ bundle exec rspec
```
Start the rails server:
```
$ rails s
```

And navigate to ```http://localhost:3000```.

To add a new person to train the classifier, click **Add New Person to Train Classifier**.

Once at least ONE male and ONE female are added, gender prediction is unlocked. Click **Get Gender Prediction** to input height, weight values (as integers) and get an instant prediction.
