# PATH Configuration

# Local binaries
export PATH="$PATH:$HOME/.local/bin"

# Flutter
export PATH="$PATH:$HOME/.flutter/bin"

# Android SDK Platform Tools
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$HOME/Android/Sdk/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
# JetBrains Toolbox
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
# Cargo (Rust)
export PATH="$PATH:$HOME/.cargo/bin"
# Go
export PATH="$PATH:$HOME/go/bin"
# pnpm
export PATH="$PATH:$HOME/.local/share/pnpm/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"

# Environment Variables
# Android Development
export CHROME_EXECUTABLE="google-chrome-stable"
export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
# export CHROME_EXECUTABLE="firefox"

# Wayland Support
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# NPM Configuration (Throws error with nvm)
# export npm_config_prefix="$HOME/.local"

# GTK Theme
# GTK_THEME=Qogir-manjaro-dark

# Telegram (Qt Platform Theme)
# export QT_QPA_PLATFORMTHEME='xdgdesktopportal'

# Java Anti-aliasing and Look & Feel
# export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel ${_JAVA_OPTIONS}"
# export JDK_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
