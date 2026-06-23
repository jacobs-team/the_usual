# Workout Design Fixes Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply five targeted design fixes to the workout feature — group name pencil-to-edit, card wrapper on the entry sheet, focus-dimmed unit labels, bodyweight checkbox label wording, and inline bodyweight hint — then fix all affected tests and pass the full suite.

**Architecture:** Each fix is surgical and self-contained: no new models, no codegen. Three widget files are modified (`workout_log_section.dart`, `workout_entry_sheet.dart`, `set_fields.dart`), one shared widget gets a new optional param (`the_usual_text_field.dart`), and three test files are updated to match new interaction flows.

**Tech Stack:** Flutter, Dart, `flutter_test`, `mocktail`, `fvm flutter`

## Global Constraints

- `fvm flutter` / `fvm dart` only — never bare `flutter` or `dart`
- Never run the app (`flutter run`)
- Never commit or push
- Never fix linter warnings or info-level diagnostics — only fix errors
- Do not add codegen annotations or run `build_runner`
- Tests locate widgets by type, key, or icon — never `find.text()` for UI copy (except for the one existing test that already uses `find.text` for a non-localized message — follow the spec direction there)
- Do not extract single-use widgets to their own files
- Use `fvm flutter test --test-randomize-ordering-seed random` for the full suite
- No em dashes, no AI writing patterns in comments

---

### Task 1 — `TheUsualTextField`: add `suffixStyle` param

**Files:**
- Modify: `lib/app/widgets/inputs/the_usual_text_field.dart`

**Interfaces:**
- Produces: `TheUsualTextField({TextStyle? suffixStyle, ...})` — new optional named param passed to `InputDecoration(suffixStyle: suffixStyle)`

- [ ] **Step 1: Open the file and locate the constructor**

  Read `lib/app/widgets/inputs/the_usual_text_field.dart`. The constructor currently has no `suffixStyle` param. The `InputDecoration` at line ~110 has `suffixText: suffixText` but no `suffixStyle`.

- [ ] **Step 2: Add the param to the constructor**

  In the constructor param list (after `suffixIconConstraints`), add:

  ```dart
  this.suffixStyle,
  ```

  In the field declarations (after `final BoxConstraints? suffixIconConstraints;`), add:

  ```dart
  /// Style for the suffix text. Defaults to the field's hint style when null.
  final TextStyle? suffixStyle;
  ```

- [ ] **Step 3: Pass it through to `InputDecoration`**

  In the `InputDecoration(...)` block, add `suffixStyle: suffixStyle,` after `suffixText: suffixText,`.

- [ ] **Step 4: Verify no analysis errors**

  ```
  fvm flutter analyze lib/app/widgets/inputs/the_usual_text_field.dart
  ```

  Expected: no errors (warnings/infos are fine to ignore).

---

### Task 2 — `SetFields`: extract `_SetRow` with per-field focus nodes

**Files:**
- Modify: `lib/app/widgets/inputs/set_fields.dart`
- Test: `test/app/widgets/set_fields_test.dart`

**Interfaces:**
- Consumes: `TheUsualTextField({TextStyle? suffixStyle, FocusNode? focusNode, ...})` from Task 1
- Produces: `_SetRow` — private `StatefulWidget` inside `set_fields.dart` that owns two `FocusNode`s, listens to each for focus changes, and computes `suffixStyle` per field

- [ ] **Step 1: Run the set_fields tests to confirm green baseline**

  ```
  fvm flutter test test/app/widgets/set_fields_test.dart --test-randomize-ordering-seed random
  ```

  Expected: all pass.

