PODSROOT=./Pods

bootstrap: install
	brew update

# installation
install: bundle_install pod_install
pod_install:
	bundle exec pod install
bundle_install:
	bundle install --path=vendor/bundle --jobs 4 --retry 3

pod_deintegrate:
	bundle exec pod deintegrate
