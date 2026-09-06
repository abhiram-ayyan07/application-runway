# Application Runway

A personal job application tracker — search, filter, and sort your pipeline, with Google sign-in and a real synced backend so your board follows you across devices.

**Live app:** https://abhiram-ayyan07.github.io/application-runway/

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Made with Supabase](https://img.shields.io/badge/backend-Supabase-3ECF8E.svg)
![Hosted on GitHub Pages](https://img.shields.io/badge/hosted%20on-GitHub%20Pages-222.svg)

## Features

- Sign in with your Google account — every user's board is private to them
- Track company, role, location, posting link, status, next step, follow-up date, and notes per application
- Search by company or role, filter by status, and sort by date or company
- A summary board showing totals, applications by status, and your response rate
- Synced through a real database, so your data follows you to any device you sign in on

## Tech stack

- **Frontend** — a single self-contained HTML file (vanilla JS, no framework, no build step)
- **Backend** — [Supabase](https://supabase.com) (Postgres database + Auth), accessed directly from the browser via `@supabase/supabase-js`
- **Auth** — Google OAuth via Supabase Auth
- **Hosting** — GitHub Pages

## Running your own copy

1. **Fork this repo**, or copy `index.html` into a new one.
2. **Create a Supabase project** (free tier is enough) at [supabase.com](https://supabase.com).
3. **Set up the database** — run the SQL in [`supabase/schema.sql`](supabase/schema.sql) in your project's SQL Editor. It creates the `applications` table with row-level security, so each signed-in user can only ever see their own rows.
4. **Create a Google OAuth client** in the [Google Cloud Console](https://console.cloud.google.com/apis/credentials):
   - Authorized JavaScript origin: the URL your app will be hosted at (e.g. `https://<you>.github.io`)
   - Authorized redirect URI: `https://<your-project-ref>.supabase.co/auth/v1/callback`
5. In your Supabase project, go to **Authentication → Providers → Google** and paste in the Client ID and Client Secret from step 4.
6. In **Authentication → URL Configuration**, set the Site URL and add your hosted URL to the allowed Redirect URLs.
7. In `index.html`, update the two constants near the top of the `<script>` tag with your own project's values:
   ```js
   var SUPABASE_URL = "https://<your-project-ref>.supabase.co";
   var SUPABASE_ANON_KEY = "<your-anon-or-publishable-key>";
   ```
8. Enable **GitHub Pages** for the repo (Settings → Pages → Deploy from branch → `main` / root).

The anon/publishable key is safe to expose in client-side code by design — it identifies your project, but every read and write is still enforced by the row-level security policies in `schema.sql`.

## Project structure

```
.
├── index.html          # the entire app — markup, styles, and logic
├── supabase/
│   └── schema.sql       # database schema + row-level security policies
└── README.md
```

## License

MIT — see [LICENSE](LICENSE).
