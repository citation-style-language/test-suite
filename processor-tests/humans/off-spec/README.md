Tests in this folder expect behaviors that aren't defined in the [CSL Specification](https://docs.citationstyles.org/en/stable/specification.html). Each such test
should include a `DESCRIPTION` block describing its particular deviation.

The specific disposition of these tests varies. For example, they may expect behavior that

- should be added to a future version of the specification
- is useful but implemented in a way that needs to be re-worked before it can be added to the specification
- is specific to an internal process of [citeproc-js](https://github.com/Juris-M/citeproc-js) and so may belong among [its local tests](https://github.com/Juris-M/citeproc-js/tree/master/fixtures/local)

CSL Processor authors and testers may omit tests in this folder if their purpose is simply to implement the specification. They may, however, find these tests useful if they also want to match the behavior of existing tools or software written according to these additional tests.