- [ ] **Step 2: Add the `_SetRow` StatefulWidget below `_SetFieldsState`**

  Add this class at the bottom of `set_fields.dart`. It receives the controllers, index, flags, and callbacks from `_SetFieldsState.build`, and owns only its two `FocusNode`s.

  ```dart
  class _SetRow extends StatefulWidget {
    const _SetRow({
      required this.weightController,
      required this.repsController,
      required this.index,
      required this.count,
      required this.weightUnit,
      required this.bodyweight,
      required this.onChanged,
      required this.onRemove,
    });

    final TextEditingController weightController;
    final TextEditingController repsController;
    final int index;
    final int count;
    final WeightUnit weightUnit;
    final bool bodyweight;
    final VoidCallback onChanged;
    final VoidCallback onRemove;

    @override
    State<_SetRow> createState() => _SetRowState();
  }

  class _SetRowState extends State<_SetRow> {
    late final FocusNode _weightFocus;
    late final FocusNode _repsFocus;

    @override
    void initState() {
      super.initState();
      _weightFocus = FocusNode();
      _repsFocus = FocusNode();
      _weightFocus.addListener(() => setState(() {}));
      _repsFocus.addListener(() => setState(() {}));
    }

    @override
    void dispose() {
      _weightFocus.dispose();
      _repsFocus.dispose();
      super.dispose();
    }

    TextStyle _suffixStyle(BuildContext context, bool focused) {
      final colorScheme = Theme.of(context).colorScheme;
      return TextStyle(
        color: focused
            ? colorScheme.onSurfaceVariant
            : colorScheme.outline,
      );
    }

    @override
    Widget build(BuildContext context) {
      final focused = _weightFocus.hasFocus || _repsFocus.hasFocus;
      _ = focused; // suppress unused warning — per-field focus is used below
      return Padding(
        padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: TheUsualTextField(
                key: Key('set-weight-${widget.index}'),
                controller: widget.weightController,
                focusNode: _weightFocus,
                dense: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,4}\.?\d{0,1}'),
                  ),
                ],
                hintText: widget.bodyweight ? 'auto' : null,
                suffixText: ' ${widget.weightUnit.name}',
                suffixStyle: _suffixStyle(context, _weightFocus.hasFocus),
                onChanged: (_) => widget.onChanged(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDesign.spacing.sm,
              ),
              child: const Text('×'),
            ),
            SizedBox(
              width: 80,
              child: TheUsualTextField(
                key: Key('set-reps-${widget.index}'),
                controller: widget.repsController,
                focusNode: _repsFocus,
                dense: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                suffixText: ' reps',
                suffixStyle: _suffixStyle(context, _repsFocus.hasFocus),
                onChanged: (_) => widget.onChanged(),
              ),
            ),
            if (widget.count > 1)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onRemove,
              ),
          ],
        ),
      );
    }
  }
  ```

  Note: remove the `_ = focused;` suppression line — it was a placeholder comment. The per-field `_weightFocus.hasFocus` / `_repsFocus.hasFocus` is used directly in `_suffixStyle(...)` calls.

- [ ] **Step 3: Replace the inline row in `_SetFieldsState.build` with `_SetRow`**

  In `_SetFieldsState.build`, the `for` loop currently builds a `Padding(child: Row(...))` inline. Replace the entire `Padding(...)` block inside the loop with:

  ```dart
  _SetRow(
    key: ValueKey(i),
    weightController: _weightControllers[i],
    repsController: _repsControllers[i],
    index: i,
    count: _weightControllers.length,
    weightUnit: widget.weightUnit,
    bodyweight: widget.bodyweight,
    onChanged: _emit,
    onRemove: () => _removeSet(i),
  ),
  ```

  Remove the outer `Padding` wrapping (the `_SetRow` now carries its own bottom padding internally).

- [ ] **Step 4: Run the set_fields tests**

  ```
  fvm flutter test test/app/widgets/set_fields_test.dart --test-randomize-ordering-seed random
  ```

  Expected: all pass. Keys (`set-weight-$i`, `set-reps-$i`), `Icons.close`, and `Icons.add` are all unchanged.

- [ ] **Step 5: Analyze**

  ```
  fvm flutter analyze lib/app/widgets/inputs/set_fields.dart
  ```

  Fix any errors (not warnings/infos).

---

### Task 3 — `_EditableGroupName`: pencil-to-edit with focus commit

**Files:**
- Modify: `lib/app/feature/workout/widgets/workout_log_section.dart`
- Test: `test/app/feature/workout/widgets/workout_log_section_test.dart`
- Test: `test/app/feature/workout/view/workouts_view_test.dart`

**Interfaces:**
- Consumes: `TheUsualTextField({autoSize, focusNode, dense, textCapitalization, onSubmitted})` — already exists
- Produces: `_EditableGroupName` renders a `Text` + pencil `IconButton` by default, and swaps to a `TheUsualTextField` only when editing

- [ ] **Step 1: Run the affected tests to confirm baseline**

  ```
  fvm flutter test test/app/feature/workout/widgets/workout_log_section_test.dart test/app/feature/workout/view/workouts_view_test.dart --test-randomize-ordering-seed random
  ```

  Note the current results — `editing the group name` and `renaming the push group` tests should currently pass (they enterText directly into the key).

