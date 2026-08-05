#!/usr/bin/env bash
# Clone the agent-skills repository and symlink it as ~/.claude/skills.
set -eo pipefail

REPO_DIR="$HOME/projects/agent-skills"
SKILLS_LINK="$HOME/.claude/skills"

if [ ! -d "$REPO_DIR" ]; then
	git clone https://github.com/advaypakhale/agent-skills "$REPO_DIR"
fi

mkdir -p "$HOME/.claude"

if [ -L "$SKILLS_LINK" ] && [ "$(readlink -f "$SKILLS_LINK")" = "$(readlink -f "$REPO_DIR")" ]; then
	exit 0
fi

if [ -e "$SKILLS_LINK" ]; then
	echo "$SKILLS_LINK exists and is not a symlink to $REPO_DIR; move it aside first" >&2
	exit 1
fi

ln -s "$REPO_DIR" "$SKILLS_LINK"
