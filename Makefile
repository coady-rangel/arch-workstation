.PHONY: readme validate doctor

readme:
	./scripts/build-readme.sh

validate:
	./scripts/validate.sh

doctor:
	./scripts/doctor.sh
