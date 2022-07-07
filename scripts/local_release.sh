export SECRET_KEY_BASE="$(mix phx.gen.secret)"
export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/sme_interviews"
MIX_ENV=prod mix release
MIX_ENV=prod APP_NAME=sme_interviews PORT=4000 _build/prod/rel/sme_interviews/bin/sme_interviews start