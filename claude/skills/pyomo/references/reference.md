# Pyomo - Reference

**Pages:** 51

---

## Piecewise Function Library — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/piecewise/index.html

**Contents:**
- Piecewise Function Library

---

## Topical Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/index.html

**Contents:**
- Topical Reference

Pyomo is being increasingly used as a library to support Python scripts. This section describes library APIs for key elements of Pyomo’s core library. This documentation serves as a reference for both (1) Pyomo developers and (2) advanced users who are developing Python scripts using Pyomo.

Pyomo is under active ongoing development. The following API documentation describes Beta functionality.

---

## CPLEXPersistent — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/cplex_persistent.html

**Contents:**
- CPLEXPersistent

pyomo.solvers.plugins.solvers.cplex_persistent.CPLEXPersistent(**kwds)

A class that provides a persistent interface to Cplex.

---

## The Kernel Library API Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/index.html

**Contents:**
- The Kernel Library API Reference
- Modeling Components:
- Base API:
- Containers:

Models built with pyomo.kernel components are not yet compatible with pyomo extension modules (e.g., PySP, pyomo.dae, pyomo.gdp).

---

## Model Data Management — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/data/index.html

**Contents:**
- Model Data Management

An object that manages loading and storing data from external data sources. This object interfaces to plugins that manipulate the data in a manner that is dependent on the data format.

Internally, the data in a DataPortal object is organized as follows:

All data is associated with a symbol name, which may be indexed, and which may belong to a namespace. The default namespace is None.

model – The model for which this data is associated. This is used for error checking (e.g. object names must exist in the model, set dimensions must match, etc.). Default is None.

filename (str) – A file from which data is loaded. Default is None.

data_dict (dict) – A dictionary used to initialize the data in this object. Default is None.

Return the specified data value.

If a single argument is given, then this is the symbol name:

If a two arguments are given, then the first is the namespace and the second is the symbol name:

*args (str) – A tuple of arguments.

If a single argument is given, then the data associated with that symbol in the namespace None is returned. If two arguments are given, then the data associated with symbol in the given namespace is returned.

Set the value of name with the given value.

name (str) – The name of the symbol that is set.

value – The value of the symbol.

Construct a data manager object that is associated with the input source. This data manager is used to process future data imports and exports.

filename (str) – A filename that specifies the data source. Default is None.

server (str) – The name of the remote server that hosts the data. Default is None.

using (str) – The name of the resource used to load the data. Default is None.

Other keyword arguments are passed to the data manager object.

Return the data associated with a symbol and namespace

name (str) – The name of the symbol that is returned. Default is None, which indicates that the entire data in the namespace is returned.

namespace (str) – The name of the namespace that is accessed. Default is None.

If name is None, then the dictionary for the namespace is returned. Otherwise, the data associated with name in given namespace is returned. The return value is a constant if None if there is a single value in the symbol dictionary, and otherwise the symbol dictionary is returned.

Close the data manager object that is associated with the input source.

Return an iterator of (name, value) tuples from the data in the specified namespace.

The next (name, value) tuple

*[Content truncated]*

---

## Library Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/api/pyomo.html

**Contents:**
- Library Reference

This package contains archived modules that are no longer part of the official Pyomo API.

Preview capabilities through pyomo.__future__

Pyomo: Python Optimization Modeling Objects

---

## Expression Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/index.html

**Contents:**
- Expression Reference

---

## Accessing preview features — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/future.html

**Contents:**
- Accessing preview features
- Preview capabilities through pyomo.__future__

This module provides a uniform interface for gaining access to future (“preview”) capabilities that are either slightly incompatible with the current official offering, or are still under development with the intent to replace the current offering.

Currently supported __future__ offerings include:

solver_factory([version])

Get (or set) the active implementation of the SolverFactory

---

## Variables — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/variable.html

**Contents:**
- Variables
- Summary

pyomo.core.kernel.variable.variable([...])

pyomo.core.kernel.variable.variable_tuple(...)

A tuple-style container for objects with category type IVariable

pyomo.core.kernel.variable.variable_list(...)

A list-style container for objects with category type IVariable

pyomo.core.kernel.variable.variable_dict(...)

A dict-style container for objects with category type IVariable

---

## Publications — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/bibliography.html#pyomobookiii

**Contents:**
- Publications
- Bibliography

These publications describe various Pyomo capabilitites or subpackages:

