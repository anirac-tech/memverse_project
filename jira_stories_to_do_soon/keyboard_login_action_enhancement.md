# JIRA Ticket: Custom "Login" Keyboard Action Enhancement

**Priority**: Low  
**Type**: Enhancement  
**Component**: Authentication/UI  
**Labels**: keyboard, ui-enhancement, cross-platform

## Summary

Implement custom "Login" keyboard action button using keyboard_actions package for consistent
cross-platform experience

## Description

Currently, the login form uses `TextInputAction.go` which shows "Go" on the keyboard action button.
For a more polished and branded experience, we should consider implementing a custom "Login" button
that appears on the keyboard across both Android and iOS platforms.

## Current State

- Password field uses `TextInputAction.go`
- Shows generic "Go" text on keyboard action button
- Functional but not branded/customized

## Proposed Enhancement

Use the `keyboard_actions` package from pub.dev to:

- Display "Login" text on the keyboard action button
- Ensure consistent appearance across Android and iOS
- Provide a more intuitive user experience
- Match app branding and terminology

## Benefits

- **Branding Consistency**: "Login" text matches the actual Login button
- **User Experience**: More intuitive than generic "Go"
- **Cross-Platform**: Consistent behavior on Android and iOS
- **Professional Polish**: Shows attention to detail

## Technical Implementation

1. Add `keyboard_actions: ^3.4.4` to pubspec.yaml
2. Wrap login form with `KeyboardActions` widget
3. Configure custom action for password field
4. Test on both Android and iOS devices

## Acceptance Criteria

- [ ] Keyboard shows "Login" instead of "Go" on password field
- [ ] Consistent appearance on Android and iOS
- [ ] Tapping keyboard "Login" button submits form
- [ ] No regression in existing login functionality
- [ ] Visual design matches app theme

## Priority Justification

**Low Priority** because:

- Current implementation is functional
- This is a cosmetic/UX enhancement
- No blocking user issues
- Can be implemented in future sprint when capacity allows

## Related Links

- [keyboard_actions package](https://pub.dev/packages/keyboard_actions)
- Current login implementation: `lib/src/features/auth/presentation/login_page.dart`

## Estimated Effort

- Development: 2-4 hours
- Testing: 1-2 hours
- Total: 0.5 story points