# Python SDK for Azure Quantum Plugins #

For details on how to get started with Azure Quantum, please visit [azure.com/quantum](https://azure.com/quantum).

You can also try our [Quantum Computing Fundamentals](https://aka.ms/learnqc) learning path to get familiar with the basic concepts of quantum computing, build quantum programs, and identify the kind of problems that can be solved.

This folder contains plug-ins to the Python SDKD for Azure Quantum.

## The `qiskit` plugin ##

This package implements an `AzureQuantumProvider` class that supports submitting Qiskit circuits to Azure Quantum hardware targets.

### Example usage ###

```python
from qiskit import QuantumCircuit
from azure.quantum.qiskit import AzureQuantumProvider

# Azure Quantum Provider
# Find your resource ID via portal.azure.com
provider = AzureQuantumProvider(
  resource_id="",
  location="westus"
)

# Show all current supported backends in this workspace:
print([backend.name() for backend in provider.backends()])

# Get IonQ's simulator backend:
simulator_backend = provider.get_backend("ionq.simulator")

# Create a Quantum Circuit acting on the q register
circuit = QuantumCircuit(2, 2)
circuit.name = "Qiskit Sample - Bell circuit"
circuit.h(0)
circuit.cx(0, 1)
circuit.measure([0,1], [0, 1])

# Submit the circuit to run on Azure Quantum
job = simulator_backend.run(circuit, shots=250)
job_id = job.id()
print("Job id", id)

# Get the job results (this method waits for the Job to complete):
result = job.result()
histogram = result.results['histogram']
print("Results histogram", histogram)
```

### Installing with pip ###

```bash
pip install azure-quantum[qiskit]
```

### Development ###

The best way to install all the Python pre-reqs packages is to create a new Conda environment.
Run at the root of the `azure-quantum` directory:

```bash
conda env create -f environment-qiskit.yml
```

Then to activate the environment:

```bash
conda activate azure-quantum-qiskit
```

In case you have created the conda environment a while ago, you can make sure you have the latest versions of all dependencies by updating your environment:

```bash
conda env update -f environment-qiskit.yml --prune
```

#### Install the local development package ####

To install the package in development mode, run the following in the repo's root directory:

```bash
pip install -e azure-quantum[qiskit]
```

## Support and Q&A ##

If you have questions about the Quantum Development Kit and the Q# language, or if you encounter issues while using any of the components of the kit, you can reach out to the quantum team and the community of users in [Stack Overflow](https://stackoverflow.com/questions/tagged/q%23) and in [Quantum Computing Stack Exchange](https://quantumcomputing.stackexchange.com/questions/tagged/q%23) tagging your questions with **q#**.