export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.flutter/bin"

export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/share/pnpm/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"

export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
export CHROME_EXECUTABLE="chromium"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi
