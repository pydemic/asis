#!/bin/sh
set -e

/app/bin/asis eval "Asis.Release.Repo.migrate"
/app/bin/asis start