William E. Hart, Jean-Paul Watson, David L. Woodruff. “Pyomo: modeling and solving mathematical programs in Python,” Mathematical Programming Computation, 3(3), August 2011.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff. Pyomo – Optimization Modeling in Python, Springer Optimization and Its Applications, Vol 67. Springer. 2012.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff, Gabriel A. Hackebeil, Bethany L. Nicholson, John D. Siirola. Pyomo - Optimization Modeling in Python, 2nd Edition. Springer Optimization and Its Applications, Vol 67. Springer. 2017.

Michael L. Bynum, Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Vol. 67. Springer. 2021. DOI 10.1007/978-3-030-68928-5

Bethany Nicholson, John D. Siirola, Jean-Paul Watson, Victor M. Zavala, and Lorenz T. Biegler. “pyomo.dae: a modeling and automatic discretization framework for optimization with differential and algebraic equations”, Mathematical Programming Computation, 10(2), 187-223. 2018.

Katherine A. Klise, Bethany L. Nicholson, Andrea Staid, David L.Woodruff. “Parmest: Parameter Estimation Via Pyomo.” Computer Aided Chemical Engineering, 47, 41-46. 2019.

Qi Chen, Emma S. Johnson, David E. Bernal, Romeo Valentin, Sunjeev Kale, Johnny Bates, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: an ecosystem for logic based modeling and optimization development.” Optimization and Engineering, 1-36. 2021. DOI 10.1007/s11081-021-09601-7

Qi Chen, Emma S. Johnson, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: Disjunctive Models in Python.” In M. R. Eden, M. G. Ierapetritou, and G. P. Towler (Eds.), Proceedings of the 13th International Symposium on Process Systems Engineering, 889–894, 2018. DOI 10.1016/B978-0-444-64241-7.50143-9

http://www.aimms.com/

O. Abel and W. Marquardt, “Scenario-integrated modeling and optimization of dynamic systems”, AIChE Journal, 46(4). 2000.

E. Balas. “Disjunctive Programming and a Hierarchy of Relaxations for Discrete Optimization Problems”, SIAM Journal on Algebraic Discrete Methods, 6(3), 466–486, 1985. DOI 10.1137/0606047

E. Balas and R. Jeroslow. “Canonical Cuts on the Unit Hypercube”, SIAM Journal on Applied Mathematics 23(1), 61-19, 1972. DOI 10.1137/0123007

H. Djelassi. “Discretization-based al

*[Content truncated]*

---

## Conic Constraints — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/conic.html

**Contents:**
- Conic Constraints
- Summary

A collection of classes that provide an easy and performant way to declare conic constraints. The Mosek solver interface includes special handling of these objects that recognizes them as convex constraints. Other solver interfaces will treat these objects as general nonlinear or quadratic expressions, and may or may not have the ability to identify their convexity.

pyomo.core.kernel.conic.quadratic(r, x)

A quadratic conic constraint of the form:

pyomo.core.kernel.conic.rotated_quadratic(r1, ...)

A rotated quadratic conic constraint of the form:

pyomo.core.kernel.conic.primal_exponential(r, ...)

A primal exponential conic constraint of the form:

pyomo.core.kernel.conic.primal_power(r1, r2, ...)

A primal power conic constraint of the form:

pyomo.core.kernel.conic.dual_exponential(r, ...)

A dual exponential conic constraint of the form:

pyomo.core.kernel.conic.dual_power(r1, r2, ...)

A dual power conic constraint of the form:

---

## HiGHS — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.highs.html

**Contents:**
- HiGHS

pyomo.contrib.appsi.solvers.highs.HighsResults(solver)

pyomo.contrib.appsi.solvers.highs.Highs([...])

---

## Cplex — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.cplex.html

**Contents:**
- Cplex

---

## Utilities to Build Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/building.html

**Contents:**
- Utilities to Build Expressions

pyomo.core.util.prod(terms)

A utility function to compute the product of a list of terms.

pyomo.core.util.quicksum(args[, start, linear])

A utility function to compute a sum of Pyomo expressions.

pyomo.core.util.sum_product(*args, **kwds)

A utility function to compute a generalized dot product.

pyomo.core.util.summation(*args, **kwds)

An alias for sum_product

pyomo.core.util.dot_product(*args, **kwds)

An alias for sum_product

---

## Multi-variate Piecewise Functions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/piecewise/piecewise_nd.html

**Contents:**
- Multi-variate Piecewise Functions
- Summary

pyomo.core.kernel.piecewise_library.transforms_nd.piecewise_nd(...)

Models a multi-variate piecewise linear function.

