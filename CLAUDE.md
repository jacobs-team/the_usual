# Flutter App - Development Rules

## General

- Do not re-add previously removed code. If code was removed by the developer, assume it was intentional. Ask before re-introducing it.
- Do not add unnecessary inline comments. Only comment on non-obvious logic. Never restate what the code already says.
- A doc comment describes what something IS, not the history of how it got there. When you change behavior, do NOT append context about the change ("X is now null when...", "calories are no longer estimated..."). Only edit a comment if the existing text no longer accurately describes the definition. If the original sentence still holds, leave it or just delete the now-wrong clause — comments are not a change log. Example: changing a field's behavior, keep `/// A single thing the user logged eating.` as-is rather than tacking on why calories may be null.
- Always use barrel files over direct imports.
- Always use `fvm flutter` instead of `flutter` for all Flutter CLI commands.
- Never run the app (`flutter run` or launching on any device). The developer runs it from VS Code so the debug windows and controls stay attached. Ask them to run it, then interact with their running instance if needed.
- Do not fix linter warnings or info-level diagnostics — only fix errors.
- The code generator for freezed, json_serializable, and injectable should be running in the background at all times, if it's not. please ask the user to start it. If you're running a task on your own with no supervision and the watcher has died, you can run it yourself.
- Ignore testing entirely. Never write, run, update, or fix tests. Existing tests that break from a change are out of scope — leave them and don't mention them unless the user asks. You should still focus on writing high quality code that is easily testable.
- Do not prematurely optimize. Do not add events, methods, or abstractions for cases an existing general one already covers. Example: You will eventually have 2 login providers, for now you only have 1, do not prematurely optimize by creating an auth interface that exposes the methods each provider will have. You should optimize only when the second provider is implemented.
- Do not extract a function/method that has only one caller. Inline it at the call site. The only exception is when the extraction genuinely increases clarity for a reader. Passing `BuildContext` into a private helper is a code smell.
- Favor clarity over conciseness. The code must be easily readable and understandable by a person who didn't write it. When an expression nests several operations (spread + lookup + filter + copyWith in one go), break it into named local variables or a private method that tells the story step by step, instead of one dense inline expression.

## Models, States & Events

- Always use `@freezed` for data classes, BLoC states, and BLoC events.
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` on the constructor when the API returns snake_case.

## Persisted state & migrations

- Changing the shape of a `HydratedBloc` state, or any persisted or serialized model, can silently wipe user data. If `fromJson` throws on old stored JSON the bloc resets to its initial state, and even a clean read whose meaning shifted can corrupt behavior. Real example from this app: inserting a value into the middle of the `OnboardingStep` enum shifted the persisted positional `activeStepIndex`, so finished users resolved to an earlier step, got sent back through onboarding, and re-completing overwrote their saved settings.
- Whenever you add, remove, rename, retype, or reorder anything that affects a persisted shape (state fields, or enum values used as map keys or positions), confirm old stored data still reads correctly and add a migration when it does not. Version the persisted state and route by `version` in `fromJson`. Prefer storing stable identifiers like enum names over positional indexes.
- Compact migration pattern (freezed + json_serializable). Keep `fromJson` arrow-bodied or freezed won't generate `toJson`; do the version routing in a delegated factory:

## Naming

- Name fields and variables after the model type they hold, in full. A value of type `MealOfTheDay` is named `mealOfTheDay`, never `meal` — the short form is ambiguous (a meal could be a `UsualMeal`, a `MealLogEntry`, etc.). Example: `const factory MealLogEntry({required MealOfTheDay mealOfTheDay, ...})`, and loops read `for (final mealOfTheDay in MealOfTheDay.values)`.

## BLoC

- Always use exhaustive switch in `on<Event>` bloc method to ensure all events are mapped.
- Always wrap async handlers in try-catch, unless otherwise instructed. Emit `loading` before the call, `success` or `failure` after.
- Prefer `BlocSelector` over `BlocBuilder` to avoid unnecessary rebuilds.
- When multiple items are needed from bloc state, use bloc selector with a record to select multiple pieces of state.

## Views & Widgets

- Always prefer extracted widgets over builder functions or static methods that return widgets.
- Do not extract a single-use widget into its own file just to shrink a build method — that adds an unnecessary abstraction layer. Rule of thumb: only pull a single-use widget into a separate file when the current file is over ~250 lines or genuinely hard to read. Below that, keep it inline (or as a private widget class in the same file). Extract to a shared file only when the widget is reused by more than one caller.
- Feature-specific widgets go in the feature's `widgets/` folder. App-wide widgets go in the apps `widgets/` folder.
- Get bloc instances via `getIt<T>()` in views — do not use `context.read<T>()`.

## Design Mockups

- When the user wants to mock up or compare UI designs before building (e.g. "mock this up", "show me some designs", "design options"), use the `design-mockups` skill. It produces phone-framed HTML mockups styled with the app's real design tokens and screenshots them inline, since the Flutter app is run by the developer, not by you.

## Dependency Injection

- Use getIt and injectable for dependencies. 3rd party modules should use `@module` annotation. `@singleton` for BLoCs, repositories, and other dependencies.

## Repositories

- Use `mapJson()` for single object parsing and `mapJsonList()` for list parsing.
- API clients return raw `Response<dynamic>`. Repositories are responsible for parsing, and other data manipulation before bloc consumption.
- Only use DTOs when the API response shape doesn't map cleanly to the domain model.
- Wrap third-party SDKs or plugins in their own repositories or services, for example `google_sign_in`. The only exception is a pure 1:1 pass-through — if every wrapper method just forwards to the package with no added params, branching, type mapping, or error handling, skip the wrapper.
- Don't add an abstract interface for a repository with a single implementation — that's a speculative abstraction. Use a concrete class; `mocktail` mocks concrete classes fine. Add an interface only when a second real implementation actually exists.

## Responsive Design

- Use `context.layout`, `context.isMobile`, `context.isTablet`, and `context.isDesktop` for responsive UI.

## Testing

- Testing is ignored on this project, now and going forward. Do not write, run, update, or fix tests. See the General section.
