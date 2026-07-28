.PHONY: help get gen analyze format test test-coverage build-apk build-bundle clean

help: ## Hien thi danh sach cac lenh
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

get: ## Cai dat dependencies
	flutter pub get

gen: ## Sinh code (Isar models)
	dart run build_runner build --delete-conflicting-outputs

analyze: ## Phan tich code (lint)
	flutter analyze --fatal-infos

format: ## Dinh dang code
	dart format .

format-check: ## Kiem tra dinh dang (khong thay doi file)
	dart format --set-exit-if-changed .

test: ## Chay tat ca tests
	flutter test

test-coverage: ## Chay tests voi coverage report
	flutter test --coverage

build-apk: ## Build APK release
	flutter build apk --release

build-bundle: ## Build App Bundle (Google Play)
	flutter build appbundle --release

clean: ## Xoa build artifacts
	flutter clean
	dart run build_runner clean

check: analyze format-check test ## Kiem tra toan bo truoc khi push (lint + format + test)