pyomo.core.kernel.piecewise_library.transforms_nd.PiecewiseLinearFunctionND(...)

A multi-variate piecewise linear function

pyomo.core.kernel.piecewise_library.transforms_nd.TransformedPiecewiseLinearFunctionND(f)

Base class for transformed multi-variate piecewise linear functions

pyomo.core.kernel.piecewise_library.transforms_nd.piecewise_nd_cc(...)

Discrete CC multi-variate piecewise representation

---

## Cbc — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.cbc.html

**Contents:**
- Cbc

pyomo.contrib.appsi.solvers.cbc.CbcConfig([...])

pyomo.contrib.appsi.solvers.cbc.Cbc([...])

---

## Gurobi — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.gurobi.html

**Contents:**
- Gurobi
- Handling Gurobi licenses through the APPSI interface

In order to obtain performance benefits when re-solving a Pyomo model with Gurobi repeatedly, Pyomo has to keep a reference to a gurobipy model between calls to solve(). Depending on the Gurobi license type, this may “consume” a license as long as any APPSI-Gurobi interface exists (i.e., has not been garbage collected). To release a Gurobi license for other processes, use the release_license() method as shown below. Note that release_license() must be called on every instance for this to actually release the license. However, releasing the license will delete the gurobipy model which will have to be reconstructed from scratch the next time solve() is called, negating any performance benefit of the persistent solver interface.

Also note that both the available() and solve() methods will construct a gurobipy model, thereby (depending on the type of license) “consuming” a license. The available() method has to do this so that the availability does not change between calls to available() and solve(), leading to unexpected errors.

pyomo.contrib.appsi.solvers.gurobi.GurobiResults(solver)

pyomo.contrib.appsi.solvers.gurobi.Gurobi([...])

---

## Ipopt — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.ipopt.html

**Contents:**
- Ipopt

pyomo.contrib.appsi.solvers.ipopt.IpoptConfig([...])

pyomo.contrib.appsi.solvers.ipopt.Ipopt([...])

---

## Constraints — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/constraint.html

**Contents:**
- Constraints
- Summary

pyomo.core.kernel.constraint.constraint([...])

A general algebraic constraint

pyomo.core.kernel.constraint.linear_constraint([...])

pyomo.core.kernel.constraint.constraint_tuple(...)

A tuple-style container for objects with category type IConstraint

pyomo.core.kernel.constraint.constraint_list(...)

A list-style container for objects with category type IConstraint

pyomo.core.kernel.constraint.constraint_dict(...)

A dict-style container for objects with category type IConstraint

pyomo.core.kernel.matrix_constraint.matrix_constraint(A)

A container for constraints of the form lb <= Ax <= ub.

---

## Solver Interfaces — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/index.html

**Contents:**
- Solver Interfaces

---

## Reference Guides — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/index.html

**Contents:**
- Reference Guides

---

## Context Managers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/context_managers.html

**Contents:**
- Context Managers

pyomo.core.expr.nonlinear_expression()

Context manager for mutable nonlinear sums.

pyomo.core.expr.linear_expression()

Context manager for mutable linear sums.

---

## APPSI — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.html

**Contents:**
- APPSI
- Installation

Auto-Persistent Pyomo Solver Interfaces

APPSI solver interfaces are designed to work very similarly to most Pyomo solver interfaces but are very efficient for resolving the same model with small changes. This is very beneficial for applications such as Benders’ Decomposition, Optimization-Based Bounds Tightening, Progressive Hedging, Outer-Approximation, and many others. Here is an example of using an APPSI solver interface.

Alternatively, you can access the APPSI solvers through the classic SolverFactory using the pattern appsi_solvername.

Extra performance improvements can be made if you know exactly what changes will be made in your model. In the example above, only parameter values are changed, so we can setup the UpdateConfig so that the solver does not check for changes in variables or constraints.

Solver independent options can be specified with the SolverConfig or derived classes. For example:

Solver specific options can be specified with the solver_options() attribute. For example:

There are a few ways to install Appsi listed below.

---

## Single-variate Piecewise Functions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/piecewise/piecewise.html

**Contents:**
- Single-variate Piecewise Functions
- Summary

pyomo.core.kernel.piecewise_library.transforms.piecewise(...)

Models a single-variate piecewise linear function.

pyomo.core.kernel.piecewise_library.transforms.PiecewiseLinearFunction(...)

A piecewise linear function

pyomo.core.kernel.piecewise_library.transforms.TransformedPiecewiseLinearFunction(f)

