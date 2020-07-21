web: [[ "$ANYCABLE_DEPLOYMENT" == "true" ]] && bundle exec anycable --server-command="anycable-go" ||  bundle exec rails server -p $PORT -b 0.0.0.0
worker: bundle exec sidekiq
release: rake db:migrate