# Pyomo - Other

**Pages:** 36

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/boxplot.png

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html#using-pip

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#contents

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#contents

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/gdpopt_flowchart.png

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/reduce_points_demo.png

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/pairwise_plot_CI.png

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html#using-conda

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html#conditional-dependencies

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#citing-pyomo

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html#installation

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## Related Packages — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/related_packages.html

**Contents:**
- Related Packages
- Modeling Extensions
- Solvers and Solution Strategies
- Domain-Specific Applications

The following is list of software packages that utilize or build off of Pyomo. This is certainly not a comprehensive list. [1]

https://github.com/coramin/coramin

A suite of tools for developing MINLP algorithms

https://github.com/or-fusion/pao

Formulation and solution of multilevel optimization problems

https://github.com/cog-imperial/OMLT

Represent machine learning models within an optimization formulation

https://github.com/cog-imperial/galini

An extensible, Python-based MIQCQP Solver

https://github.com/pyomo/mpi-sppy

Parallel solution of stochastic programming problems

https://github.com/parapint/parapint

Parallel solution of structured NLPs.

https://github.com/cog-imperial/suspect

FBBT and convexity detection

https://github.com/sandialabs/chama

Sensor placement optimization

https://github.com/grid-parity-exchange/egret

Formulation and solution of unit commitment and optimal power flow problems

https://github.com/idaes/idaes-pse

Institute for the Design of Advanced Energy Systems

https://github.com/grid-parity-exchange/prescient

Production Cost Model for power systems simulation and analysis

https://github.com/pypsa/pypsa

Python for Power system Analysis

Please note that the Pyomo team does not evaluate or endorse the packages listed above.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/PyomoNewBlue3.png

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#pyomo-resources

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/communities_8pp.png

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html#installation-with-cython

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/Pyomo-DAE-150.png

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/PP.png

---

## Common Warnings/Errors — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/errors.html

**Contents:**
- Common Warnings/Errors
- Warnings
  - W1001: Setting Var value not in domain
  - W1002: Setting Var value outside the bounds
  - W1003: Unexpected RecursionError walking an expression tree
- Errors
  - E2001: Variable domains must be an instance of a Pyomo Set

When setting Var values (by either calling Var.set_value() or setting the value attribute), Pyomo will validate the incoming value by checking that the value is in the Var.domain. Any values not in the domain will generate this warning:

Users can bypass all domain validation by setting the value using:

When setting Var values (by either calling set_value() or setting the value attribute), Pyomo will validate the incoming value by checking that the value is within the range specified by Var.bounds. Any values outside the bounds will generate this warning:

Users can bypass all domain validation by setting the value using:

Pyomo leverages a recursive walker (the StreamBasedExpressionVisitor) to traverse (walk) expression trees. For most expressions, this recursive walker is the most efficient. However, Python has a relatively shallow recursion limit (generally, 1000 frames). The recursive walker is designed to monitor the stack depth and cleanly switch to a nonrecursive walker before hitting the stack limit. However, there are two (rare) cases where the Python stack limit can still generate a RecursionError exception:

Starting the walker with fewer than pyomo.core.expr.visitor.RECURSION_LIMIT available frames.

Callbacks that require more than 2 * pyomo.core.expr.visitor.RECURSION_LIMIT frames.

The (default) recursive walker will catch the exception and restart the walker from the beginning in non-recursive mode, issuing this warning. The caution is that any partial work done by the walker before the exception was raised will be lost, potentially leaving the walker in an inconsistent state. Users can avoid this by

avoiding recursive callbacks

restructuring the system design to avoid triggering the walker with few available stack frames

directly calling the walk_expression_nonrecursive() walker method

Variable domains are always Pyomo Set or RangeSet objects. This includes global sets like Reals, Integers, Binary, NonNegativeReals, etc., as well as model-specific Set instances. The Var.domain setter will attempt to convert assigned values to a Pyomo Set, with any failures leading to this warning (and an exception from the converter):

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#pyomo-documentation-release

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/pairwise_plot_LR.png

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#pyomo-resources

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/installation.html

**Contents:**
- Installation
- Using CONDA
- Using PIP
- Conditional Dependencies
- Installation with Cython

Pyomo currently supports the following versions of Python:

CPython: 3.10, 3.11, 3.12, 3.13, 3.14

At the time of the first Pyomo release after the end-of-life of a minor Python version, Pyomo will remove testing for that Python version.

We recommend installation with conda, which is included with the Anaconda distribution of Python. You can install Pyomo in your system Python installation by executing the following in a shell:

Optimization solvers are not installed with Pyomo, but some open source optimization solvers can be installed with conda as well:

The standard utility for installing Python packages is pip. You can install Pyomo in your system Python installation by executing the following in a shell:

Extensions to Pyomo, and many of the contributions in pyomo.contrib, often have conditional dependencies on a variety of third-party Python packages including but not limited to: matplotlib, networkx, numpy, openpyxl, pandas, pint, pymysql, pyodbc, pyro4, scipy, sympy, and xlrd.

A full list of optional dependencies can be found in Pyomo’s pyproject.toml under the [project.optional-dependencies] table. They can be displayed by running:

Pyomo extensions that require any of these packages will generate an error message for missing dependencies upon use.

When using pip, all conditional dependencies can be installed at once using the following command:

When using conda, many of the conditional dependencies are included with the standard Anaconda installation.

You can check which Python packages you have installed using the command conda list or pip list. Additional Python packages may be installed as needed.