Base class for transformed piecewise linear functions

pyomo.core.kernel.piecewise_library.transforms.piecewise_convex(...)

Simple convex piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_sos2(...)

Discrete SOS2 piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_dcc(...)

Discrete DCC piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_cc(...)

Discrete CC piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_mc(...)

Discrete MC piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_inc(...)

Discrete INC piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_dlog(...)

Discrete DLOG piecewise representation

pyomo.core.kernel.piecewise_library.transforms.piecewise_log(...)

Discrete LOG piecewise representation

---

## Dict-like Object Storage — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/dict_container.html

**Contents:**
- Dict-like Object Storage

pyomo.core.kernel.dict_container.DictContainer(...)

A partial implementation of the IHomogeneousContainer interface that provides dict-like storage functionality.

---

## Objectives — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/objective.html

**Contents:**
- Objectives
- Summary

pyomo.core.kernel.objective.objective([...])

An optimization objective.

pyomo.core.kernel.objective.objective_tuple(...)

A tuple-style container for objects with category type IObjective

pyomo.core.kernel.objective.objective_list(...)

A list-style container for objects with category type IObjective

pyomo.core.kernel.objective.objective_dict(...)

A dict-style container for objects with category type IObjective

---

## Core Classes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/classes.html

**Contents:**
- Core Classes
- Sets with Expression Types
- NumericValue and NumericExpression
- Other Public Classes

The following are the two core classes documented here:

The remaining classes are the public classes for expressions, which developers may need to know about. The methods for these classes are not documented because they are described in the NumericExpression class.

The following sets can be used to develop visitor patterns for Pyomo expressions.

Python set used to identify numeric constants.

Python set used to identify numeric constants and related native types.

Python set used to identify numeric constants, boolean values, strings and instances of NonNumericValue, which is commonly used in code that walks Pyomo expression trees.

This is the base class for numeric values used in Pyomo.

NumericExpression(args)

The base class for Pyomo expressions.

NegationExpression(args)

Negation expressions.

An expression object for the abs() function.

UnaryFunctionExpression(args[, name, fcn])

An expression object for intrinsic (math) functions (e.g. sin, cos, tan).

ProductExpression(args)

DivisionExpression(args)

Division expressions.

Expr_ifExpression(args)

A numeric ternary (if-then-else) expression.

ExternalFunctionExpression(args[, fcn])

External function expressions

pyomo.core.expr.relational_expr.EqualityExpression(args)

pyomo.core.expr.relational_expr.InequalityExpression(...)

Inequality expressions, which define less-than or less-than-or-equal relations.

pyomo.core.expr.relational_expr.RangedExpression(...)

Ranged expressions, which define relations with a lower and upper bound.

pyomo.core.expr.template_expr.GetItemExpression([args])

Expression to call __getitem__() on the base object.

---

## Publications — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/bibliography.html#publications

**Contents:**
- Publications
- Bibliography

These publications describe various Pyomo capabilitites or subpackages:

William E. Hart, Jean-Paul Watson, David L. Woodruff. “Pyomo: modeling and solving mathematical programs in Python,” Mathematical Programming Computation, 3(3), August 2011.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff. Pyomo – Optimization Modeling in Python, Springer Optimization and Its Applications, Vol 67. Springer. 2012.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff, Gabriel A. Hackebeil, Bethany L. Nicholson, John D. Siirola. Pyomo - Optimization Modeling in Python, 2nd Edition. Springer Optimization and Its Applications, Vol 67. Springer. 2017.

Michael L. Bynum, Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Vol. 67. Springer. 2021. DOI 10.1007/978-3-030-68928-5

Bethany Nicholson, John D. Siirola, Jean-Paul Watson, Victor M. Zavala, and Lorenz T. Biegler. “pyomo.dae: a modeling and automatic discretization framework for optimization with differential and algebraic equations”, Mathematical Programming Computation, 10(2), 187-223. 2018.

Katherine A. Klise, Bethany L. Nicholson, Andrea Staid, David L.Woodruff. “Parmest: Parameter Estimation Via Pyomo.” Computer Aided Chemical Engineering, 47, 41-46. 2019.

Qi Chen, Emma S. Johnson, David E. Bernal, Romeo Valentin, Sunjeev Kale, Johnny Bates, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: an ecosystem for logic based modeling and optimization development.” Optimization and Engineering, 1-36. 2021. DOI 10.1007/s11081-021-09601-7

