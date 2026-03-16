# Sprint Change Proposal: UX Refinement & Polish

**Date:** 2026-03-16
**Status:** Approved by Nguyên

## 1. Issue Summary
Based on initial implementation feedback, several UX friction points and bugs were identified:
1. **Redundant UI in Product Detail:** Cart icon and "Add to Cart" button perform identical actions.
2. **Broken/Crude Notifications:** Success snackbars are unpolished, and the "View Now" button is non-functional.
3. **Missing Checkout Feedback:** Lack of visual celebration/confirmation upon successful order.
4. **Harsh Category Transitions:** Abrupt UI changes when switching product categories from the home banner.

## 2. Impact Analysis
- **PRD:** Updates to User Journeys (Minh & Linh) to reflect refined interactions.
- **Epics:** 
    - **Story 1.3:** Add transition animations for category selection.
    - **Story 2.2:** Refine Product Detail actions and Snackbar logic.
    - **Story 5.1:** Add success feedback loop for checkout completion.
- **Architecture:** No major structural changes, but UI pattern updates for animations and overlays.

## 3. Recommended Approach: Direct Adjustment (Minor Scope)
Address these issues by refining existing widgets and extending current providers.

### Detailed Changes:
- **Product Detail Screen:**
    - Top-right Cart icon -> Navigate to `CartScreen`.
    - Bottom "Add to Cart" -> Open `BottomSheet` selection.
    - Refactor `SnackBar` to include a working "View Now" button linked to the cart route.
- **Home Screen:**
    - Wrap the product grid/list with an `AnimatedSwitcher` or `FadeTransition` triggered by category changes.
- **Checkout Flow:**
    - Introduce a `SuccessOverlay` or dedicated `OrderSuccessScreen` after clearing the cart.

## 4. Implementation Handoff
- **Agent:** Development Team (Gemini CLI)
- **Priority:** High (UX Polish)
- **Success Criteria:** Verified navigation from detail to cart, working snackbar buttons, smooth home transitions, and visual order confirmation.