- [ ] **Step 2: Rewrite `_EditableGroupNameState`**

  Replace the entire `_EditableGroupNameState` class (lines 259–293 in the current file) with:

  ```dart
  class _EditableGroupNameState extends State<_EditableGroupName> {
    late final _controller = TextEditingController(text: widget.name);
    late final _focusNode = FocusNode();
    var _editing = false;

    @override
    void initState() {
      super.initState();
      _focusNode.addListener(_onFocusChange);
    }

    @override
    void dispose() {
      _controller.dispose();
      _focusNode.dispose();
      super.dispose();
    }

    @override
    void didUpdateWidget(_EditableGroupName oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (!_editing &&
          widget.name != oldWidget.name &&
          _controller.text != widget.name) {
        _controller.text = widget.name;
      }
    }

    void _onFocusChange() {
      if (!_focusNode.hasFocus && _editing) {
        _commit(_controller.text);
      }
    }

    void _commit(String value) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty && trimmed != widget.name) {
        widget.onRenamed(trimmed);
      } else {
        _controller.text = widget.name;
      }
      setState(() => _editing = false);
    }

    void _startEditing() {
      setState(() => _editing = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      if (_editing) {
        return Align(
          alignment: Alignment.centerLeft,
          child: TheUsualTextField(
            controller: _controller,
            focusNode: _focusNode,
            dense: true,
            autoSize: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: _commit,
          ),
        );
      }
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.name,
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: _startEditing,
            ),
          ],
        ),
      );
    }
  }
  ```

- [ ] **Step 3: Update `workout_log_section_test.dart` — rename test**

  The test `'editing the group name calls onRenamed'` currently does:
  ```dart
  await tester.enterText(find.byKey(const Key('group-name-push')), 'Chest');
  await tester.pump();
  expect(captured, equals('Chest'));
  ```

  Replace with the new two-step flow (tap pencil, then enter text and submit):

  ```dart
  testWidgets('editing the group name calls onRenamed', (tester) async {
    String? captured;
    await pumpSection(tester, onRenamed: (value) => captured = value);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('group-name-push')),
        matching: find.byIcon(Icons.edit_outlined),
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('group-name-push')),
      'Chest',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(captured, equals('Chest'));
  });
  ```

- [ ] **Step 4: Update `workouts_view_test.dart` — rename test**

  The test `'renaming the push group dispatches workoutGroupRenamed'` currently does:
  ```dart
  await tester.enterText(
    find.byKey(const Key('group-name-push')),
    'Press Day',
  );
  await tester.pump();
  verify(...workoutGroupRenamed('push', 'Press Day')...).called(1);
  ```

  Replace the body (after `pumpPumpPumpItUP`) with:

  ```dart
  await tester.tap(
    find.descendant(
      of: find.byKey(const Key('group-name-push')),
      matching: find.byIcon(Icons.edit_outlined),
    ),
  );
  await tester.pump();

  await tester.enterText(
    find.byKey(const Key('group-name-push')),
    'Press Day',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();

  verify(
    () => userSettingsBloc.add(
      const UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'),
    ),
  ).called(1);
  ```

- [ ] **Step 5: Run the two workout test files**

  ```
  fvm flutter test test/app/feature/workout/widgets/workout_log_section_test.dart test/app/feature/workout/view/workouts_view_test.dart --test-randomize-ordering-seed random
  ```

  Expected: all pass.

- [ ] **Step 6: Analyze**

  ```
  fvm flutter analyze lib/app/feature/workout/widgets/workout_log_section.dart
  ```

  Fix errors only.

---

### Task 4 — `WorkoutEntrySheet`: card wrapper + bodyweight label + inline hint

**Files:**
- Modify: `lib/app/widgets/inputs/workout_entry_sheet.dart`
- Test: `test/app/widgets/workout_entry_sheet_test.dart`

This task covers Fixes 2, 4, and 5 together because they all touch `workout_entry_sheet.dart` and the same test file.

**Interfaces:**
- Consumes: `AppDesign.spacing.md` for card padding, `TheUsualBottomSheet` wrapper unchanged
- Produces: form content wrapped in `Card(child: Padding(...))`, bodyweight label changed, inline hint via `Key('bodyweight-hint')`

- [ ] **Step 1: Run the entry sheet tests to confirm baseline**

  ```
  fvm flutter test test/app/widgets/workout_entry_sheet_test.dart --test-randomize-ordering-seed random
  ```

  Note results.

- [ ] **Step 2: Add `_bodyweightHintShown` state field**

  In `WorkoutEntrySheetState`, after `var _estimating = false;`, add:

  ```dart
  var _bodyweightHintShown = false;
  ```

- [ ] **Step 3: Change the bodyweight `onChanged` to set the inline hint state instead of showing a SnackBar**

  Find the `onChanged: (_) {` block for the bodyweight `Checkbox`. Replace the entire `onChanged` body with:

  ```dart
  onChanged: (_) {
    if (widget.bodyWeight == null) {
      setState(() => _bodyweightHintShown = true);
      return;
    }
    setState(() => _bodyweightChecked = !_bodyweightChecked);
  },
  ```

