# Development #

The easiest way to install all the required Python packages is to create a new virtual environment using Conda.
Run at the root of the `azure-quantum` directory:

```bash
conda env create -f environment.yml
```

Then to activate the environment:

```bash
conda activate azurequantum
```

In case you have created the conda environment a while ago, you can make sure you have the latest versions of all dependencies by updating your environment:

```bash
conda env update -f environment.yml --prune
```

## Install the local development package ##

To install the package in development mode, run:

```bash
pip install -e .
```

## Unit tests ##

To run the unit tests, run `pytest` from the root of the `azure-quantum` directory:

```bash
pytest
```

To run the a specific unit test class, run:

```bash
pytest ./tests/unit/test_job.py
```

To run the a specific unit test case, run:

```bash
pytest -k test_job_refresh
```

### Recordings ###

To read more about how to create and update recordings for testing code that interacts with a live API, see the [Unit tests README](./tests/README.md).

## Building the `azure-quantum` Package wheel ##

The Azure Quantum Python SDK uses a standard `setuptools`-based packaging strategy.
To build a platform-independent wheel, run the setup script with `bdist_wheel` instead:

```bash
python setup.py bdist_wheel
```

By default, this will create a `azure-quantum` wheel in `dist/` with the version number set to 0.0.0.1.
To provide a more useful version number, set the `PYTHON_VERSION` environment variable before running `setup.py`.

## Environment Variables ##

In addition to the [common Azure SDK environment variables](https://azure.github.io/azure-sdk/general_azurecore.html#environment-variables), you can also set the following environment variables to change the behaviour of the Azure Quantum SDK for Python:
| Environment Variable             | Description                                                            |
| -------------------------------- | ---------------------------------------------------------------------- |
| AZURE_QUANTUM_PYTHON_APPID       | Prefixes the HTTP User-Agent header with the specified value           |