Qi Chen, Emma S. Johnson, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: Disjunctive Models in Python.” In M. R. Eden, M. G. Ierapetritou, and G. P. Towler (Eds.), Proceedings of the 13th International Symposium on Process Systems Engineering, 889–894, 2018. DOI 10.1016/B978-0-444-64241-7.50143-9

http://www.aimms.com/

O. Abel and W. Marquardt, “Scenario-integrated modeling and optimization of dynamic systems”, AIChE Journal, 46(4). 2000.

E. Balas. “Disjunctive Programming and a Hierarchy of Relaxations for Discrete Optimization Problems”, SIAM Journal on Algebraic Discrete Methods, 6(3), 466–486, 1985. DOI 10.1137/0606047

E. Balas and R. Jeroslow. “Canonical Cuts on the Unit Hypercube”, SIAM Journal on Applied Mathematics 23(1), 61-19, 1972. DOI 10.1137/0123007

H. Djelassi. “Discretization-based al

*[Content truncated]*

---

## Heterogeneous Object Containers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/heterogeneous_container.html

**Contents:**
- Heterogeneous Object Containers

pyomo.core.kernel.heterogeneous_container

---

## APPSI Base Classes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.base.html

**Contents:**
- APPSI Base Classes

pyomo.contrib.appsi.base.TerminationCondition(value)

An enumeration for checking the termination condition of solvers

pyomo.contrib.appsi.base.Results()

Base class for all APPSI solver results

pyomo.contrib.appsi.base.Solver()

pyomo.contrib.appsi.base.PersistentSolver()

pyomo.contrib.appsi.base.SolverConfig([...])

Common configuration options for all APPSI solver interfaces

pyomo.contrib.appsi.base.MIPSolverConfig([...])

Configuration options common to all MIP solvers

pyomo.contrib.appsi.base.UpdateConfig([...])

Config options common to all persistent solvers

---

## AML Library Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/aml/index.html

**Contents:**
- AML Library Reference

The following modeling components make up the core of the Pyomo Algebraic Modeling Language (AML). These classes are all available through the pyomo.environ namespace.

ConcreteModel(*args, **kwds)

A concrete optimization model that does not defer construction of components.

AbstractModel(*args, **kwds)

An abstract optimization model that defers construction of components.

Blocks are indexed components that contain other components (including blocks).

A component used to index other Pyomo components.

RangeSet(*args, **kwds)

A set object that represents a set of numeric values

A parameter value, which may be defined over an index.

A numeric variable, which may be defined over an index.

Objective(*args, **kwds)

This modeling component defines an objective expression.

Constraint(*args, **kwds)

This modeling component defines a constraint expression using a rule function.

ExternalFunction(*args, **kwargs)

Interface to an external (non-algebraic) function.

Reference(reference[, ctype])

Creates a component that references other components

SOSConstraint(*args, **kwds)

Implements constraints for special ordered sets (SOS).

---

## Tuple-like Object Storage — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/tuple_container.html

**Contents:**
- Tuple-like Object Storage

pyomo.core.kernel.tuple_container.TupleContainer(*args)

A partial implementation of the IHomogeneousContainer interface that provides tuple-like storage functionality.

---

## GAMS — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/gams.html

**Contents:**
- GAMS
- GAMSShell Solver
- GAMSDirect Solver
- GAMS Writer

A generic shell interface to GAMS solvers.

GAMSShell.available([exception_flag])

True if the solver is available.

GAMSShell.executable()

Returns the executable used by this solver.

GAMSShell.solve(*args, **kwds)

Solve a model via the GAMS executable.

Returns a 4-tuple describing the solver executable version.

GAMSShell.warm_start_capable()

True is the solver can accept a warm-start solution.

A generic python interface to GAMS solvers.

GAMSDirect.available([exception_flag])

True if the solver is available.

GAMSDirect.solve(*args, **kwds)

Solve a model via the GAMS Python API.

Returns a 4-tuple describing the solver executable version.

GAMSDirect.warm_start_capable()

True is the solver can accept a warm-start solution.

This class is most commonly accessed and called upon via model.write(“filename.gms”, …), but is also utilized by the GAMS solver interfaces.

---

## Publications — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/bibliography.html

**Contents:**
- Publications
- Bibliography

These publications describe various Pyomo capabilitites or subpackages:

