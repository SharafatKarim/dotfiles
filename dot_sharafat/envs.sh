################################################################################
# PATH Configuration
################################################################################

# Local binaries
export PATH="$PATH:$HOME/.local/bin"

# Flutter
export PATH="$PATH:$HOME/.flutter/bin"

# Android SDK Platform Tools
export PATH="$PATH:$HOME/Android/Sdk/platform-tools"

# JetBrains Toolbox
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

# Cargo (Rust)
export PATH="$PATH:$HOME/.cargo/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

################################################################################
# Environment Variables
################################################################################

# Android Development
export ANDROID_HOME="$HOME/Android/Sdk"
export CHROME_EXECUTABLE="google-chrome-stable"
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
