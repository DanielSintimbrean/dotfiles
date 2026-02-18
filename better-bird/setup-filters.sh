#!/usr/bin/env bash
# Symlink Thunderbird msgFilterRules.dat from dotfiles into the active profile.
# If the profile already has filter rules, they are copied into dotfiles first
# (so the working version is what gets git-persisted).

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
FILTER_FILE="msgFilterRules.dat"
DOTFILES_FILTER="$DOTFILES_DIR/$FILTER_FILE"
THUNDERBIRD_DIR="$HOME/.thunderbird"

# --- helpers ----------------------------------------------------------------

die() { echo "error: $*" >&2; exit 1; }

find_default_profile() {
    [[ -d "$THUNDERBIRD_DIR" ]] \
        || die "Thunderbird directory not found at $THUNDERBIRD_DIR. Install and run Thunderbird at least once."

    local profiles_ini="$THUNDERBIRD_DIR/profiles.ini"
    [[ -f "$profiles_ini" ]] \
        || die "profiles.ini not found. Run Thunderbird at least once to create a profile."

    # Prefer the [Install*] section's Default key (set by Thunderbird itself).
    local profile_path=""
    local in_install=false

    while IFS='=' read -r key value; do
        key="${key// /}"
        value="${value// /}"
        if [[ "$key" == \[Install* ]]; then
            in_install=true
        elif [[ "$key" == \[* ]]; then
            in_install=false
        elif $in_install && [[ "$key" == "Default" ]]; then
            profile_path="$value"
            break
        fi
    done < "$profiles_ini"

    # Fallback: first profile with Default=1.
    if [[ -z "$profile_path" ]]; then
        local current_path=""
        while IFS='=' read -r key value; do
            key="${key// /}"
            value="${value// /}"
            if [[ "$key" == "Path" ]]; then
                current_path="$value"
            elif [[ "$key" == "Default" && "$value" == "1" && -n "$current_path" ]]; then
                profile_path="$current_path"
                break
            elif [[ "$key" == \[* ]]; then
                current_path=""
            fi
        done < "$profiles_ini"
    fi

    [[ -n "$profile_path" ]] \
        || die "Could not determine the default Thunderbird profile from profiles.ini."

    local full="$THUNDERBIRD_DIR/$profile_path"
    [[ -d "$full" ]] \
        || die "Profile directory $full does not exist. Run Thunderbird at least once."

    echo "$full"
}

# Find every msgFilterRules.dat inside the profile (Mail/ and ImapMail/ dirs).
find_filter_files() {
    local profile="$1"
    find "$profile" -maxdepth 3 -name "$FILTER_FILE" -not -type l 2>/dev/null
}

link_filter() {
    local target="$1"

    if [[ -L "$target" ]]; then
        local current
        current="$(readlink -f "$target")"
        if [[ "$current" == "$DOTFILES_FILTER" ]]; then
            echo "  already linked: $target -> $DOTFILES_FILTER"
            return
        fi
        echo "  removing stale symlink: $target -> $current"
        rm "$target"
    elif [[ -f "$target" ]]; then
        echo "  backing up profile filters into dotfiles (will be git-persisted)"
        cp "$target" "$DOTFILES_FILTER"
        rm "$target"
    fi

    ln -s "$DOTFILES_FILTER" "$target"
    echo "  linked: $target -> $DOTFILES_FILTER"
}

# --- main -------------------------------------------------------------------

echo "==> Finding default Thunderbird profile..."
PROFILE="$(find_default_profile)"
echo "    profile: $PROFILE"

echo "==> Searching for existing $FILTER_FILE in profile..."
mapfile -t existing < <(find_filter_files "$PROFILE")

if [[ ${#existing[@]} -gt 0 ]]; then
    echo "    found ${#existing[@]} filter file(s)"
    for f in "${existing[@]}"; do
        echo "==> Linking $f"
        link_filter "$f"
    done
else
    echo "    no existing filter files found in profile"
    echo ""
    echo "    Thunderbird stores msgFilterRules.dat per mail account inside"
    echo "    ImapMail/<server>/ or Mail/<server>/ directories."
    echo ""
    echo "    Either:"
    echo "      1. Set up a mail account in Thunderbird, create at least one filter,"
    echo "         then re-run this script."
    echo "      2. Specify the target path manually:"
    echo "         $0 <path-inside-profile>"
    echo ""

    # Allow passing a manual target relative to the profile.
    if [[ ${1:-} ]]; then
        TARGET="$PROFILE/$1/$FILTER_FILE"
        mkdir -p "$(dirname "$TARGET")"
        echo "==> Linking $TARGET"
        link_filter "$TARGET"
    fi
fi

echo "==> Done."