William E. Hart, Jean-Paul Watson, David L. Woodruff. “Pyomo: modeling and solving mathematical programs in Python,” Mathematical Programming Computation, 3(3), August 2011.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff. Pyomo – Optimization Modeling in Python, Springer Optimization and Its Applications, Vol 67. Springer. 2012.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff, Gabriel A. Hackebeil, Bethany L. Nicholson, John D. Siirola. Pyomo - Optimization Modeling in Python, 2nd Edition. Springer Optimization and Its Applications, Vol 67. Springer. 2017.

Michael L. Bynum, Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Vol. 67. Springer. 2021. DOI 10.1007/978-3-030-68928-5

Bethany Nicholson, John D. Siirola, Jean-Paul Watson, Victor M. Zavala, and Lorenz T. Biegler. “pyomo.dae: a modeling and automatic discretization framework for optimization with differential and algebraic equations”, Mathematical Programming Computation, 10(2), 187-223. 2018.

Katherine A. Klise, Bethany L. Nicholson, Andrea Staid, David L.Woodruff. “Parmest: Parameter Estimation Via Pyomo.” Computer Aided Chemical Engineering, 47, 41-46. 2019.

Qi Chen, Emma S. Johnson, David E. Bernal, Romeo Valentin, Sunjeev Kale, Johnny Bates, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: an ecosystem for logic based modeling and optimization development.” Optimization and Engineering, 1-36. 2021. DOI 10.1007/s11081-021-09601-7

Qi Chen, Emma S. Johnson, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: Disjunctive Models in Python.” In M. R. Eden, M. G. Ierapetritou, and G. P. Towler (Eds.), Proceedings of the 13th International Symposium on Process Systems Engineering, 889–894, 2018. DOI 10.1016/B978-0-444-64241-7.50143-9

http://www.aimms.com/

O. Abel and W. Marquardt, “Scenario-integrated modeling and optimization of dynamic systems”, AIChE Journal, 46(4). 2000.

E. Balas. “Disjunctive Programming and a Hierarchy of Relaxations for Discrete Optimization Problems”, SIAM Journal on Algebraic Discrete Methods, 6(3), 466–486, 1985. DOI 10.1137/0606047

E. Balas and R. Jeroslow. “Canonical Cuts on the Unit Hypercube”, SIAM Journal on Applied Mathematics 23(1), 61-19, 1972. DOI 10.1137/0123007

H. Djelassi. “Discretization-based al

*[Content truncated]*

---

## Utilities for Piecewise Functions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/piecewise/util.html

**Contents:**
- Utilities for Piecewise Functions

pyomo.core.kernel.piecewise_library.util

---

## GurobiDirect — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/gurobi_direct.html

**Contents:**
- GurobiDirect
- Interface
- Methods

GurobiDirect([manage_env])

A direct interface to Gurobi using gurobipy.

GurobiDirect.available([exception_flag])

Returns True if the solver is available.

Frees local Gurobi resources used by this solver instance.

GurobiDirect.close_global()

Frees all Gurobi models used by this solver, and frees the global default Gurobi environment.

GurobiDirect.solve(*args, **kwds)

GurobiDirect.version()

Returns a 4-tuple describing the solver executable version.

---

## Suffixes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/suffix.html

**Contents:**
- Suffixes

pyomo.core.kernel.suffix

---

## Utilities to Manage and Analyze Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/managing.html

**Contents:**
- Utilities to Manage and Analyze Expressions
- Functions
- Classes

pyomo.core.expr.expression_to_string(expr[, ...])

Return a string representation of an expression.

pyomo.core.expr.decompose_term(expr)

A function that returns a tuple consisting of (1) a flag indicating whether the expression is linear, and (2) a list of tuples that represents the terms in the linear expression.

pyomo.core.expr.clone_expression(expr[, ...])

A function that is used to clone an expression.

pyomo.core.expr.evaluate_expression(exp[, ...])

Evaluate the value of the expression.

pyomo.core.expr.identify_components(expr, ...)

A generator that yields a sequence of nodes in an expression tree that belong to a specified set.

pyomo.core.expr.identify_variables(expr[, ...])

A generator that yields a sequence of variables in an expression tree.

pyomo.core.expr.differentiate(expr[, wrt, ...])

Return derivative of expression.

pyomo.core.expr.symbol_map.SymbolMap([labeler])

A class for tracking assigned labels for modeling components.

---

## Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/expression.html

**Contents:**
- Expressions
- Summary

pyomo.core.kernel.expression.expression([expr])

A named, mutable expression.

pyomo.core.kernel.expression.expression_tuple(...)

A tuple-style container for objects with category type IExpression