Users can opt to install Pyomo with cython initialized.

This can only be done via pip or from source.

Installation via pip or from source is done the same way - using environment variables. On Linux/MacOS:

From source (recommended for advanced users only):

---

## Abstract Versus Concrete Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/pyomo_overview/abstract_concrete.html

**Contents:**
- Abstract Versus Concrete Models

A mathematical model can be defined using symbols that represent data values. For example, the following equations represent a linear program (LP) to find optimal values for the vector \(x\) with parameters \(n\) and \(b\), and parameter vectors \(a\) and \(c\):

As a convenience, we use the symbol \(\forall\) to mean “for all” or “for each.”

We call this an abstract or symbolic mathematical model since it relies on unspecified parameter values. Data values can be used to specify a model instance. The AbstractModel class provides a context for defining and initializing abstract optimization models in Pyomo when the data values will be supplied at the time a solution is to be obtained.

In many contexts, a mathematical model can and should be directly defined with the data values supplied at the time of the model definition. We call these concrete mathematical models. For example, the following LP model is a concrete instance of the previous abstract model:

The ConcreteModel class is used to define concrete optimization models in Pyomo.

Python programmers will probably prefer to write concrete models, while users of some other algebraic modeling languages may tend to prefer to write abstract models. The choice is largely a matter of taste; some applications may be a little more straightforward using one or the other.

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#pyomo-documentation-release

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/FIM_sensitivity.png

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#contributing-to-pyomo

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#contributing-to-pyomo

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.9.5 — Pyomo 6.9.5 documentation

**URL:** https://pyomo.readthedocs.io/#related-packages

**Contents:**
- Pyomo Documentation 6.9.5
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#related-packages

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## Pyomo Documentation 6.10.0.dev0 — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/#citing-pyomo

**Contents:**
- Pyomo Documentation 6.10.0.dev0
- About Pyomo
- Contents
- Pyomo Resources
- Contributing to Pyomo
- Related Packages
- Citing Pyomo

Pyomo is a Python-based open-source software package that supports a diverse set of optimization capabilities for formulating, solving, and analyzing optimization models.

A core capability of Pyomo is modeling structured optimization applications. Pyomo can be used to define general symbolic problems, create specific problem instances, and solve these instances using commercial and open-source solvers.

Pyomo development is hosted at GitHub:

https://github.com/Pyomo/pyomo

See the Pyomo Forum for online discussions of Pyomo or to ask a question:

http://groups.google.com/group/pyomo-forum/

Ask a question on StackOverflow using the #pyomo tag:

https://stackoverflow.com/questions/ask?tags=pyomo

Additional Pyomo tutorials and examples can be found at the following links:

Pyomo — Optimization Modeling in Python ([PyomoBookIII])

Pyomo Workshop Slides and Exercises

Prof. Jeffrey Kantor’s Pyomo Cookbook

The companion notebooks for Hands-On Mathematical Optimization with Python

Interested in contributing code or documentation to the project? Check out our Contribution Guide

Pyomo is a key dependency for a number of other software packages for specific domains or customized solution strategies. A non-comprehensive list of Pyomo-related packages may be found here.

If you use Pyomo in your work, please cite:

Bynum, Michael L., Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Springer, 2021.

Additionally, several Pyomo capabilities and subpackages are described in further detail in separate Publications.

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/flowchart.png

---

## Simple Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/pyomo_overview/simple_examples.html

**Contents:**
- Simple Models
- A Simple Concrete Pyomo Model
- A Simple Abstract Pyomo Model
- Symbolic Index Sets
- Solving the Simple Examples

It is possible to get the same flexible behavior from models declared to be abstract and models declared to be concrete in Pyomo; however, we will focus on a straightforward concrete example here where the data is hard-wired into the model file. Python programmers will quickly realize that the data could have come from other sources.

Given the following model from the previous section:

This can be implemented as a concrete model as follows:

Although rule functions can also be used to specify constraints and objectives, in this example we use the expr option that is available only in concrete models. This option gives a direct specification of the expression.

We repeat the abstract model from the previous section:

One way to implement this in Pyomo is as shown as follows:

Python is interpreted one line at a time. A line continuation character, \ (backslash), is used for Python statements that need to span multiple lines. In Python, indentation has meaning and must be consistent. For example, lines inside a function definition must be indented and the end of the indentation is used by Python to signal the end of the definition.

We will now examine the lines in this example. The first import line is required in every Pyomo model. Its purpose is to make the symbols used by Pyomo known to Python.

The declaration of a model is also required. The use of the name model is not required. Almost any name could be used, but we will use the name model in most of our examples. In this example, we are declaring that it will be an abstract model.

We declare the parameters \(m\) and \(n\) using the Pyomo Param component. This component can take a variety of arguments; this example illustrates use of the within option that is used by Pyomo to validate the data value that is assigned to the parameter. If this option were not given, then Pyomo would not object to any type of data being assigned to these parameters. As it is, assignment of a value that is not a non-negative integer will result in an error.

Although not required, it is convenient to define index sets. In this example we use the RangeSet component to declare that the sets will be a sequence of integers starting at 1 and ending at a value specified by the the parameters model.m and model.n.

The coefficient and right-hand-side data are defined as indexed parameters. When sets are given as arguments to the Param component, they indicate that the set will index the parameter.

The next line that is interp

*[Content truncated]*

---

## 

**URL:** https://pyomo.readthedocs.io/en/latest/_images/communities_decode_1.png

---
