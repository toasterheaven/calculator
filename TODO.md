# TODO Items

## To complete MVP

X. Repeated = press
    * Store last value and last operator to process.
    * If any key is pressed basically, the last items need to be cleared until = is next pressed.
1. Fix remove trailing decimal 0 issues
2. UI Design
    * Use light and dark mode UI artifacts (much easier on initial implementation)
    * Possibly use blur effect on decimal key if value contains decimal
    * Make button layout to be fully resizable (& work with split screen mode)


## Future items

1. Do calculation processing outside of main thread to ensure UI reacts
2. Disable / Enable UI components while calculation processing
3. Store last value if app is closed. State var items may do this already
4. Create full range of test to ensure functionality as source changes
5. Create deployment process with GitHub actions
    * Integrate with developer.apple.com and TestFlight


