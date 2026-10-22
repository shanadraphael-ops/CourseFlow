# CourseFlow

CourseFlow connects to Canvas and helps students organize their assignments.
It lists assignments by course, tracks how long work takes, and builds a weekly
schedule based on due dates, difficulty and priority.

Built with Flutter for the Congressional App Challenge.

## Running the app

### Demo mode (no Canvas account needed)

Run the app with no extra settings. It starts with built-in sample courses and
assignments, so anyone can try every feature.

```
flutter run
```

### With your own Canvas account (personal use)

1. In Canvas, open **Account → Settings → Approved Integrations** and click
   **+ New Access Token**.
2. Copy `canvas_secrets.example.json` to `canvas_secrets.json`.
3. In `canvas_secrets.json`, set `CANVAS_URL` to your school's Canvas address
   and `CANVAS_TOKEN` to your new token.
4. Run:

   ```
   flutter run --dart-define-from-file=canvas_secrets.json
   ```

   In VS Code, pick the **CourseFlow (my Canvas)** launch configuration.

`canvas_secrets.json` is listed in `.gitignore`. Never commit it or share it:
the token gives full access to your Canvas account.

This setup is for testing with your own account only. Canvas does not allow
apps to ask other users for their personal tokens.

## Roadmap: signing in with Canvas (OAuth2)

To let any student sign in, CourseFlow will use Canvas OAuth2, the method
Canvas requires for apps with multiple users.

1. **Developer key from each school.** A school's Canvas admin creates a
   developer key for CourseFlow. Each key works for one institution.
2. **Sign-in flow.** The student taps *Connect Canvas*, signs in on the school's
   Canvas page and approves access. Canvas returns a one-time code.
3. **Small backend server.** The server trades the code for tokens. It keeps
   the developer key's client secret, which must never be inside the app.
4. **Secure storage.** The app saves the tokens in the device's secure storage
   (Keychain on iOS, Keystore on Android) and refreshes them when they expire.
5. **School picker.** The student chooses their school, and the app uses that
   school's Canvas address and developer key.

## License

CourseFlow is free software, released under the
[GNU General Public License v3.0](LICENSE). You may use, change and share it,
but any version you share must also be released under GPL-3.0.
