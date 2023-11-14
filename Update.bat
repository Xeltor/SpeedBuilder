@echo off
ECHO Storing local changes.
git stash

ECHO Pulling git updates.
git pull

ECHO Reapplying local changes.
git stash pop

pause
