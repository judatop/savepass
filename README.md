# SavePass

![](https://github.com/user-attachments/assets/a80ab2d1-74df-48db-8f2b-0ae0f225eba4)

## Introduction

SavePass project is a **password manager** developed in **Flutter**. It's goal is to provide a secure and easy-to-use solution for storing and managing passwords. The app will allow users to create an account, log in, and store their passwords in a secure way. The project is open source and can be used as a starting point for building your own password manager app, just make sure to follow best practices for security and privacy and mention the original project.

## Contributing

If you find issues/improvements with this app, feel free to submit a PR or create a new issue. We want to keep this app with the best practices.

## How to run

This projects depends on a few external services to work properly, so you'll need to set up a few things before running the app.

### Supabase

We are using Supabase as our database, API, storage and authentication manager. Create an account on https://supabase.com/ and create a new project, then, find and copy the values: **SUPABASE_URL** and **SUPABASE_ANON_KEY**.

### Supabase Storage

Supabase Storage is used to store files/images related with the app. You'll need to set up your storage and create a new bucket and folder, copy the values: **SUPABASE_BUCKET** and **SUPABASE_BUCKET_AVATARS_FOLDER**.

Also, you need to add another key for a public parameters bucket called **SUPABASE_PARAMETERS_BUCKET**.

### Supabase Auth with Google

One of the authentication methods we are using is Google. You'll need to create a new project on Google Cloud Platform and create a new OAuth client ID for web, Android and iOS. Then, copy the values: **GOOGLE_WEB_CLIENT_ID** and **GOOGLE_IOS_CLIENT_ID**. After that, you'll need to enable the Google Auth method on Supabase and fill the respective values.

### Supabase Auth with Github

Other authentication method we are using is Github. You'll need to create a new OAuth App on Github and get the Client ID and Client secret. Put these values on the Github configuration on Supabase. Set up the URL Configuration (deep link) on Supabase and assign the value for **SUPABASE_REDIRECT_URL**.

### Supabase Database

The database set up is up to you and your needs. You can create the tables and columns manually or use the Supabase SQL editor. The logic or the design for the database/api on this project is confidential for mantain the security of the app.

## Flutter Secure Storage

Flutter Secure Storage is used to store data in secure storage, Keychain for iOS and EncryptedSharedPreferences for Android, in order to use this plugin you need to define some keys with a random value:
- **BIOMETRIC_HASH_KEY**
- **DERIVED_KEY**


### Git

Get a local copy of the project by running the following command:

```bash
git clone https://github.com/judatop/savepass.git
```

### Local Set Up

Use the following command to create your own .env file:

```bash
cp .env.sample .env
```

Fill your env file with the values you got from the previous steps.

Then, you can generate the offuscated values from the .env file using the following command:

```bash
dart run build_runner build -d
```

Install the dependencies with the following command:

```bash
flutter pub get
```

Run the app with the following command:

```bash
flutter run
```

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file.
