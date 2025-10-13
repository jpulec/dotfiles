function dcop
  env DOPPLER_TOKEN_API="$(doppler configs tokens create --project flux-api --config dev api-dev-token --plain --max-age 1m)" \
  DOPPLER_TOKEN_WEB="$(doppler configs tokens create --project flux-web --config dev web-dev-token --plain --max-age 1m)" \
  DOPPLER_TOKEN_WORKER="$(doppler configs tokens create --project flux-worker --config dev worker-dev-token --plain --max-age 1m)" \
  docker-compose up
end
