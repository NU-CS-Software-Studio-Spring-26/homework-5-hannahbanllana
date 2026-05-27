# Homework 5

## Part 1:
- [link](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-hannahbanllana/blob/main/.cursorignore) to `.cursorignore`

## Part 2:
- [link](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-hannahbanllana/blob/main/AGENTS.md) to `AGENTS.md`
- [link](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-hannahbanllana/blob/main/.cursor/rules/rails-conventions.mdc) to `.cursor/rules/rails-conventions.mdc`
- [link](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-hannahbanllana/blob/main/.cursor/rules/security.mdc) to `.cursor/rules/security.mdc`

## Part 3:
### Ask mode:
Prompt: Where in the codebase is the create todo currently implemented? Cite the exact files and line numbers. Do not propose changes.
Answer:
todos_controller.rb: Lines 13-16, 22-35, 74-76 -> this the expected response

### Plan mode:
Prompt: I want to change the create todo so that only users who signed in can create a todo. Propose a plan as a number list of changes, including files to edit, new tests to add, and any migrations. Do not write code.
Answer:


## Numbered changes

### 1. Enable password hashing dependency

- **Edit:** [`Gemfile`](Gemfile) — uncomment `gem "bcrypt"`.
- **Run:** `bundle install` (no code in repo).

### 2. Migration: `users` table

- **Add:** `db/migrate/XXXXXXXX_create_users.rb` via `bin/rails generate model User email:string:uniq password_digest:string`.
- **Columns:** `email` (unique, not null), `password_digest` (not null), timestamps.
- **Run:** `bin/rails db:migrate` (updates [`db/schema.rb`](db/schema.rb)).

### 3. Migration: associate todos with users

- **Add:** `db/migrate/XXXXXXXX_add_user_to_todos.rb` — `add_reference :todos, :user, foreign_key: true`.
- **Decision for existing rows:** allow `null: true` initially **or** backfill fixtures/seeds with a default user in the same migration so you can use `null: false` for new creates only. Existing fixture todos in [`test/fixtures/todos.yml`](test/fixtures/todos.yml) will need a `user` reference after this.

### 4. User model

- **Add:** [`app/models/user.rb`](app/models/user.rb) — `has_secure_password`, `validates :email, presence: true, uniqueness: { case_sensitive: false }`, `has_many :todos`.

### 5. Todo model association

- **Edit:** [`app/models/todo.rb`](app/models/todo.rb) — `belongs_to :user` (optional `optional: true` only if you keep legacy rows without owners).

### 6. Session authentication layer

- **Add:** [`app/controllers/sessions_controller.rb`](app/controllers/sessions_controller.rb) — `new`, `create` (find user by email, `authenticate(password)`), `destroy` (clear session).
- **Add:** [`app/controllers/users_controller.rb`](app/controllers/users_controller.rb) — minimal `new`/`create` for sign-up (needed so tests and demos have accounts), strong params for `email` + `password` + `password_confirmation` only.
- **Edit:** [`app/controllers/application_controller.rb`](app/controllers/application_controller.rb) — `helper_method :current_user, :logged_in?`; private `current_user`, `logged_in?`, `require_login` (redirect to login path with flash if `session[:user_id]` absent).
- **Edit:** [`config/routes.rb`](config/routes.rb) — `resource :session, only: [:new, :create, :destroy]` (or `get/post/delete` login/logout paths), `resources :users, only: [:new, :create]`; keep `resources :todos`.

### 7. Gate todo creation (controller)

- **Edit:** [`app/controllers/todos_controller.rb`](app/controllers/todos_controller.rb):
  - `before_action :require_login, only: %i[new create]`
  - In `create`, build with current user, e.g. `@todo = current_user.todos.build(todo_params)` (or set `user: current_user` after `Todo.new`).
  - Keep `todo_params` as-is (`:description` only); do **not** permit `:user_id` from params (mass-assignment safety per [`security.mdc`](.cursor/rules/security.mdc)).

### 8. Views and layout

