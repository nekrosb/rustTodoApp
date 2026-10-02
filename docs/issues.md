
 ## Issue #1 — Initialize the project and GitHub repository

 ### User Story

 > As a developer, I want to create and configure a Rust project so that I have a working foundation for the CLI Todo List application.

 ### Tasks

 - [ ] Create an empty GitHub repository.
- [ ] Clone the repository locally.
- [ ] Initialize the Rust project with `cargo init`.
- [ ] Verify that the project runs with `cargo run`.
- [ ] Create the initial project structure.
- [ ] Add a `.gitignore` file.
- [ ] Create a basic `README.md`.

 ### Acceptance Criteria

 - [ ] The project runs successfully with `cargo run`.
- [ ] The repository contains a valid Rust project.
- [ ] `Cargo.toml` is present.
- [ ] A `.gitignore` file is present.
- [ ] The README contains a basic project description.
- [ ] The initial commit follows the Conventional Commits standard.

 ### Definition of Done

 - [ ] All tasks are completed.
- [ ] The application builds successfully.
- [ ] Changes are committed and pushed to GitHub.


---

 ## Issue #2 — Add a Todo through the CLI

 ### User Story

 > As a user, I want to enter a Todo through the command line so that I can add a task to my Todo List.

 ### Tasks

 - [ ] Implement user input through the CLI.
- [ ] Read the Todo title entered by the user.
- [ ] Display the entered Todo back to the user.
- [ ] Handle empty input.
- [ ] Make sure the program exits correctly after adding a Todo.

 ### Acceptance Criteria

 - [ ] Running `cargo run` allows the user to enter a Todo.
- [ ] The entered Todo is displayed in the terminal.
- [ ] Empty Todo titles are rejected.
- [ ] The application exits correctly after the Todo is entered.

 ### Definition of Done

 - [ ] Todo input works correctly.
- [ ] Invalid input is handled.
- [ ] Code is formatted with `cargo fmt`.
- [ ] Changes are committed and pushed.

---

 ## Issue #3 — Save Todos to a text file

 ### User Story

 > As a user, I want my Todos to be saved to a local file so that they are not lost when the application is closed.

 ### Tasks

 - [ ] Create a `todo.txt` file.
- [ ] Save each Todo on a separate line.
- [ ] Create the file automatically if it does not exist.
- [ ] Read and write the file using Rust's file system APIs.
- [ ] Handle file read/write errors.

 ### Acceptance Criteria

 - [ ] Every new Todo is saved to `todo.txt`.
- [ ] Each Todo is stored on a separate line.
- [ ] Existing Todos remain available after restarting the application.
- [ ] The file is automatically created if it does not exist.
- [ ] File errors are handled without crashing unexpectedly.

 ### Definition of Done

 - [ ] Todos persist between application sessions.
- [ ] File operations work correctly.
- [ ] Error handling is implemented.
- [ ] Code is formatted and committed.


---

 ## Issue #4 — View all Todos

 ### User Story

 > As a user, I want to view all my Todos with their line numbers so that I can identify a specific Todo when I want to delete or modify it.

 ### Tasks

 - [ ] Add the `--view` argument.
- [ ] Read Todos from `todo.txt`.
- [ ] Display all Todos in the terminal.
- [ ] Display a number for each Todo.
- [ ] Handle an empty or missing Todo file.

 ### Example

```
cargo run -- --view
```

 ### Acceptance Criteria

 - [ ] `cargo run -- --view` displays all Todos.
- [ ] Every Todo has a corresponding number.
- [ ] Numbering starts at `1`.
- [ ] Todos are displayed in the expected order.
- [ ] An empty list is handled with a clear message.

 ### Definition of Done

 - [ ] The `--view` option works correctly.
- [ ] Todos are numbered.
- [ ] Missing/empty files are handled.
- [ ] Changes are committed.

---

 ## Issue #5 — Delete a Todo

 ### User Story

 > As a user, I want to delete a Todo by its number so that I can keep my Todo List up to date.

 ### Tasks

 - [ ] Add the `--delete` argument.
- [ ] Read the Todo number from the CLI.
- [ ] Validate the Todo number.
- [ ] Remove the selected Todo.
- [ ] Rewrite `todo.txt` with the remaining Todos.
- [ ] Handle invalid or non-existing Todo numbers.

 ### Example

```
cargo run -- --delete 2
```

 ### Acceptance Criteria

 - [ ] `cargo run -- --delete <line_number>` deletes the selected Todo.
- [ ] All other Todos remain unchanged.
- [ ] Todo numbering is correct after deletion.
- [ ] An invalid number does not crash the application.
- [ ] A clear error message is displayed for a non-existing Todo.

 ### Definition of Done

 - [ ] Todo deletion works correctly.
- [ ] Invalid input is handled.
- [ ] The file is updated correctly.
- [ ] Changes are committed.