pyomo.core.kernel.expression.expression_list(...)

A list-style container for objects with category type IExpression

pyomo.core.kernel.expression.expression_dict(...)

A dict-style container for objects with category type IExpression

---

## Blocks — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/block.html

**Contents:**
- Blocks
- Summary

pyomo.core.kernel.block.block()

A generalized container for defining hierarchical models by adding modeling components as attributes.

pyomo.core.kernel.block.block_tuple(*args, ...)

A tuple-style container for objects with category type IBlock

pyomo.core.kernel.block.block_list(*args, **kwds)

A list-style container for objects with category type IBlock

pyomo.core.kernel.block.block_dict(*args, **kwds)

A dict-style container for objects with category type IBlock

---

## Publications — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/bibliography.html#bibliography

**Contents:**
- Publications
- Bibliography

These publications describe various Pyomo capabilitites or subpackages:

William E. Hart, Jean-Paul Watson, David L. Woodruff. “Pyomo: modeling and solving mathematical programs in Python,” Mathematical Programming Computation, 3(3), August 2011.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff. Pyomo – Optimization Modeling in Python, Springer Optimization and Its Applications, Vol 67. Springer. 2012.

William E. Hart, Carl D. Laird, Jean-Paul Watson, David L. Woodruff, Gabriel A. Hackebeil, Bethany L. Nicholson, John D. Siirola. Pyomo - Optimization Modeling in Python, 2nd Edition. Springer Optimization and Its Applications, Vol 67. Springer. 2017.

Michael L. Bynum, Gabriel A. Hackebeil, William E. Hart, Carl D. Laird, Bethany L. Nicholson, John D. Siirola, Jean-Paul Watson, and David L. Woodruff. Pyomo - Optimization Modeling in Python, 3rd Edition. Vol. 67. Springer. 2021. DOI 10.1007/978-3-030-68928-5

Bethany Nicholson, John D. Siirola, Jean-Paul Watson, Victor M. Zavala, and Lorenz T. Biegler. “pyomo.dae: a modeling and automatic discretization framework for optimization with differential and algebraic equations”, Mathematical Programming Computation, 10(2), 187-223. 2018.

Katherine A. Klise, Bethany L. Nicholson, Andrea Staid, David L.Woodruff. “Parmest: Parameter Estimation Via Pyomo.” Computer Aided Chemical Engineering, 47, 41-46. 2019.

Qi Chen, Emma S. Johnson, David E. Bernal, Romeo Valentin, Sunjeev Kale, Johnny Bates, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: an ecosystem for logic based modeling and optimization development.” Optimization and Engineering, 1-36. 2021. DOI 10.1007/s11081-021-09601-7

Qi Chen, Emma S. Johnson, John D. Siirola, and Ignacio E. Grossmann. “Pyomo.GDP: Disjunctive Models in Python.” In M. R. Eden, M. G. Ierapetritou, and G. P. Towler (Eds.), Proceedings of the 13th International Symposium on Process Systems Engineering, 889–894, 2018. DOI 10.1016/B978-0-444-64241-7.50143-9

http://www.aimms.com/

O. Abel and W. Marquardt, “Scenario-integrated modeling and optimization of dynamic systems”, AIChE Journal, 46(4). 2000.

E. Balas. “Disjunctive Programming and a Hierarchy of Relaxations for Discrete Optimization Problems”, SIAM Journal on Algebraic Discrete Methods, 6(3), 466–486, 1985. DOI 10.1137/0606047

E. Balas and R. Jeroslow. “Canonical Cuts on the Unit Hypercube”, SIAM Journal on Applied Mathematics 23(1), 61-19, 1972. DOI 10.1137/0123007

H. Djelassi. “Discretization-based al

*[Content truncated]*

---

## Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.html

**Contents:**
- Solvers

---

## XpressPersistent — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/xpress_persistent.html

**Contents:**
- XpressPersistent

pyomo.solvers.plugins.solvers.xpress_persistent.XpressPersistent(**kwds)

A class that provides a persistent interface to Xpress.

---

## Visitor Classes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/expressions/visitors.html

**Contents:**
- Visitor Classes

pyomo.core.expr.StreamBasedExpressionVisitor(**kwds)

This class implements a generic stream-based expression walker.

pyomo.core.expr.ExpressionValueVisitor()

pyomo.core.expr.ExpressionReplacementVisitor([...])

---

## List-like Object Storage — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/list_container.html

**Contents:**
- List-like Object Storage

