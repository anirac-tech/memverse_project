# Firebender Rules for Maestro Testing with Flutter

## 🔥 FIREBENDER RULES - NEVER BREAK THESE

### Rule 1: ALWAYS Use Semantic Identifiers for Text Fields, Text for Buttons

- ✅ Text Fields: `Semantics(identifier: 'textUsername', child: TextFormField())`
- ✅ Text Fields: Maestro uses `id: "textUsername"`
- ✅ Buttons: Can use `text: "Login"` for simple access
- ❌ NEVER use text-based matching for text field input
- ❌ NEVER rely on fragile selectors for critical input elements

### Key Principle: Text fields need reliable IDs, buttons can use text labels

### Rule 2: ALWAYS Test After Every Change

- ✅ Run `maestro test` after each modification
- ✅ Verify semantic identifiers are working with `maestro studio`
- ✅ Check screenshots in debug output
- ❌ NEVER assume changes work without testing

### Rule 3: ALWAYS Use Environment Variables

- ✅ `env: USERNAME: ${MEMVERSE_USERNAME}`
- ✅ Pass variables: `MEMVERSE_USERNAME=value maestro test`
- ❌ NEVER hardcode credentials in tests

### Rule 4: ALWAYS Use Correct Maestro Commands

- ✅ `tapOn:` not `tap:`
- ✅ `waitForAnimationToEnd` not `wait:`
- ✅ Proper YAML structure with `---` separator
- ❌ NEVER guess command syntax

### Rule 5: ALWAYS Use Correct App Package Name

- ✅ Check `android/app/build.gradle` for applicationId
- ✅ Verify with `adb shell pm list packages | grep memverse`
- ❌ NEVER use example package names

### Rule 6: ALWAYS Hot Restart After Semantic Changes

- ✅ `flutter run --hot` or full restart after semantic identifier changes
- ✅ Allow app to fully load before testing
- ❌ NEVER test without applying changes

## 🧪 TESTING CHECKLIST

### Pre-Test Setup

- [ ] App installed and running on device
- [ ] Semantic identifiers properly implemented in Flutter code
- [ ] Hot restart completed
- [ ] Environment variables set

### During Test Execution

- [ ] Each step passes individually
- [ ] Screenshots show expected UI state
- [ ] Error messages are clear and actionable
- [ ] Debug output provides useful information

### Post-Test Analysis

- [ ] Review all screenshots in debug folder
- [ ] Verify semantic tree with accessibility inspector
- [ ] Document what works and what doesn't
- [ ] Update test based on findings

## 🎯 SEMANTIC IDENTIFIER NAMING CONVENTION

- Text fields: `textUsername`, `textPassword`, `textEmail`
- Buttons: `buttonLogin`, `buttonSubmit`, `buttonCancel`
- Labels: `labelTitle`, `labelError`, `labelSuccess`
- Images: `imageProfile`, `imageLogo`, `imageIcon`

## ⚡ RAPID TESTING WORKFLOW

1. **Code Change** → Hot restart app
2. **Maestro Test** → `maestro test flow.yaml`
3. **Check Results** → Screenshots + logs
4. **Fix Issues** → Repeat cycle
5. **Success** → Document working approach

## 🚨 NEVER DO THIS

- Don't test without hot restart after semantic changes
- Don't use text matching for critical interactions
- Don't hardcode credentials
- Don't ignore error messages
- Don't skip screenshot verification
- Don't assume previous approach still works

Following these rules ensures reliable, maintainable Maestro tests that work consistently.
