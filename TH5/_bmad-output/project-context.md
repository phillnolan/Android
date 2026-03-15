---
project_name: 'TH5'
user_name: 'Nguyên'
date: '2026-03-15'
sections_completed: ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'style_rules', 'workflow_rules', 'critical_rules']
status: 'complete'
rule_count: 28
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Framework:** Flutter (Latest compatible with Dart ^3.11.1)
- **Language:** Dart SDK ^3.11.1
- **Design System:** Material Design 3 (Enabled)
- **Key Dependencies:**
  - `cupertino_icons`: ^1.0.8
  - `flutter_lints`: ^6.0.0

## Critical Implementation Rules

### Language-Specific Rules (Dart)

- **Performance:** Always use `const` constructors for widgets where possible.
- **Typing:** Prefer `final` for variables that are not reassigned.
- **Safety:** Ensure null-safety features are fully utilized (Dart 3+).
- **Lints:** Strictly adhere to `flutter_lints` as defined in `analysis_options.yaml`.
- **Imports:** Use package imports (e.g., `import 'package:th5/...'`) instead of relative imports for better consistency.

### Framework-Specific Rules (Flutter)

- **State Management:** Use `setState` for local state transitions. For complex logic, consider separating it into dedicated logic classes.
- **Widget Organization:** Decompose large `build` methods into smaller, reusable sub-widgets.
- **Theming:** Strictly use `Theme.of(context)` for colors and text styles to ensure Material 3 compliance.
- **Navigation:** Use named routes if the application scales beyond a few screens.

### Testing Rules

- **Framework:** Use `flutter_test` for all automated tests.
- **Organization:** Place widget tests in the `test/` directory, following the structure of the `lib/` directory.
- **Widget Testing:** Ensure critical UI interactions (like button taps, text input) are covered by widget tests.
- **Mocks:** When logic becomes complex, use a mocking library (e.g., `mocktail`) to isolate dependencies.
- **Documentation:** Every test case should have a clear, descriptive name explaining the scenario and expected outcome.

### Code Quality & Style Rules

- **Linting:** Must pass `flutter analyze` with zero warnings or errors.
- **Formatting:** Code must be formatted using the standard Dart formatter.
- **Naming:** Follow official Dart style guide: PascalCase for classes, camelCase for members/variables, snake_case for files.
- **Documentation:** Use `///` for all public-facing classes and methods. Add internal comments for non-trivial logic.
- **Organization:** Keep classes focused (Single Responsibility Principle). Move reusable widgets to a `src/widgets/` directory.

### Development Workflow Rules

- **Git Branching:** Use descriptive branch names with prefixes (`feature/`, `bugfix/`, `refactor/`).
- **Commits:** Follow Conventional Commits format for clear version history.
- **Verification:** Always run `flutter analyze` and `flutter test` before proposing any changes.
- **Atomic Changes:** Keep PRs/commits small and focused on a single logical change.

### Critical Don't-Miss Rules

- **Hard-coding:** Avoid hard-coding strings; use constant files or localization for UI text.
- **Performance:** Never perform heavy computations or API calls directly inside the `build` method.
- **Security:** DO NOT commit secrets, API keys, or sensitive credentials to version control. Use environment variables.
- **State Leakage:** Always dispose of `ChangeNotifier`, `StreamController`, or `TextEditingController` in the `dispose` method to prevent memory leaks.
- **Responsiveness:** Ensure widgets are flexible and use `LayoutBuilder` or `MediaQuery` where specific sizing is required for different devices.

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code.
- Follow ALL rules exactly as documented.
- When in doubt, prefer the more restrictive option.
- Update this file if new patterns emerge.

**For Humans:**

- Keep this file lean and focused on agent needs.
- Update when technology stack changes.
- Review quarterly for outdated rules.
- Remove rules that become obvious over time.

Last Updated: 2026-03-15
