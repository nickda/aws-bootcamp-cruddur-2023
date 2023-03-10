# Week 3 — Decentralized Authentication

## Cognito
### Creating a user pool
*Only changes to defaults are reflected in the screenshots*
<img width="803" alt="CleanShot 2023-03-10 at 11 10 20@2x" src="https://user-images.githubusercontent.com/10653195/224288693-db2891f6-c811-4e16-9f25-4a414d8e2447.png">
<img width="795" alt="CleanShot 2023-03-10 at 11 11 58@2x" src="https://user-images.githubusercontent.com/10653195/224289070-fc28a372-375e-4a02-811b-09a1e0cc7b83.png">
<img width="794" alt="CleanShot 2023-03-10 at 11 12 44@2x" src="https://user-images.githubusercontent.com/10653195/224289254-60b822e2-6a9b-458d-ba61-97e6dd1e2519.png">
<img width="813" alt="CleanShot 2023-03-10 at 11 13 19@2x" src="https://user-images.githubusercontent.com/10653195/224289396-f2c02997-e186-49c0-b2fe-3ad47d2050b8.png">
<img width="798" alt="CleanShot 2023-03-10 at 11 14 13@2x" src="https://user-images.githubusercontent.com/10653195/224289591-ba44c8cf-f086-46ea-854f-72d20942ace4.png">
<img width="796" alt="CleanShot 2023-03-10 at 11 14 26@2x" src="https://user-images.githubusercontent.com/10653195/224289654-39e0d120-35e6-4c91-a3eb-311e38a58196.png">