- [ ] **Step 4: Change the bodyweight label text and wrap in `Expanded`**

  Find `const Text('Bodyweight')` in the checkbox `Row`. Replace it with:

  ```dart
  const Expanded(
    child: Text('Estimate set weight based on body weight'),
  ),
  ```

- [ ] **Step 5: Add the inline hint `Text` below the bodyweight `Row`**

  After the bodyweight checkbox `Row(...)`, add a conditional hint:

  ```dart
  if (_bodyweightHintShown && widget.bodyWeight == null)
    Text(
      'Add your body weight to estimate bodyweight sets. '
      'Log it on the Today view or set a starting weight in Settings.',
      key: const Key('bodyweight-hint'),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  ```

- [ ] **Step 6: Wrap the form content in a `Card`**

  The `TheUsualBottomSheet` `child` is currently a `Column` whose `children` are (in order):
  1. Name `Row` (with optional camera button)
  2. Suggesting spinner
  3. Suggestions chips
  4. `SizedBox(height: AppDesign.spacing.md)`
  5. `SectionLabel('SETS')`
  6. `SetFields`
  7. `SizedBox(height: AppDesign.spacing.sm)`
  8. Bodyweight `Row`
  9. (new) bodyweight hint
  10. Save-as-usual `Row` (conditional)
  11. `SizedBox(height: AppDesign.spacing.md)`
  12. `FilledButton` (confirm)

  The `Card` wraps items 1–10 (name through bodyweight hint and save-as-usual). The confirm button stays outside.

  Replace the `child: Column(...)` of `TheUsualBottomSheet` with:

  ```dart
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Card(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TheUsualTextField(
                      controller: _nameController,
                      autofocus: true,
                      hintText: 'e.g. Bench Press',
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (_aiAvailable) ...[
                    SizedBox(width: AppDesign.spacing.sm),
                    FilledButton.tonalIcon(
                      style: aiButtonStyle,
                      onPressed: _suggesting ? null : _pickPhotosAndSuggest,
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                        size: 18,
                      ),
                      label: const Text('Photo'),
                    ),
                  ],
                ],
              ),
              if (_suggesting) ...[
                SizedBox(height: AppDesign.spacing.sm),
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: AppDesign.spacing.sm),
                    Text('Finding exercises…', style: textTheme.bodySmall),
                  ],
                ),
              ],
              if (_suggestions.isNotEmpty) ...[
                SizedBox(height: AppDesign.spacing.sm),
                Wrap(
                  spacing: AppDesign.spacing.sm,
                  runSpacing: AppDesign.spacing.xs,
                  children: [
                    for (final suggestion in _suggestions)
                      ActionChip(
                        label: Text(suggestion),
                        onPressed: () => _applyChip(suggestion),
                      ),
                  ],
                ),
              ],
              SizedBox(height: AppDesign.spacing.md),
              const SectionLabel('SETS'),
              SetFields(
                initial: _currentSets,
                weightUnit: widget.weightUnit,
                bodyweight: _bodyweightChecked,
                onChanged: (sets) => setState(() => _currentSets = sets),
              ),
              SizedBox(height: AppDesign.spacing.sm),
              Row(
                children: [
                  Checkbox(
                    key: const Key('bodyweight-checkbox'),
                    value: _bodyweightChecked,
                    onChanged: (_) {
                      if (widget.bodyWeight == null) {
                        setState(() => _bodyweightHintShown = true);
                        return;
                      }
                      setState(() => _bodyweightChecked = !_bodyweightChecked);
                    },
                  ),
                  const Expanded(
                    child: Text('Estimate set weight based on body weight'),
                  ),
                ],
              ),
              if (_bodyweightHintShown && widget.bodyWeight == null)
                Text(
                  'Add your body weight to estimate bodyweight sets. '
                  'Log it on the Today view or set a starting weight in Settings.',
                  key: const Key('bodyweight-hint'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              if (widget.showAddToUsuals) ...[
                Row(
                  children: [
                    Checkbox(
                      key: const Key('save-as-usual-checkbox'),
                      value: _saveAsUsual,
                      onChanged: (value) =>
                          setState(() => _saveAsUsual = value ?? false),
                    ),
                    const Text('Save as usual'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      SizedBox(height: AppDesign.spacing.md),
      FilledButton(
        key: const Key('confirm-button'),
        onPressed: _canConfirm ? _confirm : null,
        child: Text(widget.confirmLabel),
      ),
    ],
  ),
  ```

  Important: `aiButtonStyle` is defined inside `build`. Keep that definition before the `return TheUsualBottomSheet(...)`.