---

 ## Issue #6 — Migrate Todo storage from TXT to JSON

 ### User Story

 > As a developer, I want to store Todos in a JSON file so that each Todo can contain structured information such as completion status and due dates.

 ### Tasks

 - [ ] Add the `serde` crate.
- [ ] Add the `serde_json` crate.
- [ ] Create a `Todo` struct.
- [ ] Add a `todos.json` file.
- [ ] Implement serialization.
- [ ] Implement deserialization.
- [ ] Replace `todo.txt` storage with `todos.json`.
- [ ] Make sure existing Todo operations use the JSON storage.

 ### Suggested Data Structure

```
struct Todo {
    title: String,
    completed: bool,
    due_date: Option<String>,
}
```

 ### Acceptance Criteria

 - [ ] Todos are stored in `todos.json`.
- [ ] Todos are loaded correctly after restarting the application.
- [ ] JSON contains structured Todo data.
- [ ] `serde` is used for serialization and deserialization.
- [ ] The application no longer relies on `todo.txt`.
- [ ] Existing Todo functionality continues to work after the migration.

 ### Definition of Done

 - [ ] JSON persistence works correctly.
- [ ] Serialization and deserialization work.
- [ ] No Todo functionality is broken by the migration.
- [ ] Changes are committed.


---

 ## Issue #7 — Mark a Todo as completed

 ### User Story

 > As a user, I want to mark a Todo as completed so that I can keep track of my progress.

 ### Tasks

 - [ ] Add the `--complete` argument.
- [ ] Read the Todo number from the CLI.
- [ ] Find the corresponding Todo.
- [ ] Change its `completed` status to `true`.
- [ ] Save the updated Todo list to `todos.json`.
- [ ] Display the completion status when viewing Todos.
- [ ] Handle invalid Todo numbers.

 ### Example

```
cargo run -- --complete 2
```

 ### Acceptance Criteria

 - [ ] `cargo run -- --complete <line_number>` marks the selected Todo as completed.
- [ ] The `completed` field is updated in `todos.json`.
- [ ] The completed status remains after restarting the application.
- [ ] The completed Todo is clearly identifiable when viewing the list.
- [ ] Invalid Todo numbers are handled correctly.

 ### Definition of Done

 - [ ] Todo completion works.
- [ ] The JSON file is updated correctly.
- [ ] The status is displayed to the user.
- [ ] Changes are committed.

---

 ## Issue #8 — Use Clap for CLI argument parsing

 ### User Story

 > As a user, I want clear CLI commands and arguments so that I can easily interact with the Todo application from the terminal.

 ### Tasks

 - [ ] Add the `clap` crate.
- [ ] Configure the CLI parser.
- [ ] Add an `add` command.
- [ ] Add a `view` command.
- [ ] Add a `delete` command.
- [ ] Add a `complete` command.
- [ ] Add a `search` command.
- [ ] Add `--help` support.
- [ ] Handle unknown or invalid arguments.

 ### Expected Commands

```
cargo run -- add "Buy groceries"
cargo run -- view
cargo run -- delete 2
cargo run -- complete 2
cargo run -- search groceries
```

 ### Acceptance Criteria

 - [ ] CLI argument parsing is handled by Clap.
- [ ] `--help` displays available commands and options.
- [ ] `add` is handled by Clap.
- [ ] `view` is handled by Clap.
- [ ] `delete` is handled by Clap.
- [ ] `complete` is handled by Clap.
- [ ] `search` is handled by Clap.
- [ ] Invalid arguments produce a clear error message.

 ### Definition of Done

 - [ ] Clap is fully integrated.
- [ ] All CLI commands work through Clap.
- [ ] Help output is available.
- [ ] Invalid commands are handled correctly.



---

 ## Issue #9 — Add due dates to Todos

 ### User Story

 > As a user, I want to specify a due date when creating a Todo so that I know when the task needs to be completed.

 ### Example

```
cargo run -- add "Buy groceries" --due "2023-12-31"
```

 ### Tasks

 - [ ] Add the `--due` option to the `add` command.
- [ ] Make the due date optional.
- [ ] Store the due date in `todos.json`.
- [ ] Validate the date format.
- [ ] Handle invalid dates.
- [ ] Display the due date when viewing Todos.

 ### Expected Format

```
YYYY-MM-DD
```

 ### Acceptance Criteria

 - [ ] A Todo can be created without a due date.
- [ ] A Todo can be created with a due date.
- [ ] The due date is stored in `todos.json`.
- [ ] The expected format is `YYYY-MM-DD`.
- [ ] Invalid date formats are rejected.
- [ ] The due date is displayed when viewing the Todo.

 ### Definition of Done

 - [ ] Due dates can be created and stored.
- [ ] Date validation works.
- [ ] Existing functionality continues to work.
- [ ] Changes are committed.



