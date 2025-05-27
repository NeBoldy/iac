#!/usr/bin/env bash

cd .git/hooks
SOURCE=../../scripts/git_hooks/
for hook in $(ls "$SOURCE"); do
    # If the file does not exist here OR the diff between the two files has any lines, then we want to update the hook.
    if [ ! -f "./$hook" ] || [[ $(diff "$SOURCE/$hook" "./$hook" | wc -l) -ge 1 ]]; then

        if [ -f "./$hook" ]; then
            echo "Updating $hook"
            rm "./$hook"
        else
            echo "Adding $hook"
        fi

        ln -s "$SOURCE/$hook" ./
        chmod a+x "./$hook"
    fi
done
