web: [[ "$ANYCABLE_DEPLOYMENT" == "true" ]] && bundle exec anycable --server-command="anycable-go --port $PORT --host 0.0.0.0" ||  bundle exec rails server -p $PORT -b 0.0.0.0
worker: bundle exec sidekiq
release: rake db:migrate