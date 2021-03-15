SHELL=/bin/bash

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = _build

# User-friendly check for sphinx-build
#ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
#$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
#endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .

clean:
	-rm -f *.pyc README.html MANIFEST
	-rm -rf build dist

install:
	python setup.py install

test:
	python2.7 -m test_jobs
	# python3.3 -m test_jobs
	# python3.4 -m test_jobs
	python3.5 -m test_jobs
	python3.6 -m test_jobs
	python3.7 -m test_jobs
	python3.8 -m test_jobs
	python3.9 -m test_jobs

upload:
	git tag `cat VERSION`
	git push origin --tags
	python3.6 setup.py sdist
	python3.6 -m twine upload --verbose dist/jobspy-`cat VERSION`.tar.gz

docs:
	python -c "import jobs; open('VERSION', 'wb').write(jobs.VERSION);open('README.rst', 'wb').write(jobs.__doc__);"
	cd _docs && $(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html && cd ..
	cd _docs/_build/html/ && zip -r9 ../../../jobs_docs.zip * && cd ../../../
	@echo
	@echo "Build finished."
