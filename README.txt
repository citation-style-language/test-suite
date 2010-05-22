Standard CSL Test Fixtures

This is the standard test bundle for use in CSL processor and style
development.  Test fixtures are contained in the three subdirectories:

  processor-tests
  style-tests
  metadata-tests

Of the three, only processor tests are available at this time.
The test fixtures are distributed in human-readable form.  To
produce the machine-readable JSON versions of the test fixtures,
run the ./processor.py script with the -g option.  The first
time the script is run, this will create a configuration file
at ./config/processor.cnf.  To validate the CSL code contained
in the fixtures use the -c option.  Validation requires the
jing utility:

  http://www.thaiopensource.com/relaxng/jing.html

The paths to the jing module and the CSL 1.0 schema can be
set in the configuration file.

For the present, documentation of the layout and operation
of the human-readable fixture files can be found in the
citeproc-js manual:

  http://gsl-nagoya-u.net/http/pub/citeproc-doc.html#test-suite

Enjoy.

Frank Bennett
Nagoya