#### Summary
![CleanShot 2023-03-10 at 12 36 58@2x](https://user-images.githubusercontent.com/10653195/224306360-3e251366-884e-493a-9498-0e67ac85d5da.png)


## AWS Amplify
AWS Amplify is a development platform that offers a variety of tools and services for building scalable and secure cloud-powered applications. It provides a set of client libraries and SDKs that can be used to connect frontend applications to backend services and enable real-time data synchronization. Amplify supports popular frontend frameworks and provides integrations with other AWS services such as AWS AppSync, AWS Lambda, and Amazon S3. It also includes features such as user authentication, authorization, and analytics, that help developers build secure and scalable applications quickly and easily. 

It's a prerequisite to incorporating Cognito integration into our code.

### Installing AWS Amplify Library
```sh
cd frontend-react-js
npm i aws-amplify --save
```
#### Verification
![CleanShot 2023-03-10 at 09 14 30](https://user-images.githubusercontent.com/10653195/224260594-57841066-66bd-4eaf-b3d5-8a812bad56c0.png)

### Configuring Amplify
[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/7fcf57ee9c99b7da62e9648c4ab68808c2097f6e)

```js
import { Amplify } from 'aws-amplify';

Amplify.configure({
  "AWS_PROJECT_REGION": process.env.REACT_AWS_PROJECT_REGION,
  "aws_cognito_identity_pool_id": process.env.REACT_APP_AWS_COGNITO_IDENTITY_POOL_ID,
  "aws_cognito_region": process.env.REACT_APP_AWS_COGNITO_REGION,
  "aws_user_pools_id": process.env.REACT_APP_AWS_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_CLIENT_ID,
  "oauth": {},
  Auth: {
    // We are not using an Identity Pool
    // identityPoolId: process.env.REACT_APP_IDENTITY_POOL_ID, // REQUIRED - Amazon Cognito Identity Pool ID
    region: process.env.REACT_AWS_PROJECT_REGION,           // REQUIRED - Amazon Cognito Region
    userPoolId: process.env.REACT_APP_AWS_USER_POOLS_ID,         // OPTIONAL - Amazon Cognito User Pool ID
    userPoolWebClientId: process.env.REACT_APP_AWS_USER_POOLS_WEB_CLIENT_ID,   // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
  }
});
```

#### Adding Variables to docker-compose.yml

```yml
      REACT_AWS_PROJECT_REGION: "${AWS_DEFAULT_REGION}"
      REACT_APP_AWS_COGNITO_REGION: "us-east-1"
      REACT_APP_AWS_USER_POOLS_ID: "us-east-1_EsWorbtLo"
      REACT_APP_CLIENT_ID: "3fmaa9b3bpgcce2cdkr93bqp9u"
```
##### REACT_APP_AWS_USER_POOLS_ID
<img width="1063" alt="CleanShot 2023-03-10 at 09 23 58@2x" src="https://user-images.githubusercontent.com/10653195/224262899-8630781f-e03f-41d3-affc-83e0a03d5401.png">

##### REACT_APP_CLIENT_ID
<img width="1078" alt="CleanShot 2023-03-10 at 09 24 41@2x" src="https://user-images.githubusercontent.com/10653195/224263027-2212065f-017a-4f03-b3d5-c410f8a503a9.png">

### Configuring conditional display of components based on whether user is logged in or logged out

[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/24253393aeb0bcc7c18231bdf651a0242fd7bc41)

In `HomeFeedPage.js`:
```js
//Add this to the import block
import { Auth } from 'aws-amplify';

//replace existing checkAuth function with the following function
const checkAuth = async () => {
  Auth.currentAuthenticatedUser({
    // Optional, By default is false. 
    // If set to true, this call will send a 
    // request to Cognito to get the latest user data
    bypassCache: false 
  })
  .then((user) => {
    console.log('user',user);
    return Auth.currentAuthenticatedUser()
  }).then((cognito_user) => {
      setUser({
        display_name: cognito_user.attributes.name,
        handle: cognito_user.attributes.preferred_username
      })
  })
  .catch((err) => console.log(err));
};
```

This function uses the Auth module provided by the AWS Amplify library to check if the user is authenticated. The currentAuthenticatedUser() method is used to check if the user is authenticated or not.

The bypassCache parameter is optional and set to false by default. When set to true, the function sends a request to Cognito to get the latest user data.

The function then returns the current authenticated user and sets the user state with the user's name and preferred_username attributes.


In `ProfileInfo.js`:
```
//Add this to the import block
import { Auth } from 'aws-amplify';

//replace existing signOut function with the following function
  const signOut = async () => {
    try {
        await Auth.signOut({ global: true });
        window.location.href = "/"
    } catch (error) {
        console.log('error signing out: ', error);
    }
  }
```
The function calls the signOut() method, which accepts an optional configuration object. The global property is set to true, which means the user is signed out of all devices and browser tabs where they were previously signed in.

After successfully signing out, the function redirects the user to the homepage by setting the window.location.href property to the root URL "/". If there is an error, it is logged to the console.

### Verifying and Troubleshooting
Problem statement: After `docker-compose up` the page on port 3000 is blank.

#### Troubleshooting
1. Attach to front-end container shell and check the environment variables ✅
2. Check the variables in App.js
  - Found the incorrect variable and fixed it [commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/04096b4eb4315586511669ca3a382cc676c818a8)


### Sign-in Page

[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/c3e86a2eab64f25666e7a58dd8b717b3a126f750)


in `SigninPage.js`:

```js
import { Auth } from 'aws-amplify';

const onsubmit = async (event) => {
  setErrors('')
  event.preventDefault();
  Auth.signIn(email, password)
  .then(user => {
    localStorage.setItem("access_token", user.signInUserSession.accessToken.jwtToken)
    window.location.href = "/"
  })
  .catch(error => {
    if (error.code == 'UserNotConfirmedException') {
      window.location.href = "/confirm"
    }
    setErrors(error.message)
  });
  return false
}
```

The function first clears any previous errors by calling the setErrors() function. Then, it prevents the default form submission behavior using the event.preventDefault() method.

The function then calls the Auth.signIn() method to sign in the user. If the sign-in is successful, the function stores the user's accessToken.jwtToken in the browser's local storage and redirects the user to the homepage.

If there is an error, the function checks if the error code is UserNotConfirmedException. If so, the function redirects the user to the email confirmation page. Otherwise, the function calls the setErrors() function to set the error message in the state variable.

Finally, the function returns false to prevent the form from being submitted.


### Creating a user in Cognito
<img width="815" alt="CleanShot 2023-03-10 at 10 23 24@2x" src="https://user-images.githubusercontent.com/10653195/224277034-00d7f39d-db22-4cba-8fcb-92a77e522846.png">

Manually verifying the user
```sh
aws cognito-idp admin-set-user-password --user-pool-id "us-east-1_EsWorbtLo" --username nickda --password REDACTED --permanent
```

### Adding Console Logging for the Sign-In page
[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/280c1cc516c1abb58a564e357e4e2fd0ce1cd0ec)

### Adding Optional Attributes in Cognito
![CleanShot 2023-03-10 at 10 47 29@2x](https://user-images.githubusercontent.com/10653195/224283395-41e1adbc-797f-484f-9432-5d967895ebef.png)

#### Verification
![CleanShot 2023-03-10 at 10 46 56](https://user-images.githubusercontent.com/10653195/224283310-89599a54-a513-4a29-b0ce-ae9ee284ef36.png)

### Sign up Page
[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/ba88da05c758255331bf35fc650c44fcfb29315e)
`SignupPage.js`

```js
const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('');
  console.log('username', username);
  console.log('email', email);
  console.log('name', name);
  try {
    const { user } = await Auth.signUp({
      username: email,
      password: password,
      attributes: {
        name: name,
        email: email,
        preferred_username: username,
      },
      autoSignIn: {
        enabled: true,
      },
    });
    console.log(user);
    window.location.href = `/confirm?email=${email}`;
  } catch (error) {
    console.log(error);
    setErrors(error.message);
  }
  return false;
};
```
It uses the Auth module provided by the AWS Amplify library to sign up the user using their email, password, name, and username.

The function first prevents the default form submission behavior using the event.preventDefault() method. Then, it clears any previous errors by calling the setErrors() function.

The function then logs the values of username, email, and name to the console.

The function then calls the Auth.signUp() method to sign up the user. The function passes the user's email, password, name, and username values, along with an autoSignIn object that enables automatic sign-in after the user is confirmed.

If the sign-up is successful, the function logs the user object to the console and redirects the user to the email confirmation page with the email query parameter.

If there is an error, the function logs the error message to the console and sets the error message in the state variable.

Finally, the function returns false to prevent the form from being submitted.

### Confirmation Page

[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/ba88da05c758255331bf35fc650c44fcfb29315e)

`ConfirmationPage.js`

```js
const resend_code = async (event) => {
  setErrors('');
  try {
    await Auth.resendSignUp(email);
    console.log('Code resent successfully');
    setCodeSent(true);
  } catch (err) {
    console.log(err);
    if (err.message === 'Username cannot be empty') {
      setErrors('You need to provide an email in order to send Resend Activation Code.');
    } else if (err.message === 'Username/client id combination not found.') {
      setErrors('Email is invalid or cannot be found.');
    }
  }
};
```
It uses the Auth module provided by the AWS Amplify library to resend the activation code to the user's email.

The function first clears any previous errors by calling the setErrors() function. Then, it calls the Auth.resendSignUp() method to resend the activation code to the user's email. If the code is successfully sent, the function logs a message to the console and sets the codeSent state to true.

If there is an error, the function checks the error message to see if it matches specific cases. If the error message is 'Username cannot be empty', the function sets the error message to indicate that the user needs to provide an email to resend the activation code. If the error message is 'Username/client id combination not found.', the function sets the error message to indicate that the email is invalid or cannot be found.

Finally, the function returns false to prevent the form from being submitted.


```js
const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('');
  try {
    await Auth.confirmSignUp(email, code);
    window.location.href = '/';
  } catch (error) {
    setErrors(error.message);
  }
  return false;
};
```   
The function uses the Auth module provided by the AWS Amplify library to confirm the user's sign-up process using their email and code.

The function first prevents the default form submission behavior using the event.preventDefault() method. Then, it clears any previous errors by calling the setErrors() function.

The function then calls the Auth.confirmSignUp() method to confirm the user's sign-up using their email and code. If the confirmation is successful, the function redirects the user to the homepage by setting the window.location.href property to the root URL "/".

If there is an error, the function calls the setErrors() function to set the error message in the state variable.

Finally, the function returns false to prevent the form from being submitted.

### Password Recovery Page

[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/2258f288c83ce379e2ba681c2cf145e6c8ef8de5)

`RecoverPage.js`
```js
const onsubmit_send_code = async (event) => {
  event.preventDefault();
  setErrors('');
  Auth.forgotPassword(username)
    .then((data) => setFormState('confirm_code'))
    .catch((err) => setErrors(err.message));
  return false;
};
```
It uses the Auth module provided by the AWS Amplify library to initiate the forgot password flow for the user.

The function first prevents the default form submission behavior using the event.preventDefault() method. Then, it clears any previous errors by calling the setErrors() function.

The function then calls the Auth.forgotPassword() method to initiate the forgot password flow for the user. The function passes the user's username value as a parameter.

If the forgot password request is successful, the function sets the form state to 'confirm_code' using the setFormState() function.

If there is an error, the function sets the error message in the state variable using the setErrors() function.

Finally, the function returns false to prevent the form from being submitted.



```js
const onsubmit_confirm_code = async (event) => {
  event.preventDefault();
  setErrors('');
  if (password === passwordAgain) {
    Auth.forgotPasswordSubmit(username, code, password)
      .then((data) => setFormState('success'))
      .catch((err) => setErrors(err.message));
  } else {
    setErrors('Passwords do not match');
  }
  return false;
};
```  
It uses the Auth module provided by the AWS Amplify library to submit the forgot password confirmation for the user.

The function first prevents the default form submission behavior using the event.preventDefault() method. Then, it clears any previous errors by calling the setErrors() function.

The function then checks if the two password values match. If they match, the function calls the Auth.forgotPasswordSubmit() method to submit the forgot password confirmation for the user. The function passes the user's username, code, and password values as parameters.

If the forgot password confirmation is successful, the function sets the form state to 'success' using the setFormState() function.

If there is an error, the function sets the error message in the state variable using the setErrors() function.

If the two password values do not match, the function sets the error message to indicate that the passwords do not match.

Finally, the function returns false to prevent the form from being submitted.
