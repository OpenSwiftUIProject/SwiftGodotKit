# Axolotl SwiftUI sample

This sample embeds a Godot 4.7 game in a SwiftUI container. It has explicit macOS
14 and iOS 17 targets. Both targets consume the local SwiftGodotKit package and
the binary targets declared by that package.

The container shows the score and a **Restart game** action above the Godot
view. The action calls `new_game()` on the Godot `Main` node. The game emits
`score_changed(value)` when the score resets or increases. SwiftUI connects to
this signal and updates its score label. See `App/AxolotlDemoApp.swift` and
`GodotProject/main.gd` for both sides of this exchange.

The SwiftUI container uses `GodotAppView(onReady:)` to find `Main` and connect a
Swift `Callable` to `score_changed`. Its action calls `new_game` on that node:

```swift
let connection = Callable { (value: Int64) in
    // Update SwiftUI state on the main queue.
}
_ = main.connect(signal: "score_changed", callable: connection)
_ = main.call(method: "new_game")
```

The Godot script declares `signal score_changed(value: int)` and emits it after
each score change. The app keeps the `Callable` and disconnects it when the
SwiftUI view disappears.

The game supports keyboard input on macOS and touch or drag input on iOS. Its
source is in `GodotProject`. The committed `Resources/main.pck` includes the
signal and lets the app build without a Godot editor installation.

To regenerate the pack and Xcode project:

```sh
make
```

The pack script uses `/Applications/Godot-47.app` by default. Set `GODOT_APP`
to use a different Godot 4.7 application bundle.

The same app source can run through SwiftPM from the repository root:

```sh
swift run AxolotlDemo
swift run --traits OpenSwiftUI \
  -Xswiftc -target -Xswiftc "$(uname -m)-apple-macosx15.0" AxolotlDemo
```

The second command uses OpenSwiftUI-spm 0.23.1 and requires macOS 15 or later.
With the trait enabled, the sample uses `Text.onTapGesture` for **Restart game**
because this OpenSwiftUI release does not support `Button`. The action stays
inactive until the Godot scene is ready. The macOS OpenSwiftUI scene currently
has a fixed 500 by 300 point content area. See the root README for the Xcode
trait setup and the iOS 18 deployment requirement when using OpenSwiftUI.

To use OpenSwiftUI in Xcode, open `AxolotlDemo-OpenSwiftUI.xcodeproj`, select
the `AxolotlDemo-macOS` scheme and **My Mac**, then press **Command-R**. This
project enables the package trait, links OpenSwiftUI to the app, and sets the
app's compilation condition and deployment target. Use the `AxolotlDemo-iOS`
scheme for an iOS simulator or device.

The project sets `DISABLE_DIAMOND_PROBLEM_DIAGNOSTIC=YES` to prevent Xcode 26.6
from converting shared macro dependencies to dynamic frameworks. Without this
setting, the host tools try to copy the same SwiftSyntax frameworks and the
build fails with `Multiple commands produce`.

The OpenSwiftUI project reuses `project.yml` through `project-openswiftui.yml`.
To regenerate it with XcodeGen 2.46 or later, run:

```sh
make project-openswiftui
```

`AxolotlDemo.xcodeproj` continues to use Apple's SwiftUI.

Build both native SwiftUI destinations:

```sh
make build-macos
make build-ios-simulator
```

For a device build, select an Apple development team in Xcode, choose a
physical iPhone or iPad, and run the `AxolotlDemo-iOS` scheme.

See `GodotProject/LICENSE`, `GodotProject/THIRD_PARTY.md`, and
`GodotProject/fonts/LICENSE.txt` for the licenses and attributions.
