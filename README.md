This repository hosts the example for the Serverpod Ground Training course. 

Each commit correlates to a lesson in the course - if you want to speed through you can just inspect one commit at a time to see whats going on.

## Running this example:

1) Get a (free) gemini api key from https://aistudio.google.com/app/apikey add add it to `magic_recipe_server/config/passwords.yaml` 
2) Build the Flutter web app to be hosted on the server:
```bash
./scripts/build_flutter_web
```
3) Run the docker containers in `magic_recipe_server` and then start the server
```bash
cd magic_recipe_server && docker compose up -d 
dart run bin/main.dart --apply-migrations
```
4) Go to [localhost:8082](http://localhost:8082) create a new account, copy the verification token from the terminal where you are running your server. If you want to checkout the admin dashboard, use a '*@serverpod.dev' adress. 

Here is a quick run down of what you can expect in each commit.

## Inital setup
The state after running `serverpod create`
## Add RecipesEndpoint
Creating your first `Endpoint`
## Call RecipesEndpoint from app
Basics for working with the generated `Client`
## Add Recipe model
Serverpod can automatically serialize and deserialize models you specify in a `*.spy.yaml` file.
## Update app to use recipe model
Refactor from String to using the `Recipe` model
## Create table for Recipe
A model can easily be converted to a table - now you can store the data in your database and send the same object to your client.
## Store Recipe in database
Writing to the database.
## Read recipes from database
Reading from the database.
## Update app to show recipes from database
Adding a history view to the app.
## Add integration tests for generateRecipe
Use Serverpods integration test suite which works against a real database
## sqltools
Using sqltools in VSCode to connect to your database
## Add soft delete for recipes
Marking recipes as deleted and filtering the queries
## Add auth module to server
Wiring up Serverpods auth module in the server
## Add auth module to app
Creating a login with email flow in the app
## Add ownership to recipe
Attaching a user id to the generated recipes
## Add admin scope on user created
Using the on created hook to do work with a user - here we add a "scope".
## Add admin endpoint with access scope
Restricting access to an endpoint to certain scopes.
## Add admin dashboard to app
Creating a basic admin dashboard
## Add future call to remove deleted recipes
A look at future calls to clean up the database
## Add tests for future call
Using integration tests to test our future call
## Add scheduler for future call
(Re)scheduling our future call to be run in an interval
## Add caching to generateRecipe
Don't call expensive APIs if we already have the answer.
## Add tests to check caching
Update the tests and check that the cached value is used.
## Add image upload to server
Implement endpoints to upload files to the server and retreive them again
## Update tests after image upload
Update the tests.
## Add image upload to app
Implement the Flutter side of the file upload.
## Add streaming generate recipe endpoint
Refactor the generateRecipe method to return a stream
## Listen to stream in app
Update the Flutter app to react to the stream
## Host Flutter Web
Host the Flutter app as a web app on the builtin webserver


## Maintaining this repository

Using interactive rebase (I recommend https://git-fork.com/) you can rename commits, add new ones and rearrange the order.

The commits are meant to be checkpoints for the course, so rewriting history as the course is updated is what we have to do.

Consider creating a branch with the "old" state if you want to keep it for reference. 
Force push over main - there should never be any merge commits or commits that are not directly linked to a lesson.