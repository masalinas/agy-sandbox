#!/usr/bin/env bash
# Optional first-run configuration for agy (skips color scheme, folder trust and onboarding prompts).
# Enabled at runtime with: docker run -e AGY_AUTOCONFIG=true ...
set -e
 
CFG_DIR="$HOME/.gemini/antigravity-cli"
 
if [ "${AGY_AUTOCONFIG:-false}" = "true" ]; then
    mkdir -p "$CFG_DIR/cache"
 
    # Do not overwrite files that already exist (e.g. when the config dir is a mounted volume)
    if [ ! -f "$CFG_DIR/settings.json" ]; then
        printf '%s\n' '{ "colorScheme": "dark", "modelProvider": "gemini", "trustedWorkspaces": ["/workspace"] }' \
            > "$CFG_DIR/settings.json"
    fi
    if [ ! -f "$CFG_DIR/cache/onboarding.json" ]; then
        printf '%s\n' '{ "consumerOnboardingComplete": true, "enterpriseOnboardingComplete": false, "onboardingComplete": true }' \
            > "$CFG_DIR/cache/onboarding.json"
    fi
fi
 
# Run the requested command (agy, bash, ...)
exec "$@"