pyomo.core.kernel.list_container.ListContainer(*args)

A partial implementation of the IHomogeneousContainer interface that provides list-like storage functionality.

---

## GurobiPersistent — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/solvers/gurobi_persistent.html

**Contents:**
- GurobiPersistent
- Interface
- Methods

GurobiPersistent(**kwds)

A class that provides a persistent interface to Gurobi.

GurobiPersistent.add_block(block)

Add a single Pyomo Block to the solver's model.

GurobiPersistent.add_constraint(con)

Add a single constraint to the solver's model.

GurobiPersistent.set_objective(obj)

Set the solver's objective.

GurobiPersistent.add_sos_constraint(con)

Add a single SOS constraint to the solver's model (if supported).

GurobiPersistent.add_var(var)

Add a single variable to the solver's model.

GurobiPersistent.available([exception_flag])

Returns True if the solver is available.

GurobiPersistent.has_capability(cap)

Returns a boolean value representing whether a solver supports a specific feature.

GurobiPersistent.has_instance()

True if set_instance has been called and this solver interface has a pyomo model and a solver model.

GurobiPersistent.load_vars([vars_to_load])

Load the values from the solver's variables into the corresponding pyomo variables.

GurobiPersistent.problem_format()

Returns the current problem format.

GurobiPersistent.remove_block(block)

Remove a single block from the solver's model.

GurobiPersistent.remove_constraint(con)

Remove a single constraint from the solver's model.

GurobiPersistent.remove_sos_constraint(con)

Remove a single SOS constraint from the solver's model.

GurobiPersistent.remove_var(var)

Remove a single variable from the solver's model.

GurobiPersistent.reset()

Reset the state of the solver

GurobiPersistent.results_format()

Returns the current results format.

GurobiPersistent.set_callback([func])

Specify a callback for gurobi to use.

GurobiPersistent.set_instance(model, **kwds)

This method is used to translate the Pyomo model provided to an instance of the solver's Python model.

GurobiPersistent.set_problem_format(format)

Set the current problem format (if it's valid) and update the results format to something valid for this problem format.

GurobiPersistent.set_results_format(format)

Set the current results format (if it's valid for the current problem format).

GurobiPersistent.solve(*args, **kwds)

GurobiPersistent.update_var(var)

Update a single variable in the solver's model.

GurobiPersistent.version()

Returns a 4-tuple describing the solver executable version.

GurobiPersistent.write(filename)

Write the model to a file (e.g., and lp file).

---

## Special Ordered Sets — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/sos.html

**Contents:**
- Special Ordered Sets
- Summary

pyomo.core.kernel.sos.sos(variables[, ...])

A Special Ordered Set of type n.

pyomo.core.kernel.sos.sos1(variables[, weights])

A Special Ordered Set of type 1.

pyomo.core.kernel.sos.sos2(variables[, weights])

A Special Ordered Set of type 2.

pyomo.core.kernel.sos.sos_tuple(*args, **kwds)

A tuple-style container for objects with category type ISOS

pyomo.core.kernel.sos.sos_list(*args, **kwds)

A list-style container for objects with category type ISOS

pyomo.core.kernel.sos.sos_dict(*args, **kwds)

A dict-style container for objects with category type ISOS

---

## Parameters — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/parameter.html

**Contents:**
- Parameters
- Summary

pyomo.core.kernel.parameter.parameter([value])

A object for storing a mutable, numeric value that can be used to build a symbolic expression.

pyomo.core.kernel.parameter.functional_value([fn])

An object for storing a numeric function that can be used in a symbolic expression.

pyomo.core.kernel.parameter.parameter_tuple(...)

A tuple-style container for objects with category type IParameter

pyomo.core.kernel.parameter.parameter_list(...)

A list-style container for objects with category type IParameter

pyomo.core.kernel.parameter.parameter_dict(...)

A dict-style container for objects with category type IParameter

---

## Base Object Storage Interface — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/base.html

**Contents:**
- Base Object Storage Interface

pyomo.core.kernel.base

---

## MAiNGO — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/appsi/appsi.solvers.maingo.html

**Contents:**
- MAiNGO

pyomo.contrib.appsi.solvers.maingo.MAiNGOConfig([...])

pyomo.contrib.appsi.solvers.maingo.MAiNGO([...])

---

## Homogeneous Object Containers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/reference/topical/kernel/homogeneous_container.html

**Contents:**
- Homogeneous Object Containers

pyomo.core.kernel.homogeneous_container

---