---

 ## Issue #10 — Sort Todos by due date

 ### User Story

 > As a user, I want my Todos to be sorted by due date so that I can see upcoming tasks first.

 ### Tasks

 - [ ] Sort Todos by their due dates when viewing them.
- [ ] Display the earliest due dates first.
- [ ] Put Todos without due dates at the end.
- [ ] Keep Todo numbering correct after sorting.
- [ ] Make sure sorting does not modify the stored order in `todos.json`.

 ### Acceptance Criteria

 - [ ] Todos are displayed in ascending due-date order.
- [ ] Earlier due dates appear before later due dates.
- [ ] Todos without a due date appear at the end.
- [ ] Todo numbering reflects the displayed order.
- [ ] Sorting does not modify the underlying JSON data.

 ### Definition of Done

 - [ ] Todo sorting works correctly.
- [ ] Todos without due dates are handled correctly.
- [ ] The stored data is not unexpectedly reordered.
- [ ] Changes are committed.


---

 ## Issue #11 — Search Todos by keyword

 ### User Story

 > As a user, I want to search for Todos by keyword so that I can quickly find the tasks I am looking for.

 ### Example

```
cargo run -- search groceries
```

 ### Tasks

 - [ ] Add the `search` command.
- [ ] Read the search keyword from the CLI.
- [ ] Load Todos from `todos.json`.
- [ ] Search for the keyword in Todo titles.
- [ ] Display all matching Todos.
- [ ] Handle cases where no Todo matches the keyword.

 ### Acceptance Criteria

 - [ ] `cargo run -- search <keyword>` performs a search.
- [ ] All matching Todos are displayed.
- [ ] Non-matching Todos are not displayed.
- [ ] Searching does not modify Todo data.
- [ ] A clear message is displayed when no results are found.

 ### Definition of Done

 - [ ] Keyword search works correctly.
- [ ] Search results are displayed clearly.
- [ ] No data is modified during a search.
- [ ] Changes are committed.


---

 ## Issue #12 — Refactor and improve code structure

 ### User Story

 > As a developer, I want the codebase to be clean and well structured so that the application is easy to maintain and extend.

 ### Tasks

 - [ ] Separate CLI logic from business logic.
- [ ] Move file operations into a dedicated module.
- [ ] Move Todo operations into a dedicated module.
- [ ] Remove duplicated code.
- [ ] Remove dead code.
- [ ] Improve error handling.
- [ ] Use appropriate `Result` and error handling patterns.
- [ ] Review naming and code organization.
- [ ] Keep functions focused on a single responsibility.

 ### Acceptance Criteria

 - [ ] There is no obvious code duplication.
- [ ] There is no dead code.
- [ ] CLI parsing is separated from application logic.
- [ ] File/storage operations are separated from Todo operations.
- [ ] Errors are handled appropriately.
- [ ] The codebase follows common Rust conventions.

 ### Definition of Done

 - [ ] The codebase has been reviewed and refactored.
- [ ] No unnecessary duplication remains.
- [ ] No dead code remains.
- [ ] The application still works after refactoring.
- [ ] Changes are committed.


---

 ## Issue #13 — Format code and fix Clippy warnings

 ### User Story

 > As a developer, I want the codebase to follow Rust formatting and linting standards so that the project remains clean and maintainable.

 ### Tasks

 - [ ] Run `cargo fmt`.
- [ ] Run `cargo fmt -- --check`.
- [ ] Run `cargo clippy`.
- [ ] Fix all Clippy warnings.
- [ ] Run `cargo check`.
- [ ] Run `cargo build`.

 ### Acceptance Criteria

 - [ ] `cargo fmt -- --check` passes successfully.
- [ ] `cargo clippy` produces no warnings or errors.
- [ ] `cargo check` passes successfully.
- [ ] `cargo build` passes successfully.

 ### Definition of Done

 - [ ] Code is formatted.
- [ ] Clippy warnings are fixed.
- [ ] The project builds successfully.
- [ ] All changes are committed.


---

 ## Issue #14 — Complete the README documentation

 ### User Story

 > As a new user, I want clear documentation so that I can install and run the application without additional help.

 ### Tasks

 - [ ] Add a project description.
- [ ] Add project requirements.
- [ ] Add installation/setup instructions.
- [ ] Explain how to run the application.
- [ ] Document all available CLI commands.
- [ ] Add usage examples.
- [ ] Document Todo storage.
- [ ] Explain the JSON structure if relevant.

 ### README Should Include

 - Project description
- Requirements
- Installation
- Setup
- Usage
- Available commands
- Examples
- Data storage information

 ### Acceptance Criteria

 - [ ] The README contains a clear project description.
- [ ] Setup instructions are complete.
- [ ] All CLI commands are documented.
- [ ] Examples are provided.
- [ ] A new user can run the application by following the README only.

 ### Definition of Done

 - [ ] README is complete.
- [ ] Instructions have been tested.
- [ ] Examples work correctly.
- [ ] Documentation is committed and pushed.
