log = echo
l = [TFA]

.SILENT:

generate: clean
	${log} ${l} Generating sources...
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	${log} ${l} Finished generating sources!


generate-icons:
	flutter pub run icon_font_generator --from=assets/icons --class-name=TnsIcons --out-font=assets/fonts/TnsIcons.ttf --out-flutter=lib/core/icons.g.dart


clean:	
	${log} ${l} Cleaning project...
	flutter clean
	${log} ${l} Finished cleaning project!


android: generate
	${log} ${l} Building android...
	flutter build appbundle
	${log} ${l} Finished building android!


ios: generate
	${log} ${l} Building ios...
	flutter pub get
	cd ios; \
	arch -x86_64 pod install --repo-update; \
	cd ..
	flutter build ipa
	${log} ${l} Finished building ios!


web: generate
	${log} ${l} Building web...
	flutter build web --source-maps
	${log} ${l} Finished building web!
