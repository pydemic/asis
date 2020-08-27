#!/bin/sh
set -e

/app/bin/asis eval "Asis.Release.Repo.migrate"
/app/bin/asis eval "Asis.Release.Seeders.Contexts.seed_all load?: true"
/app/bin/asis start