- [ ] **Step 7: Update the SnackBar test in `workout_entry_sheet_test.dart`**

  The test `'tapping bodyweight checkbox when bodyWeight is null shows the snack bar'` currently asserts `find.text(...)` finds the message. Replace it entirely:

  ```dart
  testWidgets(
      'tapping bodyweight checkbox when bodyWeight is null shows inline hint',
      (tester) async {
    await showSheet(tester);

    await tester.tap(find.byKey(const Key('bodyweight-checkbox')));
    await tester.pump();

    expect(find.byKey(const Key('bodyweight-hint')), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    // The checkbox must remain unchecked.
    final checkbox = tester.widget<Checkbox>(
      find.byKey(const Key('bodyweight-checkbox')),
    );
    expect(checkbox.value, isFalse);
  });
  ```

- [ ] **Step 8: Run the entry sheet tests**

  ```
  fvm flutter test test/app/widgets/workout_entry_sheet_test.dart --test-randomize-ordering-seed random
  ```

  Expected: all pass. If any test fails because it used `find.byType(TextFormField).first` and the `Card` wrapper changed ordering, check — the first `TextFormField` should still be the name field because nothing was reordered.

- [ ] **Step 9: Analyze**

  ```
  fvm flutter analyze lib/app/widgets/inputs/workout_entry_sheet.dart
  ```

  Fix errors only.

---

### Task 5 — Full suite and report

**Files:**
- Create: `.superpowers/sdd/design-fixes-report.md`

- [ ] **Step 1: Run the full test suite**

  ```
  fvm flutter test --test-randomize-ordering-seed random
  ```

  Collect the output. Fix any failures that were caused by changes in this plan (do not fix pre-existing unrelated failures unless they block the suite).

- [ ] **Step 2: Re-run until green**

  Repeat until the full suite passes (or document any pre-existing failures that are unrelated to these fixes).

- [ ] **Step 3: Write the report**

  Create `.superpowers/sdd/design-fixes-report.md` with:

  ```markdown
  # Workout Design Fixes — Report

  ## Fix 1 — Pencil-to-edit group name
  Files: `lib/app/feature/workout/widgets/workout_log_section.dart`
  Added `_editing` state + `FocusNode` with focus-loss commit. Not-editing mode renders `Text + pencil IconButton`; editing mode renders a `TheUsualTextField(autoSize: true)`. Both wrapped in `Align(centerLeft)` inside `Expanded` to avoid autoSize-in-Expanded trap. `didUpdateWidget` only syncs controller when not editing.

  ## Fix 2 — Card wrapper on workout entry sheet
  Files: `lib/app/widgets/inputs/workout_entry_sheet.dart`
  Wrapped name row through save-as-usual in `Card(child: Padding(EdgeInsets.all(AppDesign.spacing.md), ...))`. Confirm button stays outside with `SizedBox(height: AppDesign.spacing.md)` separator.

  ## Fix 3 — Focus-dimmed unit labels
  Files: `lib/app/widgets/inputs/the_usual_text_field.dart`, `lib/app/widgets/inputs/set_fields.dart`
  Added `suffixStyle` param to `TheUsualTextField`. Extracted `_SetRow` `StatefulWidget` that owns two `FocusNode`s; listens and calls `setState` on focus change; passes `suffixStyle: TextStyle(color: outline when unfocused, onSurfaceVariant when focused)` to each field.

  ## Fix 4 — Bodyweight checkbox label
  Files: `lib/app/widgets/inputs/workout_entry_sheet.dart`
  Changed label from `'Bodyweight'` to `'Estimate set weight based on body weight'`. Wrapped label `Text` in `Expanded`.

  ## Fix 5 — Inline bodyweight hint
  Files: `lib/app/widgets/inputs/workout_entry_sheet.dart`
  Replaced `ScaffoldMessenger.showSnackBar` with `setState(() => _bodyweightHintShown = true)`. Hint renders as `Text(key: Key('bodyweight-hint'))` styled `bodySmall + error color` when `_bodyweightHintShown && widget.bodyWeight == null`.

  ## Test updates
  - `workout_log_section_test.dart`: rename test now taps `Icons.edit_outlined` inside `Key('group-name-push')` before entering text and submitting.
  - `workouts_view_test.dart`: same pencil-tap pattern before entering text.
  - `workout_entry_sheet_test.dart`: SnackBar assertion replaced with `Key('bodyweight-hint')` + `findsNothing` for `SnackBar`.

  ## Full suite
  <!-- paste result here -->
  ```

- [ ] **Step 4: Paste the actual full-suite result into the report under `## Full suite`**
