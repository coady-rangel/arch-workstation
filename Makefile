.PHONY: readme validate doctor release

readme:
	./scripts/build-readme.sh

validate:
	./scripts/validate.sh

doctor:
	./scripts/doctor.sh

release:
	./scripts/release.sh $(FLAGS) $(VERSION)
