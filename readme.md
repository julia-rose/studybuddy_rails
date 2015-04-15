# Homework, W05D03

You turned one of your command line apps into a Sinatra app this weekend, right?

Now, turn it into a Rails app!

Then, add authentication!

For example: If you're working on the Finance app, it should accommodate multiple Users, each of whom has a unique password. Access should be denied to anyone entering an incorrect password.

#### Requirements:

- The User should be able to log out.

- Passwords should be encrypted and stored securely in the database.

- Any time the User sends an HTTP request, it should be detected whether or not the User has been authenticated. If they have not, they should be redirected to a login page.

- Once a User has logged in, they shouldn't be asked to log in again until they quit their web browser or log out.

**Hint:** You **MAY** want to create a User model, if you don't already have one.

#### Submitting:

Put your project in a new Github repository under your Github account, and then send the link to us as an issue on the `ga-students/addbass-hw` repository.

**Please include your comfort and completeness ratings, as usual!**

So your Github issue would look something like this:

```
Comfort: 3.14159/5
Completeness: Over9000/5
Notes: I had trouble doing something, of which I'm going to include a specific note here.

https://github.com/robertakarobin/battleship_in_rails
```

#### Bonus:
Deploy it with Heroku! Share it with your friends and family, and include the link to your Heroku app AND your Github repo!

**Holy crap! You made an actual web app!** Take a moment to appreciate that you've accomplished something pretty freaking cool, and that every other thing you do in web development will simply be a variation on what you just created.

#### Bonus bonus:
Create two different User "roles": Standard and Admin. For example, for the Finance app, a Standard User might be able to delete their transactions, whereas an Admin User might be able to delete transactions for *any* User.

#### Bonus bonus bonus:
Log password attempts in your database. If a User enters an incorrect password 5 times in a row, they're "locked out" and can only be granted access by an Admin User. 
