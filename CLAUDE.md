# Flutter App - Development Rules

## General

- Do not re-add previously removed code. If code was removed by the developer, assume it was intentional. Ask before re-introducing it.
- Do not add unnecessary inline comments. Only comment on non-obvious logic. Never restate what the code already says.
- A doc comment describes what something IS, not the history of how it got there. When you change behavior, do NOT append context about the change ("X is now null when...", "calories are no longer estimated..."). Only edit a comment if the existing text no longer accurately describes the definition. If the original sentence still holds, leave it or just delete the now-wrong clause — comments are not a change log. Example: changing a field's behavior, keep `/// A single thing the user logged eating.` as-is rather than tacking on why calories may be null.
- Always use barrel files over direct imports.
- Always use `fvm flutter` instead of `flutter` for all Flutter CLI commands.
- Never run the app (`flutter run` or launching on any device). The developer runs it from VS Code so the debug windows and controls stay attached. Ask them to run it, then interact with their running instance if needed.
- Do not fix linter warnings or info-level diagnostics — only fix errors.
- The code generator for freezed, json_serializable, and injectable should be running in the background at all times, if it's not. please ask the user to start it.
- Don't worry about writing tests until told to do so by the user.
- Do not prematurely optimize. Do not add events, methods, or abstractions for cases an existing general one already covers. If a specific behavior is needed later, add it then. Example: a `getStartedPressed` event whose handler only advances to the next step is unnecessary when `continuePressed` already does that — use `continuePressed` until "get started" actually needs different behavior.
- Do not extract a function/method that has only one caller. Inline it at the call site. The only exception is when the extraction genuinely increases clarity for a reader (e.g. a well-named helper like `_isSameDay` over an inline date comparison, or a BLoC `_on*` handler that keeps the event switch readable). Passing `BuildContext` into a private helper is a smell: such handlers (`_logWeight(context)`, `_pickTime(context)`, `_addUsual(context)`) should be inlined into the `onPressed`/builder closure where context is already in scope.
- Favor clarity over conciseness. The code must be easily readable and understandable by a person who didn't write it. When an expression nests several operations (spread + lookup + filter + copyWith in one go), break it into named local variables or a private method that tells the story step by step, instead of one dense inline expression.

## Models, States & Events

- Always use `@freezed` for data classes, BLoC states, and BLoC events.
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` on the constructor when the API returns snake_case.

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
- Do not pass `TextStyle` (or other pure styling) into a reusable widget — styling lives at the call site. If multiple places need the same formatted text, put the format on the model as a getter (like `WeightEntry.label` / `Nutrition.summary`) and let each call site render its own `Text(model.summary, style: ...)`. Don't build a reusable text widget whose only job is to apply a caller-supplied style.
- Get bloc instances via `getIt<T>()` in views — do not use `context.read<T>()`.

## Dependency Injection

- Use `@singleton` for BLoCs, repositories, and other dependencies.

## Repositories

- Use `mapJson()` for single object parsing and `mapJsonList()` for list parsing.
- API clients return raw `Response<dynamic>`. Repositories are responsible for parsing, and other data manipulation before bloc consumption.
- Only use DTOs when the API response shape doesn't map cleanly to the domain model.

## Responsive Design

- Use `context.layout`, `context.isMobile`, `context.isTablet`, and `context.isDesktop` for responsive UI.

## Testing

- Always use matchers: `equals()`, `isEmpty`, `isNull`, `isTrue`, etc. Never use raw assertions.
- Use `blocTest` for BLoC tests.
- Prefer using `isA<BlocState>().having` in tests over matching the entire state to reduce test fragility.
- Use `mocktail` for mocking dependencies.
- Call `initHydratedStorage()` in test setup when testing with `HydratedBloc`.