- **Add:** [`app/views/sessions/new.html.erb`](app/views/sessions/new.html.erb), [`app/views/users/new.html.erb`](app/views/users/new.html.erb) — simple forms with email/password fields.
- **Edit:** [`app/views/layouts/application.html.erb`](app/views/layouts/application.html.erb) — show Login / Sign up when logged out; Logout + email when logged in.
- **Edit:** [`app/views/todos/index.html.erb`](app/views/todos/index.html.erb) — render `New todo` link only when `logged_in?` (or always show but rely on controller redirect—UI-only hide is nicer UX).
- **Optional:** flash message on login page when redirected from protected `new`/`create`.

### 9. Fixtures and seeds

- **Add:** [`test/fixtures/users.yml`](test/fixtures/users.yml) — at least one user with a known password (use fixture encryption / `BCrypt` pattern per Rails guides, or set `password_digest` from a fixed password in test helper).
- **Edit:** [`test/fixtures/todos.yml`](test/fixtures/todos.yml) — add `user: one` (or equivalent) on each fixture row.
- **Edit:** [`db/seeds.rb`](db/seeds.rb) — create a demo user and assign `user:` when calling `Todo.create` (no real credentials; fake local-only passwords per AGENTS.md).

### 10. Test helper for signing in

- **Edit:** [`test/test_helper.rb`](test/test_helper.rb) — add a helper e.g. `sign_in_as(user)` that posts to session create or sets `session[:user_id]` in integration tests.

### Agent Mode:
Prompt: Can you implement the first step:
Commit: [link](https://github.com/NU-CS-Software-Studio-Spring-26/nu-cs-software-studio-spring-26-homework-5-hw5/commit/b107bce12be520cdaefdfef1c76298a9c1fac316) to commit

### Bad -> Good Prompt rewrite:

Bad: "Fix the bug in todos"

Good:

1. Context:
   - Create/update flow: [`app/controllers/todos_controller.rb`](app/controllers/todos_controller.rb) (`create` 22–35, `update` 37–47, `todo_params` 74–76).
   - Form: [`app/views/todos/_form.html.erb`](app/views/todos/_form.html.erb) (only `description` today).
   - Show partial: [`app/views/todos/_todo.html.erb`](app/views/todos/_todo.html.erb).
   - JSON: [`app/views/todos/_todo.json.jbuilder`](app/views/todos/_todo.json.jbuilder).
   - Tests: [`test/controllers/todos_controller_test.rb`](test/controllers/todos_controller_test.rb), [`test/system/todos_test.rb`](test/system/todos_test.rb).

2. Task:
   Wire `due_date` through the existing HTML create/edit flow: add a due-date field to the form, permit it in strong parameters, and display it on the todo show page. Do not add new migrations—the column already exists.

3. Expected vs. actual:
   - Expected: On `/todos/new`, I set description and a due date, submit, and the show page lists both fields; `Todo.last.due_date` is set in the console.
   - Actual: The new/edit form has no due-date input ([`_form.html.erb`](app/views/todos/_form.html.erb) lines 14–17). `todo_params` only allows `:description` ([`todos_controller.rb`](app/controllers/todos_controller.rb) line 75), so even a manual POST with `todo[due_date]` is rejected. The show partial only renders description ([`_todo.html.erb`](app/views/todos/_todo.html.erb) lines 3–6). No error is raised—the value is silently dropped.

4. Constraints:
   - May edit: `todos_controller.rb`, `_form.html.erb`, `_todo.html.erb`, `_todo.json.jbuilder`, controller/system tests, `test/fixtures/todos.yml` if needed.
   - Do not edit `db/schema.rb` directly; no new gems; follow strong parameters (do not disable mass-assignment protection).
   - Match existing patterns: `form_with`, `params.expect`, HTML + JSON responses, Minitest.

5. Done when:
   - New test in [`test/controllers/todos_controller_test.rb`](test/controllers/todos_controller_test.rb): `post todos_url` with `due_date` present → `assert_equal` on `Todo.last.due_date` after redirect.
   - Updated [`test/system/todos_test.rb`](test/system/todos_test.rb) `should create todo`: fill in due date, assert due date visible on show page after create.
   - `bin/rails test` and the updated system test pass.
