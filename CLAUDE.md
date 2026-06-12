# Flutter App - Development Rules

## General

- Do not re-add previously removed code. If code was removed by the developer, assume it was intentional. Ask before re-introducing it.
- Do not add unnecessary inline comments. Only comment on non-obvious logic. Never restate what the code already says.
- Always use barrel files over direct imports.
- Always use `fvm flutter` instead of `flutter` for all Flutter CLI commands.
- Never run the app (`flutter run` or launching on any device). The developer runs it from VS Code so the debug windows and controls stay attached. Ask them to run it, then interact with their running instance if needed.
- Do not fix linter warnings or info-level diagnostics — only fix errors.
- The code generator for freezed, json_serializable, and injectable should be running in the background at all times, if it's not. please ask the user to start it.
- Don't worry about writing tests until told to do so by the user.
- Do not prematurely optimize. Do not add events, methods, or abstractions for cases an existing general one already covers. If a specific behavior is needed later, add it then. Example: a `getStartedPressed` event whose handler only advances to the next step is unnecessary when `continuePressed` already does that — use `continuePressed` until "get started" actually needs different behavior.

## Models, States & Events

- Always use `@freezed` for data classes, BLoC states, and BLoC events.
- Use `@JsonSerializable(fieldRename: FieldRename.snake)` on the constructor when the API returns snake_case.

## BLoC

- Always use exhaustive switch in `on<Event>` bloc method to ensure all events are mapped.
- Always wrap async handlers in try-catch, unless otherwise instructed. Emit `loading` before the call, `success` or `failure` after.
- Prefer `BlocSelector` over `BlocBuilder` to avoid unnecessary rebuilds.
- When multiple items are needed from bloc state, use bloc selector with a record to select multiple pieces of state.

## Views & Widgets

- Always prefer extracted widgets over builder functions or static methods that return widgets.
- Feature-specific widgets go in the feature's `widgets/` folder. App-wide widgets go in the apps `widgets/` folder.
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
