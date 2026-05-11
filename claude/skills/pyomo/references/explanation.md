# Pyomo - Explanation

**Pages:** 127

---

## Data Reconciliation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/datarec.html

**Contents:**
- Data Reconciliation

The optional argument return_values in theta_est can be used for data reconciliation or to return model values based on the specified objective.

For data reconciliation, the m.unknown_parameters is empty and the objective function is defined to minimize measurement to model error. Note that the model used for data reconciliation may differ from the model used for parameter estimation.

The functions grouped_boxplot or grouped_violinplot can be used to visually compare the original and reconciled data.

The following example from the reactor design subdirectory returns reconciled values for experiment outputs (ca, cb, cc, and cd) and then uses those values in parameter estimation (k1, k2, and k3).

The following example returns model values from a Pyomo Expression.

---

## Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/index.html

**Contents:**
- Solvers

---

## Modeling Components — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/modeling.html

**Contents:**
- Modeling Components

Returns an IndexedConstraint that constrains the provided variables to be constant between the provided sample points

inputs (list of variables) – Time-indexed variables that will be constrained piecewise constant

time (Set) – Set of points at which provided variables will be constrained

sample_points (List of floats) – Points at which “constant constraints” will be omitted; these are points at which the provided variables may vary.

use_next (Bool (default True)) – Whether the next time point will be used in the constant constraint at each point in time. Otherwise, the previous time point is used.

A RangeSet indexing the list of variables provided and a Constraint indexed by the product of this RangeSet and time.

Set, IndexedConstraint

This function returns a tracking cost IndexedExpression for the given time-indexed variables and associated setpoint data.

variables (list) – List of time-indexed variables to include in the tracking cost expression

time (iterable) – Set of variable indices for which a cost expression will be created

setpoint_data (ScalarData, dict, or ComponentMap) – Maps variable names to setpoint values

weight_data (ScalarData, dict, or ComponentMap) – Optional. Maps variable names to tracking cost weights. If not provided, weights of one are used.

variable_set (Set) – Optional. A set of indices into the provided list of variables by which the cost expression will be indexed.

RangeSet that indexes the list of variables provided and an Expression indexed by the RangeSet and time containing the cost term for each variable at each point in time.

Returns an IndexedExpression penalizing deviation between the specified variables and piecewise constant target data.

variables (List of Pyomo variables) – Variables that participate in the cost expressions.

time (Iterable) – Index used for the cost expression

setpoint_data (IntervalData) – Holds the piecewise constant values that will be used as setpoints

weight_data (ScalarData (optional)) – Weights for variables. Default is all ones.

tolerance (Float (optional)) – Tolerance used for determining whether a time point is within an interval. Default is zero.

prefer_left (Bool (optional)) – If a time point lies at the boundary of two intervals, whether the value on the left will be chosen. Default is True.

Pyomo Expression, indexed by time, for the total weighted tracking cost with respect to the provided setpoint.

A function to get a penalty expression for specified variables fro

*[Content truncated]*

---

## Pyomo Network — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/network.html#arc-expansion-transformation

**Contents:**
- Pyomo Network
- Modeling Components
  - Port
  - Arc
- Arc Expansion Transformation
- Sequential Decomposition
  - Creating a Graph
  - Computation Order
  - Tear Selection
  - Running the Sequential Decomposition Procedure

Pyomo Network is a package that allows users to easily represent their model as a connected network of units. Units are blocks that contain ports, which contain variables, that are connected to other ports via arcs. The connection of two ports to each other via an arc typically represents a set of constraints equating each member of each port to each other, however there exist other connection rules as well, in addition to support for custom rules. Pyomo Network also includes a model transformation that will automatically expand the arcs and generate the appropriate constraints to produce an algebraic model that a solver can handle. Furthermore, the package also introduces a generic sequential decomposition tool that can leverage the modeling components to decompose a model and compute each unit in the model in a logically ordered sequence.

Pyomo Network introduces two new modeling components to Pyomo:

A collection of variables, which may be connected to other ports

Component used for connecting the members of two Port objects

A collection of variables, which may be connected to other ports

The idea behind Ports is to create a bundle of variables that can be manipulated together by connecting them to other ports via Arcs. A preprocess transformation will look for Arcs and expand them into a series of constraints that involve the original variables contained within the Port. The way these constraints are built can be specified for each Port member when adding members to the port, but by default the Port members will be equated to each other. Additionally, other objects such as expressions can be added to Ports as long as they, or their indexed members, can be manipulated within constraint expressions.

rule (function) – A function that returns a dict of (name: var) pairs to be initially added to the Port. Instead of var it could also be a tuples of (var, rule). Or it could return an iterable of either vars or tuples of (var, rule) for implied names.

initialize – Follows same specifications as rule’s return value, gets initially added to the Port

implicit – An iterable of names to be initially added to the Port as implicit vars

extends (Port) – A Port whose vars will be added to this Port upon construction

Arc Expansion procedure to generate simple equality constraints

Arc Expansion procedure for extensive variable properties

This procedure is the rule to use when variable quantities should be conserved; that is, split for outlets and combined for

*[Content truncated]*

---

## The Pyomo Configuration System — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/developer_utils/config.html

**Contents:**
- The Pyomo Configuration System
- Domain validation
- Configuring class hierarchies
- Interacting with argparse
- Accessing user-specified values
- Generating output & documentation

The Pyomo configuration system provides a set of three classes (ConfigDict, ConfigList, and ConfigValue) for managing and documenting structured configuration information and user input. The system is based around the ConfigValue class, which provides storage for a single configuration entry. ConfigValue objects can be grouped using two containers (ConfigDict and ConfigList), which provide functionality analogous to Python’s dict and list classes, respectively.

At its simplest, the configuration system allows for developers to specify a dictionary of documented configuration entries:

Users can then provide values for those entries, and retrieve the current values:

For convenience, ConfigDict objects support read/write access via attributes (with spaces in the declaration names replaced by underscores):

All Config objects support a domain keyword that accepts a callable object (type, function, or callable instance). The domain callable should take data and map it onto the desired domain, optionally performing domain validation (see ConfigValue, ConfigDict, and ConfigList for more information). This allows client code to accept a very flexible set of inputs without “cluttering” the code with input validation:

In addition to common types (like int, float, bool, and str), the configuration system provides a number of custom domain validators for common use cases:

Domain validator for bool-like objects.

Domain validation function admitting integers

Domain validation function admitting strictly positive integers

Domain validation function admitting strictly negative integers

Domain validation function admitting integers >= 0

Domain validation function admitting integers <= 0

Domain validation function admitting strictly positive numbers

Domain validation function admitting strictly negative numbers

NonPositiveFloat(val)

Domain validation function admitting numbers less than or equal to 0

NonNegativeFloat(val)

Domain validation function admitting numbers greater than or equal to 0

Domain validation class admitting a Container of possible values

Domain validation class admitting an enum value/name.

IsInstance(*bases[, document_full_base_names])

Domain validator for type checking.

ListOf(itemtype[, domain, string_lexer])

Domain validator for lists of a specified type

Module([basePath, expandPath])

Domain validator for modules.

Path([basePath, expandPath])

Domain validator for a path-like object.

PathList([basePath, expandPath])

Domain v

*[Content truncated]*

---

## MPI-Based Block Vectors and Matrices — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/tutorial.mpi_blocks.html

**Contents:**
- MPI-Based Block Vectors and Matrices

PyNumero’s MPI-based block vectors and matrices (MPIBlockVector and MPIBlockMatrix) behave very similarly to BlockVector and BlockMatrix. The primary difference is in construction. With MPIBlockVector and MPIBlockMatrix, each block is owned by either a single process/rank or all processes/ranks.

Consider the following example (in a file called “parallel_vector_ops.py”).

This example can be run with

Note that the make_local_copy() method is not efficient and should only be used for debugging.

The -1 in owners means that the block at that index (index 3 in this example) is owned by all processes. The non-negative integer values indicate that the block at that index is owned by the process with rank equal to the value. In this example, rank 0 owns block 1, rank 1 owns block 2, and rank 2 owns block 0. Block 3 is owned by all ranks. Note that blocks should only be set if the process/rank owns that block.

The operations performed with MPIBlockVector are identical to the same operations performed with BlockVector (or even NumPy arrays), except that the operations are now performed in parallel.

MPIBlockMatrix construction is very similar. Consider the following example in a file called “parallel_matvec.py”.

Which can be run with

The most difficult part of using MPIBlockVector and MPIBlockMatrix is determining the best structure and rank ownership to maximize parallel efficiency.

---

## NLP Interfaces — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/tutorial.nlp_interfaces.html

**Contents:**
- NLP Interfaces

Below are examples of using PyNumero’s interfaces to ASL for function and derivative evaluation. More information can be found in the API documentation.

Create a pyomo.contrib.pynumero.interfaces.pyomo_nlp.PyomoNLP instance

Get values of primals and duals

Get variable and constraint bounds

Objective and constraint evaluations

Derivative evaluations

Set values of primals and duals

Equality and inequality constraints separately

---

## 10 Minutes to PyNumero — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/tutorial.html

**Contents:**
- 10 Minutes to PyNumero

Other examples may be found at https://github.com/Pyomo/pyomo/tree/main/pyomo/contrib/pynumero/examples.

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#declaring-differential-equations

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## PyROS Usage Tutorial — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/tutorial/tutorial.html

**Contents:**
- PyROS Usage Tutorial
- Setup
- Prepare the Deterministic Model
  - Formulate the Model
  - Implement the Model
  - Solve the Model Deterministically
- Assess Impact of Parametric Uncertainty
- Use PyROS to Obtain Robust Solutions
  - Import PyROS
  - Construct PyROS Solver Arguments

Prepare the Deterministic Model

Solve the Model Deterministically

Assess Impact of Parametric Uncertainty

Use PyROS to Obtain Robust Solutions

Construct PyROS Solver Arguments

First-stage Variables and Second-Stage Variables

Uncertain Parameters and Uncertainty Set

Try Higher-Order Decision Rules to Improve Solution Quality

Assess Impact of Uncertainty Set on the Solution Obtained

Invoke PyROS in a for Loop

Visualize the Results

Assess Robust Feasibility of the Solutions

This tutorial is an in-depth guide on how to use PyROS to solve a two-stage robust optimization problem. The problem is taken from the area of chemical process systems design.

To successfully run this tutorial, you will need to install PyROS along with at least one local nonlinear programming (NLP) solver and at least one global NLP solver. In particular, this tutorial uses IPOPT as the local solver, BARON as the global solver, and COUENNE as a backup global solver.

You will also need to install Matplotlib, which is used to generate plots in this tutorial. Further, we recommend installing an interactive Matplotlib backend for quick and easy viewing of plots.

PyROS is designed to operate on a user-supplied deterministic NLP. We now set out to prepare a deterministic NLP that can be solved tractably with subordinate NLP optimizers.

Consider the reactor-cooler system below.

Fig. 2 Reactor-cooler system process flowsheet, adapted from [Dje20]. Constants are set in boldface.

A stream of chemical species \(E\) enters the reactor with a molar flow rate \(F_0 = 45.36\,\text{kmol/h}\), absolute temperature \(T_0 = 333\,\text{K}\), concentration \(\boldsymbol{c}_{E0} = 32.04\, \text{kmol}/\text{m}^3\), and heat capacity \(\boldsymbol{c}_p = 167.4\,\text{kJ}/ \text{kmol}\,\text{K}\). Inside the reactor, the exothermic reaction \(E \to F\) occurs at temperature \(T_1\) and with a conversion of 90%, so that \(\boldsymbol{c}_{E1} = 0.1\boldsymbol{c}_{E0}\). We assume that the reaction follows first-order kinetics, with a rate constant \(\boldsymbol{k}_\text{R}\) of nominal value \(10\,\text{hr}^{-1}\) and normalized activation energy \(\boldsymbol{E/R} = 555.6\,\text{K}\). Further, the molar heat of reaction is \(\boldsymbol{\Delta H}_\text{R}=-23260\,\text{kJ/kmol}\).

A portion of the product is cooled to a temperature \(T_2\) then recycled to the reactor. Cooling water, with heat capacity \(\boldsymbol{c}_{w,p} = 4.184\,\text{kJ}/\text{kg}\,\text{K}\) and inlet temperature \(\bolds

*[Content truncated]*

---

## Community Detection for Pyomo models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/community.html

**Contents:**
- Community Detection for Pyomo models
- Description of Package and detect_communities function
- External Packages
- Usage Examples
- Functions in this Package

This package separates model components (variables, constraints, and objectives) into different communities distinguished by the degree of connectivity between community members.

The community detection package allows users to obtain a community map of a Pyomo model - a Python dictionary-like object that maps sequential integer values to communities within the Pyomo model. The package takes in a model, organizes the model components into a graph of nodes and edges, then uses Louvain community detection (Blondel et al, 2008) to determine the communities that exist within the model.

In graph theory, a community is defined as a subset of nodes that have a greater degree of connectivity within themselves than they do with the rest of the nodes in the graph. In the context of Pyomo models, a community represents a subproblem within the overall optimization problem. Identifying these subproblems and then solving them independently can save computational work compared with trying to solve the entire model at once. Thus, it can be very useful to know the communities that exist in a model.

The manner in which the graph of nodes and edges is constructed from the model directly affects the community detection. Thus, this package provides the user with a lot of control over the construction of the graph. The function we use for this community detection is shown below:

Detects communities in a Pyomo optimization model

This function takes in a Pyomo optimization model and organizes the variables and constraints into a graph of nodes and edges. Then, by using Louvain community detection on the graph, a dictionary (community_map) is created, which maps (arbitrary) community keys to the detected communities within the model.

model (Block) – a Pyomo model or block to be used for community detection

type_of_community_map (str, optional) – a string that specifies the type of community map to be returned, the default is ‘constraint’. ‘constraint’ returns a dictionary (community_map) with communities based on constraint nodes, ‘variable’ returns a dictionary (community_map) with communities based on variable nodes, ‘bipartite’ returns a dictionary (community_map) with communities based on a bipartite graph (both constraint and variable nodes)

with_objective (bool, optional) – a Boolean argument that specifies whether or not the objective function is included in the model graph (and thus in ‘community_map’); the default is True

weighted_graph (bool, optional) – a Boolea

*[Content truncated]*

---

## Backward Compatibility — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/backward_compatibility.html

**Contents:**
- Backward Compatibility

While PyNumero is a third-party contribution to Pyomo, we intend to maintain the stability of its core functionality. The core functionality of PyNumero consists of:

The NLP API and PyomoNLP implementation of this API

HSL and MUMPS linear solver interfaces

BlockVector and BlockMatrix classes

CyIpopt and SciPy solver interfaces

Other parts of PyNumero, such as ExternalGreyBoxBlock and ImplicitFunctionSolver, are experimental and subject to change without notice.

---

## Debugging a structural singularity with the Dulmage-Mendelsohn partition — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/tutorial.dm.html

**Contents:**
- Debugging a structural singularity with the Dulmage-Mendelsohn partition

We start with some imports and by creating a Pyomo model we would like to debug. Usually the model is much larger and more complicated than this. This particular system appeared when debugging a dynamic 1-D partial differential-algebraic equation (PDAE) model representing a chemical looping combustion reactor.

To check this model for structural singularity, we apply the Dulmage-Mendelsohn partition. var_dm_partition and con_dm_partition are named tuples with fields for each of the four subsets defined by the partition: unmatched, overconstrained, square, and underconstrained.

If any variables or constraints are unmatched, the (Jacobian of the) model is structurally singular.

This model has one unmatched constraint and one unmatched variable, so it is structurally singular. However, the unmatched variable and constraint are not unique. For example, flow_comp[2] could have been unmatched instead of flow_comp[1]. The exact variables and constraints that are unmatched depends on both the order in which variables are identified in Pyomo expressions and the implementation of the matching algorithm. For a given implementation, however, these variables and constraints should be deterministic.

Unique subsets of variables and constraints that are useful when debugging a structural singularity are the underconstrained and overconstrained subsystems. The variables in the underconstrained subsystem are contained in the unmatched and underconstrained fields of the var_dm_partition named tuple, while the constraints are contained in the underconstrained field of the con_dm_partition named tuple. The variables in the overconstrained subsystem are contained in the overconstrained field of the var_dm_partition named tuple, while the constraints are contained in the overconstrained and unmatched fields of the con_dm_partition named tuple.

We now construct the underconstrained and overconstrained subsystems:

And display the variables and constraints contained in each:

At this point we must use our intuition about the system being modeled to identify “what is causing” the singularity. Looking at the under and over- constrained systems, it appears that we are missing an equation to calculate flow, the total flow rate, and that density is over-specified as it is computed by both the bulk density equation and one of the component density equations.

With this knowledge, we can eventually figure out (a) that we need an equation to calculate flow from density and (b) that ou

*[Content truncated]*

---

## PyNumero — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/index.html

**Contents:**
- PyNumero
- PyNumero API
- Developers
- Packages built on PyNumero
- Papers utilizing PyNumero

PyNumero is a package for developing parallel algorithms for nonlinear programs (NLPs). This documentation provides a brief introduction to PyNumero. For more details, see the API documentation).

pyomo.contrib.pynumero

The development team includes:

Jose Santiago Rodriguez

https://github.com/Pyomo/pyomo/tree/main/pyomo/contrib/interior_point

https://github.com/parapint/parapint

Rodriguez, J. S., Laird, C. D., & Zavala, V. M. (2020). Scalable preconditioning of block-structured linear algebra systems using ADMM. Computers & Chemical Engineering, 133, 106478.

---

## Key Concepts — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/gdp/concepts.html

**Contents:**
- Key Concepts
- Disjuncts
- Disjunctions
- Boolean Variables
- Logical Propositions

Generalized Disjunctive Programming (GDP) provides a way to bridge high-level propositional logic and algebraic constraints. The GDP standard form from the index page is repeated below.

Original support in Pyomo.GDP focused on the disjuncts and disjunctions, allowing the modelers to group relational expressions in disjuncts, with disjunctions describing logical-OR relationships between the groupings. As a result, we implemented the Disjunct and Disjunction objects before BooleanVar and the rest of the logical expression system. Accordingly, we also describe the disjuncts and disjunctions first below.

Disjuncts represent groupings of relational expressions (e.g. algebraic constraints) summarized by a Boolean indicator variable \(Y\) through implication:

Logically, this means that if \(Y_{ik} = True\), then the constraints \(M_{ik} x + N_{ik} z \leq e_{ik}\) and \(r_{ik}(x,z) \leq 0\) must be satisfied. However, if \(Y_{ik} = False\), then the corresponding constraints are ignored. Note that \(Y_{ik} = False\) does not imply that the corresponding constraints are violated.

Disjunctions describe a logical OR relationship between two or more Disjuncts. The simplest and most common case is a 2-term disjunction:

The disjunction above describes the selection between two units in a process network. \(Y_1\) and \(Y_2\) are the Boolean variables corresponding to the selection of process units 1 and 2, respectively. The continuous variables \(x_1, x_2, x_3, x_4\) describe flow in and out of the first and second units, respectively. If a unit is selected, the nonlinear equality in the corresponding disjunct enforces the input/output relationship in the selected unit. The final equality in each disjunct forces flows for the absent unit to zero.

Boolean variables are decision variables that may take a value of True or False. These are most often encountered as the indicator variables of disjuncts. However, they can also be independently defined to represent other problem decisions.

Boolean variables are not intended to participate in algebraic expressions. That is, \(3 \times \text{True}\) does not make sense; hence, \(x = 3 Y_1\) does not make sense. Instead, you may have the disjunction

Logical propositions are constraints describing relationships between the Boolean variables in the model.

These logical propositions can include:

\(Y_1 \Leftrightarrow Y_2\)

\(Y_1 \Rightarrow Y_2\)

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#logic-based-branch-and-bound-lbb

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## PyROS Uncertainty Sets — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/uncertainty_sets.html

**Contents:**
- PyROS Uncertainty Sets
- Overview
- Pre-Implemented Uncertainty Set Types
- Custom Uncertainty Set Types

Pre-Implemented Uncertainty Set Types

Custom Uncertainty Set Types

In PyROS, the uncertainty set of a robust optimization problem is represented by an instance of a subclass of the UncertaintySet abstract base class. PyROS provides a suite of pre-implemented concrete subclasses to facilitate instantiation of uncertainty sets that are commonly used in the optimization literature. Custom uncertainty set types can be implemented by subclassing UncertaintySet.

The UncertaintySet class is an abstract class and therefore cannot be directly instantiated.

The pre-implemented UncertaintySet subclasses are enumerated below:

AxisAlignedEllipsoidalSet(center, half_lengths)

An axis-aligned ellipsoidal region.

A hyperrectangle (or box).

BudgetSet(budget_membership_mat, rhs_vec[, ...])

CardinalitySet(origin, positive_deviation, gamma)

A cardinality-constrained (i.e., "gamma") set.

DiscreteScenarioSet(scenarios)

A set of finitely many distinct points (or scenarios).

EllipsoidalSet(center, shape_matrix[, ...])

A general ellipsoidal region.

FactorModelSet(origin, number_of_factors, ...)

A factor model (i.e., "net-alpha" model) set.

IntersectionSet(**unc_sets)

An intersection of two or more uncertainty sets, each of which is represented by an UncertaintySet object.

PolyhedralSet(lhs_coefficients_mat, rhs_vec)

A bounded convex polyhedron or polytope.

Mathematical definitions of the pre-implemented UncertaintySet subclasses are provided below.

Mathematical Definition

AxisAlignedEllipsoidalSet

\(\begin{array}{l} q^0 \in \mathbb{R}^{n}, \\ \alpha \in \mathbb{R}_{+}^{n} \end{array}\)

\(\left\{ q \in \mathbb{R}^{n} \middle| \begin{array}{l} \displaystyle\sum_{\substack{i = 1: \\ \alpha_{i} > 0}}^{n} \left(\frac{q_{i} - q_{i}^{0}}{\alpha_{i}}\right)^2 \leq 1 \\ q_{i} = q_{i}^{0} \,\forall\,i : \alpha_{i} = 0 \end{array} \right\}\)

\(\begin{array}{l} q ^{\text{L}} \in \mathbb{R}^{n}, \\ q^{\text{U}} \in \mathbb{R}^{n} \end{array}\)

\(\{q \in \mathbb{R}^n \mid q^\mathrm{L} \leq q \leq q^\mathrm{U}\}\)

\(\begin{array}{l} q^{0} \in \mathbb{R}^{n}, \\ b \in \mathbb{R}_{+}^{L}, \\ B \in \{0, 1\}^{L \times n} \end{array}\)

\(\left\{ q \in \mathbb{R}^{n} \middle| \begin{array}{l} \begin{pmatrix} B \\ -I \end{pmatrix} q \leq \begin{pmatrix} b + Bq^{0} \\ -q^{0} \end{pmatrix} \end{array} \right\}\)

\(\begin{array}{l} q^{0} \in \mathbb{R}^{n}, \\ \hat{q} \in \mathbb{R}_{+}^{n}, \\ \Gamma \in [0, n] \end{array}\)

\(\left\{ q \in \mathbb{R}^{n} \middle| \begin{arr

*[Content truncated]*

---

## Modeling Utilities — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/index.html

**Contents:**
- Modeling Utilities

---

## z3 SMT Sat Solver Interface — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/z3_interface.html

**Contents:**
- z3 SMT Sat Solver Interface
- Installation
- Using z3 Sat Solver

The z3 Satisfiability Solver interface can convert pyomo variables and expressions for use with the z3 Satisfiability Solver

z3 is required for use of the Sat Solver can be installed via the command

To use the sat solver define your pyomo model as usual:

---

## Sensitivity Toolbox — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/sensitivity_toolbox.html

**Contents:**
- Sensitivity Toolbox
- Using the Sensitivity Toolbox
- Installing sIPOPT and k_aug
- Sensitivity Toolbox Interface

The sensitivity toolbox provides a Pyomo interface to sIPOPT and k_aug to very quickly compute approximate solutions to nonlinear programs with a small perturbation in model parameters.

See the sIPOPT documentation or the following paper for additional details:

Pirnay, R. Lopez-Negrete, and L.T. Biegler, Optimal Sensitivity based on IPOPT, Math. Prog. Comp., 4(4):307–331, 2012.

The details of k_aug can be found in the following link:

David Thierry (2020). k_aug, https://github.com/dthierry/k_aug

We will start with a motivating example:

Here \(x_1\), \(x_2\), and \(x_3\) are the decision variables while \(p_1\) and \(p_2\) are parameters. At first, let’s consider \(p_1 = 4.5\) and \(p_2 = 1.0\). Below is the model implemented in Pyomo.

The solution of this optimization problem is \(x_1^* = 0.5\), \(x_2^* = 0.5\), and \(x_3^* = 0.0\). But what if we change the parameter values to \(\hat{p}_1 = 4.0\) and \(\hat{p}_2 = 1.0\)? Is there a quick way to approximate the new solution \(\hat{x}_1^*\), \(\hat{x}_2^*\), and \(\hat{x}_3^*\)? Yes! This is the main functionality of sIPOPT and k_aug.

Next we define the perturbed parameter values \(\hat{p}_1\) and \(\hat{p}_2\):

And finally we call sIPOPT or k_aug:

The first argument specifies the method, either ‘sipopt’ or ‘k_aug’. The second argument is the Pyomo model. The third argument is a list of the original parameters. The fourth argument is a list of the perturbed parameters. It’s important that these two lists are the same length and in the same order.

First, we can inspect the initial point:

Next, we inspect the solution \(x_1^*\), \(x_2^*\), and \(x_3^*\):

Note that k_aug does not save the solution with the original parameter values. Finally, we inspect the approximate solution \(\hat{x}_1^*\), \(\hat{x}_2^*\), and \(\hat{x}_3^*\):

The sensitivity toolbox requires either sIPOPT or k_aug to be installed and available in your system PATH. See the sIPOPT and k_aug documentation for detailed instructions:

https://coin-or.github.io/Ipopt/INSTALL.html

https://coin-or.github.io/Ipopt/SPECIALS.html#SIPOPT

https://coin-or.github.io/coinbrew/

https://github.com/dthierry/k_aug

If you get an error that ipopt_sens or k_aug and dot_sens cannot be found, double check your installation and make sure the build directories containing the executables were added to your system PATH.

This function accepts a Pyomo ConcreteModel, a list of parameters, and their corresponding perturbation list. The model is then au

*[Content truncated]*

---

## Design Overview — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/expressions/overview.html

**Contents:**
- Design Overview
- Historical Comparison
- Expression Entanglement and Mutability
  - Entangled Sub-Expressions
  - Mutable Expression Components

This document describes the “Pyomo5” expressions, which were introduced in Pyomo 5.6. The main differences between “Pyomo5” expressions and the previous expression system, called “Coopr3”, are:

Pyomo5 supports both CPython and PyPy implementations of Python, while Coopr3 only supports CPython.

The key difference in these implementations is that Coopr3 relies on CPython reference counting, which is not part of the Python language standard. Hence, this implementation is not guaranteed to run on other implementations of Python.

Pyomo5 does not rely on reference counting, and it has been tested with PyPy. In the future, this should allow Pyomo to support other Python implementations (e.g. Jython).

Pyomo5 expression objects are immutable, while Coopr3 expression objects are mutable.

This difference relates to how expression objects are managed in Pyomo. Once created, Pyomo5 expression objects cannot be changed. Further, the user is guaranteed that no “side effects” occur when expressions change at a later point in time. By contrast, Coopr3 allows expressions to change in-place, and thus “side effects” make occur when expressions are changed at a later point in time. (See discussion of entanglement below.)

Pyomo5 provides more consistent runtime performance than Coopr3.

While this documentation does not provide a detailed comparison of runtime performance between Coopr3 and Pyomo5, the following performance considerations also motivated the creation of Pyomo5:

There were surprising performance inconsistencies in Coopr3. For example, the following two loops had dramatically different runtime:

Coopr3 eliminates side effects by automatically cloning sub-expressions. Unfortunately, this can easily lead to unexpected cloning in models, which can dramatically slow down Pyomo model generation. For example:

Coopr3 leverages recursion in many operations, including expression cloning. Even simple non-linear expressions can result in deep expression trees where these recursive operations fail because Python runs out of stack space.

The immutable representation used in Pyomo5 requires more memory allocations than Coopr3 in simple loops. Hence, a pure-Python execution of Pyomo5 can be 10% slower than Coopr3 for model construction. But when Cython is used to optimize the execution of Pyomo5 expression generation, the runtimes for Pyomo5 and Coopr3 are about the same. (In principle, Cython would improve the runtime of Coopr3 as well, but the limitations noted above 

*[Content truncated]*

---

## Pyomo.DoE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/doe/doe.html

**Contents:**
- Pyomo.DoE
- Methodology Overview
- Pyomo.DoE Required Inputs
- Pyomo.DoE Usage Example
  - Step 0: Import Pyomo and the Pyomo.DoE module and create an Experiment class
  - Step 1: Define the Pyomo process model
  - Step 2: Finalize the Pyomo process model
  - Step 3: Label the information needed for DoE analysis
  - Step 4: Implement the get_labeled_model method
  - Step 5: Exploratory analysis (Enumeration)

Pyomo.DoE (Pyomo Design of Experiments) is a Python library for model-based design of experiments using science-based models.

Pyomo.DoE was developed by Jialu Wang and Alexander W. Dowling at the University of Notre Dame as part of the Carbon Capture Simulation for Industry Impact (CCSI2). project, funded through the U.S. Department Of Energy Office of Fossil Energy.

If you use Pyomo.DoE, please cite:

[Wang and Dowling, 2022] Wang, Jialu, and Alexander W. Dowling. “Pyomo.DOE: An open‐source package for model‐based design of experiments in Python.” AIChE Journal 68.12 (2022): e17813. https://doi.org/10.1002/aic.17813

Model-based Design of Experiments (MBDoE) is a technique to maximize the information gain of experiments by directly using science-based models with physically meaningful parameters. It is one key component in the model calibration and uncertainty quantification workflow shown below:

Fig. 3 The exploratory analysis, parameter estimation, uncertainty analysis, and MBDoE are combined into an iterative framework to select, refine, and calibrate science-based mathematical models with quantified uncertainty. Currently, Pyomo.DoE focuses on increasing parameter precision.

Pyomo.DoE provides the exploratory analysis and MBDoE capabilities to the Pyomo ecosystem. The user provides one Pyomo model, a set of parameter nominal values, the allowable design spaces for design variables, and the assumed observation error model. During exploratory analysis, Pyomo.DoE checks if the model parameters can be inferred from the postulated measurements or preliminary data. MBDoE then recommends optimized experimental conditions for collecting more data. Parameter estimation packages such as Parmest can perform parameter estimation using the available data to infer values for parameters, and facilitate an uncertainty analysis to approximate the parameter covariance matrix. If the parameter uncertainties are sufficiently small, the workflow terminates and returns the final model with quantified parametric uncertainty. If not, MBDoE recommends optimized experimental conditions to generate new data.

Below is an overview of the type of optimization models Pyomo.DoE can accommodate:

Pyomo.DoE is suitable for optimization models of continuous variables

Pyomo.DoE can handle equality constraints defining state variables

Pyomo.DoE supports (Partial) Differential-Algebraic Equations (PDAE) models via Pyomo.DAE

Pyomo.DoE also supports models with only algebraic const

*[Content truncated]*

---

## Constraints — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/constraints.html

**Contents:**
- Constraints

Most constraints are specified using equality or inequality expressions that are created using a rule, which is a Python function. For example, if the variable model.x has the indexes ‘butter’ and ‘scones’, then this constraint limits the sum over these indexes to be exactly three:

Instead of expressions involving equality (==) or inequalities (<= or >=), constraints can also be expressed using a 3-tuple if the form (lb, expr, ub) where lb and ub can be None, which is interpreted as lb <= expr <= ub. Variables can appear only in the middle expr. For example, the following two constraint declarations have the same meaning:

For this simple example, it would also be possible to declare model.x with a bounds option to accomplish the same thing.

Constraints (and objectives) can be indexed by lists or sets. When the declaration contains lists or sets as arguments, the elements are iteratively passed to the rule function. If there is more than one, then the cross product is sent. For example the following constraint could be interpreted as placing a budget of \(i\) on the \(i^{\mbox{th}}\) item to buy where the cost per item is given by the parameter model.a:

Python and Pyomo are case sensitive so model.a is not the same as model.A.

---

## Model Scaling Transformation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/scaling.html

**Contents:**
- Model Scaling Transformation
- Setting Scaling Factors
- Applying Model Scaling
  - In-Place Scaling
  - Creating a New Scaled Model

Good scaling of models can greatly improve the numerical properties of a problem and thus increase reliability and convergence. The core.scale_model transformation allows users to separate scaling of a model from the declaration of the model variables and constraints which allows for models to be written in more natural forms and to be scaled and rescaled as required without having to rewrite the model code.

pyomo.core.plugins.transform.scaling.ScaleModel(**kwds)

Transformation to scale a model.

Scaling factors for components in a model are declared using Suffixes, as shown in the example above. In order to define a scaling factor for a component, a Suffix named scaling_factor must first be created to hold the scaling factor(s). Scaling factor suffixes can be declared at any level of the model hierarchy, but scaling factors declared on the higher-level models or Blocks take precedence over those declared at lower levels.

Scaling suffixes are dict-like where each key is a Pyomo component and the value is the scaling factor to be applied to that component.

In the case of indexed components, scaling factors can either be declared for an individual index or for the indexed component as a whole (with scaling factors for individual indices taking precedence over overall scaling factors).

In the case that a scaling factor is declared for a component on at multiple levels of the hierarchy, the highest level scaling factor will be applied.

It is also possible (but not encouraged) to define a “default” scaling factor to be applied to any component for which a specific scaling factor has not been declared by setting a entry in a Suffix with a key of None. In this case, the default value declared closest to the component to be scaled will be used (i.e., the first default value found when walking up the model hierarchy).

The core.scale_model transformation provides two approaches for creating a scaled model.

The apply_to(model) method can be used to apply scaling directly to an existing model. When using this method, all the variables, constraints and objectives within the target model are replaced with new scaled components and the appropriate scaling factors applied. The model can then be sent to a solver as usual, however the results will be in terms of the scaled components and must be un-scaled by the user.

Alternatively, the create_using(model) method can be used to create a new, scaled version of the model which can be solved. In this case, a clone of 

*[Content truncated]*

---

## Syntax Comparison Table (pyomo.kernel vs pyomo.environ) — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/experimental/kernel/syntax_comparison.html

**Contents:**
- Syntax Comparison Table (pyomo.kernel vs pyomo.environ)

pyomo.kernel does not include an alternative to the AbstractModel component from pyomo.environ. All data necessary to build a model must be imported by the user.

pyomo.kernel does not include an alternative to the Pyomo Set component from pyomo.environ.

pyomo.kernel.parameter objects are always mutable.

Both pyomo.kernel.piecewise and pyomo.kernel.piecewise_nd create objects that are sub-classes of pyomo.kernel.block. Thus, these objects can be stored in containers such as pyomo.kernel.block_dict and pyomo.kernel.block_list.

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#relaxation-with-integer-cuts-ric

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#logic-based-discrete-steepest-descent-algorithm-ld-sda

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## API Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/api.html

**Contents:**
- API Reference

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#logic-based-outer-approximation-loa

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## Interfaces — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/interface.html

**Contents:**
- Interfaces

A helper class for working with dynamic models, e.g. those where many components are indexed by some ordered set referred to as “time.”

This class provides methods for interacting with time-indexed components, for instance, loading and extracting data or shifting values by some time offset. It also provides methods for constructing components useful for dynamic optimization.

Copy values of all time-indexed variables from source time point to target time points.

source_time (Float) – Time point from which to copy values.

target_time (Float or iterable) – Time point or points to which to copy values.

Gets data at a single time point or set of time points. Note that the returned type changes depending on whether a scalar or iterable is supplied.

A method to get a quadratic penalty expression from a provided setpoint data structure

target_data (ScalarData, TimeSeriesData, or IntervalData) – Holds target values for variables

time (Set (optional)) – Points at which to apply the tracking cost. Default will use the model’s time set.

variables (List of Pyomo VarData (optional)) – Subset of variables supplied in setpoint_data to use in the tracking cost. Default is to use all variables supplied.

weight_data (ScalarData (optional)) – Holds the weights to use in the tracking cost for each variable

variable_set (Set (optional)) – A set indexing the list of provided variables, if one already exists.

tolerance (Float (optional)) – Tolerance for checking inclusion in an interval. Only may be provided if IntervalData is provided for target_data. In this case the default is 0.0.

prefer_left (Bool (optional)) – Flag indicating whether the left end point of intervals should be preferred over the right end point. Only may be provided if IntervalData is provided for target_data. In this case the default is False.

Set indexing the list of variables to be penalized, and Expression indexed by this set and time. This Expression contains the weighted tracking cost for each variable at each point in time.

A method to get an indexed constraint ensuring that inputs are piecewise constant.

variables (List of Pyomo Vars) – Variables to enforce piecewise constant

sample_points (List of floats) – Points marking the boundaries of intervals within which variables must be constant

use_next (Bool (optional)) – Whether to enforce constancy by setting each variable equal to itself at the next point in time (as opposed to at the previous point in time). Default is True.

toleran

*[Content truncated]*

---

## Overview — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/overview.html

**Contents:**
- Overview
- What does this package contain?
- What is the goal of this package?
- Why is this package useful?
- Who develops and maintains this package?

Data structures for values and time series data associated with time-indexed variables (or parameters, or named expressions). Examples are setpoint values associated with a subset of state variables or time series data from a simulation

Utilities for loading and extracting this data into and from variables in a model

Utilities for constructing components from this data (expressions, constraints, and objectives) that are useful for dynamic optimization

This package was written to help developers of Pyomo-based dynamic optimization case studies, especially rolling horizon dynamic optimization case studies, write scripts that are small, legible, and maintainable. It does this by providing utilities for mundane data-management and model construction tasks, allowing the developer to focus on their application.

First, it is not normally easy to extract “flattened” time series data, in which all indexing structure other than time-indexing has been flattened to yield a set of one-dimensional arrays, from a Pyomo model. This is an extremely convenient data structure to have for plotting, analysis, initialization, and manipulation of dynamic models. If all variables are indexed by time and only time, this data is relatively easy to obtain. The first issue comes up when dealing with components that are indexed by time in addition to some other set(s). For example:

To generate data in this form, we need to (a) know that our variable is indexed by time and m.comp and (b) arbitrarily select a time index t0 to generate a unique key for each time series. This gets more difficult when blocks and time-indexed blocks are used as well. The first difficulty can be alleviated using flatten_dae_components from pyomo.dae.flatten:

Addressing the arbitrary t0 index requires us to ask what key we would like to use to identify each time series in our data structure. The key should uniquely correspond to a component, or “sub-component” that is indexed only by time. A slice, e.g. m.var[:, "A"] seems natural. However, Pyomo provides a better data structure that can be constructed from a component, slice, or string, called ComponentUID. Being constructable from a string is important as we may want to store or serialize this data in a form that is agnostic of any particular ConcreteModel object. We can now generate our data structure as:

This is the structure of the underlying dictionary in the TimeSeriesData class provided by this package. We can generate this data using this pack

*[Content truncated]*

---

## Overview — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/overview.html

**Contents:**
- Overview
- What is Incidence Analysis?
- Why is Incidence Analysis useful?
- Who develops and maintains Incidence Analysis?
- How can I cite Incidence Analysis?

A Pyomo extension for constructing the bipartite incidence graph of variables and constraints, and an interface to useful algorithms for analyzing or decomposing this graph.

It can identify the source of certain types of singularities in a system of variables and constraints. These singularities often violate assumptions made while modeling a physical system or assumptions required for an optimization solver to guarantee convergence. In particular, interior point methods used for nonlinear local optimization require the Jacobian of equality constraints (and active inequalities) to be full row rank, and this package implements the Dulmage-Mendelsohn partition, which can be used to determine if this Jacobian is structurally rank-deficient.

This extension was developed by Robert Parker while a PhD student in Professor Biegler’s lab at Carnegie Mellon University, with guidance from Bethany Nicholson and John Siirola at Sandia.

If you use Incidence Analysis in your research, we would appreciate you citing the following paper:

---

## Generalized Disjunctive Programming — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/gdp/index.html

**Contents:**
- Generalized Disjunctive Programming

The Pyomo.GDP modeling extension [PyomoGDP-proceedings] [PyomoGDP-paper] provides support for Generalized Disjunctive Programming (GDP) [RG94], an extension of Disjunctive Programming [Bal85] from the operations research community to include nonlinear relationships. The classic form for a GDP is given by:

Here, we have the minimization of an objective \(f(x, z)\) subject to global linear constraints \(Ax+Bz \leq d\) and nonlinear constraints \(g(x,z) \leq 0\), with conditional linear constraints \(M_{ik} x + N_{ik} z \leq e_{ik}\) and nonlinear constraints \(r_{ik}(x,z)\leq 0\). These conditional constraints are collected into disjuncts \(D_k\), organized into disjunctions \(K\). Finally, there are logical propositions \(\Omega(Y) = True\). Decision/state variables can be continuous \(x\), Boolean \(Y\), and/or integer \(z\).

GDP is useful to model discrete decisions that have implications on the system behavior [GT13]. For example, in process design, a disjunction may model the choice between processes A and B. If A is selected, then its associated equations and inequalities will apply; otherwise, if B is selected, then its respective constraints should be enforced.

Modelers often ask to model if-then-else relationships. These can be expressed as a disjunction as follows:

Here, if the Boolean \(Y_1\) is True, then the constraints in the first disjunct are enforced; otherwise, the constraints in the second disjunct are enforced. The following sections describe the key concepts, modeling, and solution approaches available for Generalized Disjunctive Programming.

---

## Block Triangular Decomposition Solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/scc_solver.html

**Contents:**
- Block Triangular Decomposition Solver

Yield in order BlockData that each contain the variables and constraints of a single diagonal block in a block lower triangularization of the incidence matrix of constraints and variables

These diagonal blocks correspond to strongly connected components of the bipartite incidence graph, projected with respect to a perfect matching into a directed graph.

constraints (List of Pyomo constraint data objects) – Constraints used to generate strongly connected components.

variables (List of Pyomo variable data objects) – Variables that may participate in strongly connected components. If not provided, all variables in the constraints will be used.

include_fixed (Bool, optional) – Indicates whether fixed variables will be included when identifying variables in constraints.

igraph (IncidenceGraphInterface, optional) – Incidence graph containing (at least) the provided constraints and variables.

Tuple of BlockData, list-of-variables – Blocks containing the variables and constraints of every strongly connected component, in a topological order. The variables are the “input variables” for that block.

Solve a square system of variables and equality constraints by solving strongly connected components individually.

Strongly connected components (of the directed graph of constraints obtained from a perfect matching of variables and constraints) are the diagonal blocks in a block triangularization of the incidence matrix, so solving the strongly connected components in topological order is sufficient to solve the entire block.

One-by-one blocks are solved using Pyomo’s calculate_variable_from_constraint function, while higher-dimension blocks are solved using the user-provided solver object.

block (Pyomo Block) – The Pyomo block whose variables and constraints will be solved

solver (Pyomo solver object) – The solver object that will be used to solve strongly connected components of size greater than one constraint. Must implement a solve method.

solve_kwds (Dictionary) – Keyword arguments for the solver’s solve method

use_calc_var (Bool) – Whether to use calculate_variable_from_constraint for one-by-one square system solves

calc_var_kwds (Dictionary) – Keyword arguments for calculate_variable_from_constraint

List of results objects returned by each call to solve

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#dynamic-model-initialization

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Data Conversion — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/conversion.html

**Contents:**
- Data Conversion

data (IntervalData) – Data to convert to a TimeSeriesData object

time_points (Iterable (optional)) – Points at which time series will be defined. Values are taken from the interval in which each point lives. The default is to use the right endpoint of each interval.

tolerance (Float (optional)) – Tolerance within which time points are considered equal. Default is zero.

use_left_endpoints (Bool (optional)) – Whether the left endpoints should be used in the case when time_points is not provided. Default is False, meaning that the right interval endpoints will be used. Should not be set if time points are provided.

prefer_left (Bool (optional)) – If time_points is provided, and a time point is equal (within tolerance) to a boundary between two intervals, this flag controls which interval is used.

data (TimeSeriesData) – Data that will be converted into an IntervalData object

use_left_endpoints (Bool (optional)) – Flag indicating whether values on intervals should come from the values at the left or right endpoints of the intervals

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#modeling-components

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Pyomo Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/expressions/index.html

**Contents:**
- Pyomo Expressions

This documentation does not explicitly reference objects in pyomo.core.kernel. While the Pyomo5 expression system works with pyomo.core.kernel objects, the documentation of these documents was not sufficient to appropriately describe the use of kernel objects in expressions.

Pyomo supports the declaration of symbolic expressions that represent objectives, constraints and other optimization modeling components. Pyomo expressions are represented in an expression tree, where the leaves are operands, such as constants or variables, and the internal nodes contain operators. Pyomo relies on so-called magic methods to automate the construction of symbolic expressions. For example, consider an expression e declared as follows:

Python determines that the magic method __mul__ is called on the M.v object, with the argument 2. This method returns a Pyomo expression object ProductExpression that has arguments M.v and 2. This represents the following symbolic expression tree:

End-users will not likely need to know details related to how symbolic expressions are generated and managed in Pyomo. Thus, most of the following documentation of expressions in Pyomo is most useful for Pyomo developers. However, the discussion of runtime performance in the first section will help end-users write large-scale models.

---

## PyROS Methodology Overview — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/overview.html

**Contents:**
- PyROS Methodology Overview

PyROS can accommodate optimization models with:

Continuous variables only

Nonlinearities (including nonconvexities) in both the variables and uncertain parameters

First-stage degrees of freedom and second-stage degrees of freedom

Equality constraints defining state variables, including implicitly defined state variables that cannot be eliminated from the model via reformulation

Uncertain parameters participating in the inequality constraints, equality constraints, and/or objective function

Supported deterministic models are nonlinear programs (NLPs) of the general form

\(x \in \mathcal{X}\) denotes the first-stage degree of freedom variables (or design variables), of which the feasible space \(\mathcal{X} \subseteq \mathbb{R}^{n_x}\) is defined by the model constraints (including variable bounds specifications) referencing \(x\) only

\(z \in \mathbb{R}^{n_z}\) denotes the second-stage degree of freedom variables (or control variables)

\(y \in \mathbb{R}^{n_y}\) denotes the state variables

\(q \in \mathbb{R}^{n_q}\) denotes the model parameters considered uncertain, and \(q^{\text{nom}}\) is the vector of nominal values associated with those

\(f_1\left(x\right)\) is the summand of the objective function that depends only on the first-stage degree of freedom variables

\(f_2\left(x, z, y; q\right)\) is the summand of the objective function that depends on all variables and the uncertain parameters

\(g_i\left(x, z, y; q\right)\) is the \(i^\text{th}\) inequality constraint function in set \(\mathcal{I}\) (see first Note)

\(h_j\left(x, z, y; q\right)\) is the \(j^\text{th}\) equality constraint function in set \(\mathcal{J}\) (see second Note)

PyROS accepts and automatically reformulates models with:

Interval bounds on components of \((x, z, y)\)

Ranged inequality constraints

A key assumption of PyROS is that for every \(x \in \mathcal{X}\), \(z \in \mathbb{R}^{n_z}\), \(q \in \mathcal{Q}\), there exists a unique \(y \in \mathbb{R}^{n_y}\) for which \((x, z, y, q)\) satisfies the equality constraints \(h_j(x, z, y, q) = 0\,\,\forall\, j \in \mathcal{J}\). If this assumption is not met, then the selection of state (i.e., not degree of freedom) variables \(y\) is incorrect, and one or more entries of \(y\) should be appropriately redesignated to be part of either \(x\) or \(z\).

In order to cast the robust optimization counterpart of the deterministic model, we now assume that the uncertain parameters \(q\) may attain any realization in a compa

*[Content truncated]*

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## MindtPy Solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/mindtpy.html

**Contents:**
- MindtPy Solver
- MINLP Formulation
- Solve Convex MINLPs
  - LP/NLP Based Branch-and-Bound
  - Regularized Outer-Approximation
  - Solution Pool Implementation
  - Feasibility Pump
- Solve Nonconvex MINLPs
  - Equality Relaxation
  - Augmented Penalty

The Mixed-Integer Nonlinear Decomposition Toolbox in Pyomo (MindtPy) solver allows users to solve Mixed-Integer Nonlinear Programs (MINLP) using decomposition algorithms. These decomposition algorithms usually rely on the solution of Mixed-Integer Linear Programs (MILP) and Nonlinear Programs (NLP).

The following algorithms are currently available in MindtPy:

Outer-Approximation (OA) [Duran & Grossmann, 1986]

LP/NLP based Branch-and-Bound (LP/NLP BB) [Quesada & Grossmann, 1992]

Extended Cutting Plane (ECP) [Westerlund & Petterson, 1995]

Global Outer-Approximation (GOA) [Kesavan & Allgor, 2004]

Regularized Outer-Approximation (ROA) [Bernal & Peng, 2021, Kronqvist & Bernal, 2018]

Feasibility Pump (FP) [Bernal & Vigerske, 2019, Bonami & Cornuéjols, 2009]

Usage and early implementation details for MindtPy can be found in the PSE 2018 paper Bernal et al., (ref, preprint). This solver implementation has been developed by David Bernal and Zedong Peng as part of research efforts at the Bernal Research Group and the Grossmann Research Group at Purdue University and Carnegie Mellon University.

The general formulation of the mixed integer nonlinear programming (MINLP) models is as follows.

\(\mathbf{x}\in {\mathbb R}^n\) are continuous variables,

\(\mathbf{y} \in {\mathbb Z}^m\) are discrete variables,

\(f, g_1, \dots, g_l\) are non-linear smooth functions,

\(\mathbf{A}\mathbf{x} +\mathbf{B}\mathbf{y} \leq \mathbf{b}`\) are linear constraints.

Usage of MindtPy to solve a convex MINLP Pyomo model involves:

An example which includes the modeling approach may be found below.

The solution may then be displayed by using the commands

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

MindtPy also supports setting options for mip solvers and nlp solvers.

There are three initialization strategies in MindtPy: rNLP, initial_binary, max_binary. In OA and GOA strategies, the default initialization strategy is rNLP. In ECP strategy, the default initialization strategy is max_binary.

MindtPy also supports single-tree implementation of Outer-Approximation (OA) algorithm, which is known as LP/NLP based branch-and-bound algorithm originally described in [Quesada & Grossmann, 1992]. The LP/NLP based branch-and-bound algorithm in MindtPy is implemented based on the LazyConstraintCallback function in commercial solvers.

In Pyomo, persistent solvers are necessary to set or register callback functions. The single tree implement

*[Content truncated]*

---

## Scenario Creation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/scencreate.html

**Contents:**
- Scenario Creation

In addition to model-based parameter estimation, parmest can create scenarios for use in optimization under uncertainty. To do this, one first creates an Estimator object, then a ScenarioCreator object, which has methods to add ParmestScen scenario objects to a ScenarioSet object, which can write them to a csv file or output them via an iterator method.

This example is in the semibatch subdirectory of the examples directory in the file scenario_example.py. It creates a csv file with scenarios that correspond one-to-one with the experiments used as input data. It also creates a few scenarios using the bootstrap methods and outputs prints the scenarios to the screen, accessing them via the ScensItator a print

This example may produce an error message if your version of Ipopt is not based on a good linear solver.

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#declaring-integrals

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Persistent Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/persistent.html

**Contents:**
- Persistent Solvers
- Using Persistent Solvers
- Working with Indexed Variables and Constraints
- Persistent Solver Performance

The purpose of the persistent solver interfaces is to efficiently notify the solver of incremental changes to a Pyomo model. The persistent solver interfaces create and store model instances from the Python API for the corresponding solver. For example, the GurobiPersistent class maintains a pointer to a gurobipy Model object. Thus, we can make small changes to the model and notify the solver rather than recreating the entire model using the solver Python API (or rewriting an entire model file - e.g., an lp file) every time the model is solved.

Users are responsible for notifying persistent solver interfaces when changes to a model are made!

The first step in using a persistent solver is to create a Pyomo model as usual.

You can create an instance of a persistent solver through the SolverFactory.

This returns an instance of GurobiPersistent. Now we need to tell the solver about our model.

This will create a gurobipy Model object and include the appropriate variables and constraints. We can now solve the model.

We can also add or remove variables, constraints, blocks, and objectives. For example,

This tells the solver to add one new constraint but otherwise leave the model unchanged. We can now resolve the model.

To remove a component, simply call the corresponding remove method.

If a pyomo component is replaced with another component with the same name, the first component must be removed from the solver. Otherwise, the solver will have multiple components. For example, the following code will run without error, but the solver will have an extra constraint. The solver will have both y >= -2*x + 5 and y <= x, which is not what was intended!

The correct way to do this is:

Components removed from a pyomo model must be removed from the solver instance by the user.

Additionally, unexpected behavior may result if a component is modified before being removed.

In most cases, the only way to modify a component is to remove it from the solver instance, modify it with Pyomo, and then add it back to the solver instance. The only exception is with variables. Variables may be modified and then updated with with solver:

The examples above all used simple variables and constraints; in order to use indexed variables and/or constraints, the code must be slightly adapted:

This must be done when removing variables/constraints, too. Not doing this would result in AttributeError exceptions, for example:

The method “is_indexed” can be used to automate the process

*[Content truncated]*

---

## Parameter Estimation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/index.html

**Contents:**
- Parameter Estimation
- Citation for parmest
- Index of parmest documentation

parmest is a Python package built on the Pyomo optimization modeling language ([Pyomo-paper], [PyomoBookIII]) to support parameter estimation using experimental data along with confidence regions and subsequent creation of scenarios for stochastic programming.

If you use parmest, please cite [Parmest-paper]

---

## API — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/api.html

**Contents:**
- API
- parmest
- scenariocreator
- graphics

Parameter estimation class

experiment_list (list of Experiments) – A list of experiment objects which creates one labeled model for each experiment

obj_function (string or function (optional)) – Built-in objective (“SSE” or “SSE_weighted”) or custom function used to formulate parameter estimation objective. If no function is specified, the model is used “as is” and should be defined with a “FirstStageCost” and “SecondStageCost” expression that are used to build an objective. Default is None.

tee (bool, optional) – If True, print the solver output to the screen. Default is False.

diagnostic_mode (bool, optional) – If True, print diagnostics from the solver. Default is False.

solver_options (dict, optional) – Provides options to the solver (also the name of an attribute). Default is None.

Confidence region test to determine if theta values are within a rectangular, multivariate normal, or Gaussian kernel density distribution for a range of alpha values

theta_values (pd.DataFrame, columns = theta_names) – Theta values used to generate a confidence region (generally returned by theta_est_bootstrap)

distribution (string) – Statistical distribution used to define a confidence region, options = ‘MVN’ for multivariate_normal, ‘KDE’ for gaussian_kde, and ‘Rect’ for rectangular.

alphas (list) – List of alpha values used to determine if theta values are inside or outside the region.

test_theta_values (pd.Series or pd.DataFrame, keys/columns = theta_names, optional) – Additional theta values that are compared to the confidence region to determine if they are inside or outside.

training_results (pd.DataFrame) – Theta value used to generate the confidence region along with True (inside) or False (outside) for each alpha test_results (pd.DataFrame) – If test_theta_values is not None, returns test theta value along with True (inside) or False (outside) for each alpha

training_results (pd.DataFrame) – Theta value used to generate the confidence region along with True (inside) or False (outside) for each alpha

test_results (pd.DataFrame) – If test_theta_values is not None, returns test theta value along with True (inside) or False (outside) for each alpha

Covariance matrix calculation using all scenarios in the data

method (str, optional) – Covariance calculation method. Options - ‘finite_difference’, ‘reduced_hessian’, and ‘automatic_differentiation_kaug’. Default is ‘finite_difference’

solver (str, optional) – Solver name, e.g., ‘ipopt’. Default is ‘ipopt’

*[Content truncated]*

---

## Pyomo Network — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/network.html

**Contents:**
- Pyomo Network
- Modeling Components
  - Port
  - Arc
- Arc Expansion Transformation
- Sequential Decomposition
  - Creating a Graph
  - Computation Order
  - Tear Selection
  - Running the Sequential Decomposition Procedure

Pyomo Network is a package that allows users to easily represent their model as a connected network of units. Units are blocks that contain ports, which contain variables, that are connected to other ports via arcs. The connection of two ports to each other via an arc typically represents a set of constraints equating each member of each port to each other, however there exist other connection rules as well, in addition to support for custom rules. Pyomo Network also includes a model transformation that will automatically expand the arcs and generate the appropriate constraints to produce an algebraic model that a solver can handle. Furthermore, the package also introduces a generic sequential decomposition tool that can leverage the modeling components to decompose a model and compute each unit in the model in a logically ordered sequence.

Pyomo Network introduces two new modeling components to Pyomo:

A collection of variables, which may be connected to other ports

Component used for connecting the members of two Port objects

A collection of variables, which may be connected to other ports

The idea behind Ports is to create a bundle of variables that can be manipulated together by connecting them to other ports via Arcs. A preprocess transformation will look for Arcs and expand them into a series of constraints that involve the original variables contained within the Port. The way these constraints are built can be specified for each Port member when adding members to the port, but by default the Port members will be equated to each other. Additionally, other objects such as expressions can be added to Ports as long as they, or their indexed members, can be manipulated within constraint expressions.

rule (function) – A function that returns a dict of (name: var) pairs to be initially added to the Port. Instead of var it could also be a tuples of (var, rule). Or it could return an iterable of either vars or tuples of (var, rule) for implied names.

initialize – Follows same specifications as rule’s return value, gets initially added to the Port

implicit – An iterable of names to be initially added to the Port as implicit vars

extends (Port) – A Port whose vars will be added to this Port upon construction

Arc Expansion procedure to generate simple equality constraints

Arc Expansion procedure for extensive variable properties

This procedure is the rule to use when variable quantities should be conserved; that is, split for outlets and combined for

*[Content truncated]*

---

## Pyomo Interfaces — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/interface.html

**Contents:**
- Pyomo Interfaces

Utility functions and a utility class for interfacing Pyomo components with useful graph algorithms.

An interface for applying graph algorithms to Pyomo variables and constraints

model (Pyomo BlockData or PyNumero PyomoNLP, default None) – An object from which an incidence graph will be constructed.

active (Bool, default True) – Whether only active constraints should be included in the incidence graph. Cannot be set to False if the model is provided as a PyomoNLP.

include_fixed (Bool, default False) – Whether to include fixed variables in the incidence graph. Cannot be set to False if model is a PyomoNLP.

include_inequality (Bool, default True) – Whether to include inequality constraints (those whose expressions are not instances of EqualityExpression) in the incidence graph. If a PyomoNLP is provided, setting to False uses the evaluate_jacobian_eq method instead of evaluate_jacobian rather than checking constraint expression types.

Adds an edge between variable and constraint in the incidence graph

variable (VarData) – A variable in the graph

constraint (ConstraintData) – A constraint in the graph

Compute an ordered partition of the provided variables and constraints such that their incidence matrix is block lower triangular

Subsets in the partition correspond to the strongly connected components of the bipartite incidence graph, projected with respect to a perfect matching.

var_partition (list of lists) – Partition of variables. The inner lists hold unindexed variables. con_partition (list of lists) – Partition of constraints. The inner lists hold unindexed constraints.

var_partition (list of lists) – Partition of variables. The inner lists hold unindexed variables.

con_partition (list of lists) – Partition of constraints. The inner lists hold unindexed constraints.

Breaking change in Pyomo 6.5.0

The pre-6.5.0 block_triangularize method returned maps from each variable or constraint to the index of its block in a block lower triangularization as the original intent of this function was to identify when variables do or don’t share a diagonal block in this partition. Since then, the dominant use case of block_triangularize has been to partition variables and constraints into these blocks and inspect or solve each block individually. A natural return type for this functionality is the ordered partition of variables and constraints, as lists of lists. This functionality was previously available via the get_diagonal_blocks method, which was con

*[Content truncated]*

---

## Parameter Estimation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/driver.html

**Contents:**
- Parameter Estimation
- List of experiment objects
- Objective function
- Suggested initialization procedure for parameter estimation problems

Parameter Estimation using parmest requires a Pyomo model, experimental data which defines multiple scenarios, and parameters (thetas) to estimate. parmest uses Pyomo [PyomoBookIII] and (optionally) mpi-sppy [KMM+23] to solve a two-stage stochastic programming problem, where the experimental data is used to create a scenario tree. The objective function needs to be written with the Pyomo Expression for first stage cost (named “FirstStageCost”) set to zero and the Pyomo Expression for second stage cost (named “SecondStageCost”) defined as the deviation between the model and the observations (typically defined as the sum of squared deviation between model values and observed values).

If the Pyomo model is not formatted as a two-stage stochastic programming problem in this format, the user can choose either the built-in “SSE” or “SSE_weighted” objective functions, or supply a custom objective function to use as the second stage cost. The Pyomo model will then be modified within parmest to match the required specifications. The stochastic programming callback function is also defined within parmest. The callback function returns a populated and initialized model for each scenario.

To use parmest, the user creates a Estimator object which includes the following methods:

Parameter estimation using all scenarios in the data

Covariance matrix calculation using all scenarios in the data

Parameter estimation using bootstrap resampling of the data

Parameter estimation where N data points are left out of each sample

Objective value for each theta

confidence_region_test

Confidence region test to determine if theta values are within a rectangular, multivariate normal, or Gaussian kernel density distribution for a range of alpha values

likelihood_ratio_test

Likelihood ratio test to identify theta values within a confidence region using the \(\chi^2\) distribution

leaveNout_bootstrap_test

Leave-N-out bootstrap test to compare theta values where N data points are left out to a bootstrap analysis using the remaining data, results indicate if theta is within a confidence region determined by the bootstrap analysis

Additional functions are available in parmest to plot results and fit distributions to theta values.

Plot pairwise relationship for theta values, and optionally alpha-level confidence intervals and objective value contours

Plot a grouped boxplot to compare two datasets

Plot a grouped violinplot to compare two datasets

Fit an alpha-level rectangula

*[Content truncated]*

---

## aslfunctions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/aslfunctions/index.html

**Contents:**
- aslfunctions
- Using These AMPL External Functions
  - Build
  - Example
- Functions
  - sinc(x)
  - sgnsqr(x)
  - sgnsqr_c4(x)
  - sgnsqrt_c4(x)

Pyomo provides a set of AMPL user-defined functions that commonly occur but cannot be easily written as Pyomo expressions.

You must build the Pyomo extensions to use these functions. Run pyomo build-extensions in the terminal and make sure the aslfunctions build status is “ok.”

This function is defined as:

In this implementation, the region \(-0.1 < x < 0.1\) is replaced by a Taylor series with enough terms that the function should be at least \(C^2\) smooth. The difference between the function and the Tayor series is near the limits of machine precision, about \(1 \times 10^{-16}\) for the function value, \(1 \times 10^{-16}\) for the first derivative, and \(1 \times 10^{-14}\) for the second derivative.

These figures show the sinc(x) function, the Taylor series and where the Taylor series is used.

This function is defined as:

This function is only \(C^1\) smooth because at 0 the second derivative is undefined and the jumps from -2 to 2.

This function is defined as:

This function is \(C^4\) smooth. The region \(-0.1 < x < 0.1\) is replaced by an 11th order polynomial that approximates \(\text{sgn}(x)x^2\). This function has well behaved derivatives at \(x=0\). If you need to use this function with very small numbers and high accuracy is important, you can scale the argument up (e.g. \(\operatorname{sgnsqr\_c4}(sx)/s^2\)).

These figures show the sgnsqr(x) function compared to the smooth approximation sgnsqr_c4(x).

This function is a signed square root approximation defined as:

This function is \(C^4\) smooth. The region \(-0.1 < x < 0.1\) is replaced by an 11th order polynomial that approximates \(\text{sgn}(x)|x|^{0.5}\). This function has well behaved derivatives at \(x=0\). If you need to use this function with very small numbers and high accuracy is important, you can scale the argument up (e.g. \(\operatorname{sgnsqrt\_c4}(sx)/s^{0.5}\)).

These figures show the signed square root function compared to the smooth approximation sgnsqrt_c4(x).

---

## Parallel Implementation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/parallel.html

**Contents:**
- Parallel Implementation
- Installation

Parallel implementation in parmest is preliminary. To run parmest in parallel, you need the mpi4py Python package and a compatible MPI installation. If you do NOT have mpi4py or a MPI installation, parmest still works (you should not get MPI import errors).

For example, the following command can be used to run the semibatch model in parallel:

The file parallel_example.py is shown below. Results are saved to file for later analysis.

The mpi4py Python package should be installed using conda. The following installation instructions were tested on a Mac with Python 3.5.

Create a conda environment and install mpi4py using the following commands:

This should install libgfortran, mpi, mpi4py, and openmpi.

To verify proper installation, create a Python file with the following:

Save the file as test_mpi.py and run the following command:

The first one should be faster and should start 4 instances of Python.

---

## Objectives — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/objectives.html

**Contents:**
- Objectives

An objective is a function of variables that returns a value that an optimization package attempts to maximize or minimize. The Objective function in Pyomo declares an objective. Although other mechanisms are possible, this function is typically passed the name of another function that gives the expression. Here is a very simple version of such a function that assumes model.x has previously been declared as a Var:

It is more common for an objective function to refer to parameters as in this example that assumes that model.p has been declared as a Param and that model.x has been declared with the same index set, while model.y has been declared as a singleton:

This example uses the sense option to specify maximization. The default sense is minimize.

---

## Covariance Matrix Estimation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/covariance.html

**Contents:**
- Covariance Matrix Estimation

The uncertainty in the estimated parameters is quantified using the covariance matrix. The diagonal of the covariance matrix contains the variance of the estimated parameters. Assuming Gaussian independent and identically distributed measurement errors, the covariance matrix of the estimated parameters can be computed using the following methods which have been implemented in parmest.

Reduced Hessian Method

When the objective function is the sum of squared errors (SSE): \(\text{SSE} = \sum_{i = 1}^n \left(y_{i} - \hat{y}_{i}\right)^2\), the covariance matrix is:

When the objective function is the weighted SSE (WSSE): \(\text{WSSE} = \frac{1}{2} \left(\mathbf{y} - f(\mathbf{x};\boldsymbol{\theta})\right)^\text{T} \mathbf{W} \left(\mathbf{y} - f(\mathbf{x};\boldsymbol{\theta})\right)\), the covariance matrix is:

Where \(V_{\boldsymbol{\theta}}\) is the covariance matrix of the estimated parameters, \(y\) are the observed measured variables, \(\hat{y}\) are the predicted measured variables, \(n\) is the number of data points, \(\boldsymbol{\theta}\) are the unknown parameters, \(\boldsymbol{\theta^*}\) are the estimates of the unknown parameters, \(\mathbf{x}\) are the decision variables, and \(\mathbf{W}\) is a diagonal matrix containing the inverse of the variance of the measurement error, \(\sigma^2\). When the standard deviation of the measurement error is not supplied by the user, parmest approximates the variance of the measurement error as \(\sigma^2 = \frac{1}{n-l} \sum e_i^2\) where \(l\) is the number of fitted parameters, and \(e_i\) is the residual for experiment \(i\).

In parmest, this method computes the inverse of the Hessian by scaling the objective function (SSE or WSSE) with a constant probability factor.

Finite Difference Method

In this method, the covariance matrix, \(V_{\boldsymbol{\theta}}\), is calculated by applying the Gauss-Newton approximation to the Hessian, \(\frac{\partial^2 \text{SSE}}{\partial \boldsymbol{\theta} \partial \boldsymbol{\theta}}\) or \(\frac{\partial^2 \text{WSSE}}{\partial \boldsymbol{\theta} \partial \boldsymbol{\theta}}\), leading to:

This method uses central finite difference to compute the Jacobian matrix, \(\mathbf{G}_{i}\), for experiment \(i\), which is the sensitivity of the measured variables with respect to the parameters, \(\boldsymbol{\theta}\). \(\mathbf{W}\) is a diagonal matrix containing the inverse of the variance of the measurement errors, \(\sigma^2\).

Automatic Differentiation Method


*[Content truncated]*

---

## Pyomo Philosophy — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/index.html

**Contents:**
- Pyomo Philosophy

---

## Modeling in Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/index.html

**Contents:**
- Modeling in Pyomo

---

## Weakly Connected Components — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/connected.html

**Contents:**
- Weakly Connected Components

Partition a matrix into irreducible block diagonal form

This is equivalent to identifying the connected components of the bipartite incidence graph of rows and columns.

matrix (scipy.sparse.coo_matrix) – Matrix to partition into block diagonal form

row_blocks (list of lists) – Partition of row coordinates into diagonal blocks col_blocks (list of lists) – Partition of column coordinates into diagonal blocks

row_blocks (list of lists) – Partition of row coordinates into diagonal blocks

col_blocks (list of lists) – Partition of column coordinates into diagonal blocks

---

## MPC — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/index.html

**Contents:**
- MPC
- Citation

Pyomo MPC contains data structures and utilities for dynamic optimization and rolling horizon applications, e.g. model predictive control.

If you use Pyomo MPC in your research, please cite the following paper:

---

## Sets — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/sets.html

**Contents:**
- Sets
- Declaration
- Operations
- Predefined Virtual Sets
- Sparse Index Sets
  - Sparse Index Sets Example

Sets can be declared using instances of the Set and RangeSet classes or by assigning set expressions. The simplest set declaration creates a set and postpones creation of its members:

The Set class takes optional arguments such as:

Dimension of the members of the set; None for “jagged” sets (where members do not have a uniform length).

String describing the set

A Boolean function used during construction to indicate if a potential new member should be assigned to the set

An iterable containing the initial members of the Set, or function that returns an iterable of the initial members the set.

A Boolean indicator that the set is ordered; the default is True (Set is ordered by insertion order)

A Boolean function that validates new member data

Set used for validation; it is a super-set of the set being declared.

In general, Pyomo attempts to infer the “dimensionality” of Set components (that is, the number of apparent indices) when they are constructed. However, there are situations where Pyomo either cannot detect a dimensionality (e.g., a Set that was not initialized with any members), or you the user may want to assert the dimensionality of the set. This can be accomplished through the dimen keyword. For example, to create a set whose members will be tuples with two items, one could write:

To create a set of all the numbers in set model.A doubled, one could use

As an aside we note that as always in Python, there are lot of ways to accomplish the same thing. Also, note that this will generate an error if model.A contains elements for which multiplication times two is not defined.

The initialize option can accept any Python iterable, including a set, list, or tuple. This data may be returned from a function or specified directly as in

The initialize option can also specify either a generator or a function to specify the Set members. In the case of a generator, all data yielded by the generator will become the initial set members:

For initialization functions, Pyomo supports two signatures. In the first, the function returns an iterable (set, list, or tuple) containing the data with which to initialize the Set:

In the second signature, the function is called for each element, passing the element number in as an extra argument. This is repeated until the function returns the special value Set.End:

Note that the element number starts with 1 and not 0:

Additional information about iterators for set initialization is in the [PyomoBookIII] book.



*[Content truncated]*

---

## Examples — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/examples.html

**Contents:**
- Examples

Examples can be found in pyomo/contrib/parmest/examples and include:

Reactor design example [PyomoBookIII]

Semibatch example [AM00]

Rooney Biegler example [RB01]

Each example includes a Python file that contains the Pyomo model and a Python file to run parameter estimation.

Additional use cases include:

Data reconciliation (reactor design example)

Parameter estimation using data with duplicate sensors and time-series data (reactor design example)

Parameter estimation using mpi4py, the example saves results to a file for later analysis/graphics (semibatch example)

The example below uses the reactor design example. The file reactor_design.py includes a function which returns an populated instance of the Pyomo model. Note that the model is defined to maximize cb and that k1, k2, and k3 are fixed. The _main_ program is included for easy testing of the model declaration.

The file parameter_estimation_example.py uses parmest to estimate values of k1, k2, and k3 by minimizing the sum of squared error between model and observed values of ca, cb, cc, and cd. Additional example files use parmest to run parameter estimation with bootstrap resampling and perform a likelihood ratio test over a range of theta values.

The semibatch and Rooney Biegler examples are defined in a similar manner.

---

## Linear Solver Interfaces — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/tutorial.linear_solver_interfaces.html

**Contents:**
- Linear Solver Interfaces
- Interface to MA27
- Interface to MUMPS

PyNumero’s interfaces to linear solvers are very thin wrappers, and, hence, are rather low-level. It is relatively easy to wrap these again for specific applications. For example, see the linear solver interfaces in https://github.com/Pyomo/pyomo/tree/main/pyomo/contrib/interior_point/linalg, which wrap PyNumero’s linear solver interfaces.

The motivation to keep PyNumero’s interfaces as such thin wrappers is that different linear solvers serve different purposes. For example, HSL’s MA27 can factorize symmetric indefinite matrices, while MUMPS can factorize unsymmetric, symmetric positive definite, or general symmetric matrices. PyNumero seeks to be independent of the application, giving more flexibility to algorithm developers.

Of course, SciPy solvers can also be used. See SciPy documentation for details.

---

## Graphics — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/graphics.html

**Contents:**
- Graphics

parmest includes the following functions to help visualize results:

Grouped boxplots and violinplots are used to compare datasets, generally before and after data reconciliation. Pairwise plots are used to visualize results from parameter estimation and include a histogram of each parameter along the diagonal and a scatter plot for each pair of parameters in the upper and lower sections. The pairwise plot can also include the following optional information:

A single value for each theta (generally theta* from parameter estimation).

Confidence intervals for rectangular, multivariate normal, and/or Gaussian kernel density estimate distributions at a specified level (i.e. 0.8). For plots with more than 2 parameters, theta* is used to extract a slice of the confidence region for each pairwise plot.

Filled contour lines for objective values at a specified level (i.e. 0.8). For plots with more than 2 parameters, theta* is used to extract a slice of the contour lines for each pairwise plot.

The following examples were generated using the reactor design example. Fig. 4 uses output from data reconciliation, Fig. 5 uses output from the bootstrap analysis, and Fig. 6 uses output from the likelihood ratio test.

Fig. 4 Grouped boxplot showing data before and after data reconciliation.

Fig. 5 Pairwise bootstrap plot with rectangular, multivariate normal and kernel density estimation confidence region.

Fig. 6 Pairwise likelihood ratio plot with contours of the objective and points that lie within an alpha confidence region.

---

## Frequently asked questions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/faq.html

**Contents:**
- Frequently asked questions

Why not use Pandas DataFrames?

Pandas DataFrames are a natural data structure for storing “columns” of time series data. These columns, or individual time series, could each represent the data for a single variable. This is very similar to the TimeSeriesData class introduced in this package. The reason a new data structure is introduced is primarily that a DataFrame does not provide any utility for converting labels into a consistent format, as TimeSeriesData does by accepting variables, strings, slices, etc. as keys and converting them into the form of a time-indexed ComponentUID. Also, DataFrames do not have convenient analogs for scalar data and time interval data, which this package provides as the ScalarData and IntervalData classes with very similar APIs to TimeSeriesData.

---

## Infeasibility Diagnostics — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/iis.html

**Contents:**
- Infeasibility Diagnostics
- Infeasible Irreducible System (IIS) Tool
- Minimal Intractable System finder (MIS) Tool
  - Solver
  - Quick Start
  - Interpreting the Output
    - Repair Options
    - Minimal Intractable System (MIS)
    - Constraints / bounds in guards for stability
  - trivial_mis.py

There are two closely related tools for infeasibility diagnosis:

Infeasible Irreducible System (IIS) Tool

Minimal Intractable System finder (MIS) Tool

The first simply provides a conduit for solvers that compute an infeasible irreducible system (e.g., Cplex, Gurobi, or Xpress). The second provides similar functionality, but uses the mis package contributed to Pyomo.

This module contains functions for computing an irreducible infeasible set for a Pyomo MILP or LP using a specified commercial solver, one of CPLEX, Gurobi, or Xpress.

Write an irreducible infeasible set for a Pyomo MILP or LP using the specified commercial solver.

pyomo_model – A Pyomo Block or ConcreteModel

iis_file_name (str) – A file name to write the IIS to, e.g., infeasible_model.ilp

solver (str) – Specify the solver to use, one of “cplex”, “gurobi”, or “xpress”. If None, the tool will use the first solver available.

logger (logging.Logger) – A logger for messages. Uses pyomo.contrib.iis logger by default.

iis_file_name – The file containing the IIS.

The file mis.py finds sets of actions that each, independently, would result in feasibility. The zero-tolerance is whatever the solver uses, so users may want to post-process output if it is going to be used for analysis. It also computes a minimal intractable system (which is not guaranteed to be unique). It was written by Ben Knueven as part of the watertap project (https://github.com/watertap-org/watertap) and is therefore governed by a license shown at the top of mis.py.

The algorithms come from John Chinneck’s slides, see: https://www.sce.carleton.ca/faculty/chinneck/docs/CPAIOR07InfeasibilityTutorial.pdf

At the time of this writing, you need to use IPopt even for LPs.

The file trivial_mis.py is a tiny example listed at the bottom of this help file, which references a Pyomo model with the Python variable m and has these lines:

This is done instead of solving the problem.

IDAES users can pass get_solver() imported from ideas.core.solvers as the solver.

Assuming the dependencies are installed, running trivial_mis.py (shown below) will produce a lot of warnings from IPopt and then meaningful output (using a logger).

This output for the trivial example shows three independent ways that the model could be rendered feasible:

This output shows a minimal intractable system:

This part of the report is for nonlinear programs (NLPs).

When we’re trying to reduce the constraint set, for an NLP there may be constraints that when m

*[Content truncated]*

---

## The Kernel Library — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/experimental/kernel/index.html

**Contents:**
- The Kernel Library
- Notable Improvements
  - More Control of Model Structure
  - Sub-Classing
  - Reduced Memory Usage
  - Direct Support For Conic Constraints with Mosek

Models built with pyomo.kernel components are not yet compatible with pyomo extension modules (e.g., PySP, pyomo.dae, pyomo.gdp).

The pyomo.kernel library is an experimental modeling interface designed to provide a better experience for users doing concrete modeling and advanced application development with Pyomo. It includes the basic set of modeling components necessary to build algebraic models, which have been redesigned from the ground up to make it easier for users to customize and extend. For a side-by-side comparison of pyomo.kernel and pyomo.environ syntax, visit the link below.

Models built from pyomo.kernel components are fully compatible with the standard solver interfaces included with Pyomo. A minimal example script that defines and solves a model is shown below.

Containers in pyomo.kernel are analogous to indexed components in pyomo.environ. However, pyomo.kernel containers allow for additional layers of structure as they can be nested within each other as long as they have compatible categories. The following example shows this using pyomo.kernel.variable containers.

As the next section will show, the standard modeling component containers are also compatible with user-defined classes that derive from the existing modeling components.

The existing components and containers in pyomo.kernel are designed to make sub-classing easy. User-defined classes that derive from the standard modeling components and containers in pyomo.kernel are compatible with existing containers of the same component category. As an example, in the following code we see that the pyomo.kernel.block_list container can store both pyomo.kernel.block objects as well as a user-defined Widget object that derives from pyomo.kernel.block. The Widget object can also be placed on another block object as an attribute and treated itself as a block.

The next series of examples goes into more detail on how to implement derived components or containers.

The following code block shows a class definition for a non-negative variable, starting from pyomo.kernel.variable as a base class.

The NonNegativeVariable class prevents negative values from being stored into its lower bound during initialization or later on through assignment statements (e.g, x.lb = -1 fails). Note that the __slots__ == () line at the beginning of the class definition is optional, but it is recommended if no additional data members are necessary as it reduces the memory requirement of the new variable type.



*[Content truncated]*

---

## API reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/flattener/reference.html

**Contents:**
- API reference

pyomo.dae.flatten.slice_component_along_sets(...)

This function generates all possible slices of the provided component along the provided sets.

pyomo.dae.flatten.flatten_components_along_sets(m, ...)

This function iterates over components (recursively) contained in a block and partitions their data objects into components indexed only by the specified sets.

pyomo.dae.flatten.flatten_dae_components(...)

Partitions components into ComponentData and Components indexed only by the provided set.

This function generates all possible slices of the provided component along the provided sets. That is, it will iterate over the component’s other indexing sets and, for each index, yield a slice along the sets specified in the call signature.

component (Component) – The component whose slices will be yielded

sets (ComponentSet) – ComponentSet of Pyomo sets that will be sliced along

context_slice (IndexedComponent_slice) – If provided, instead of creating a new slice, we will extend this one with appropriate getattr and getitem calls.

normalize (Bool) – If False, the returned index (from the product of “other sets”) is not normalized, regardless of the value of normalize_index.flatten. This is necessary to use this index with _fill_indices.

tuple – The first entry is the index in the product of “other sets” corresponding to the slice, and the second entry is the slice at that index.

This function iterates over components (recursively) contained in a block and partitions their data objects into components indexed only by the specified sets.

m (BlockData) – Block whose components (and their sub-components) will be partitioned

sets (Tuple of Pyomo Sets) – Sets to be sliced. Returned components will be indexed by some combination of these sets, if at all.

ctype (Subclass of Component) – Type of component to identify and partition

indices (Iterable or ComponentMap) – Indices of sets to use when descending into subblocks. If an iterable is provided, the order corresponds to the order in sets. If a ComponentMap is provided, the keys must be in sets.

active (Bool or None) – If not None, this is a boolean flag used to filter component objects by their active status. A reference-to-slice is returned if any data object defined by the slice matches this flag.

The first entry is a list of tuples of Pyomo Sets. The second is a list of lists of Components, indexed by the corresponding sets in the first list. If the components are unindexed, ComponentData are returne

*[Content truncated]*

---

## Solving a square system with a block triangular decomposition — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/tutorial.btsolve.html

**Contents:**
- Solving a square system with a block triangular decomposition

We start with imports. The key function from Incidence Analysis we will use is solve_strongly_connected_components.

Now we construct the model we would like to solve. This is a model with the same structure as the “fixed model” in Debugging a structural singularity with the Dulmage-Mendelsohn partition.

Solving via a block triangular decomposition is useful in cases where the full model does not converge when considered simultaneously by a Newton solver. In this case, we specify a solver to use for the diagonal blocks and call solve_strongly_connected_components.

We can now display the variable values at the solution:

---

## Solving Logic-based Models with Pyomo.GDP — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/gdp/solving.html

**Contents:**
- Solving Logic-based Models with Pyomo.GDP
- Flexible Solution Suite
- Reformulations
  - Logical constraints
    - Conjunctive Normal Form
    - Factorable Programming
  - Reformulation to MI(N)LP
    - Big-M (BM) Reformulation
    - Multiple Big-M (MBM) Reformulation
    - Hull Reformulation (HR)

Once a model is formulated as a GDP model, a range of solution strategies are available to manipulate and solve it.

The traditional approach is reformulation to a MI(N)LP, but various other techniques are possible, including direct solution via the GDPopt solver. Below, we describe some of these capabilities.

Historically users needed to explicitly convert logical propositions to algebraic form prior to invoking the GDP MI(N)LP reformulations or the GDPopt solver. However, this is mathematically incorrect since the GDP MI(N)LP reformulations themselves convert logical formulations to algebraic formulations. The current recommended practice is to pass the entire (mixed logical / algebraic) model to the MI(N)LP reformulations or GDPopt directly.

There are several approaches to convert logical constraints into algebraic form.

The first transformation (core.logical_to_linear) leverages the sympy package to generate the conjunctive normal form of the logical constraints and then adds the equivalent as a list algebraic constraints. The following transforms logical propositions on the model to algebraic form:

The transformation creates a constraint list with a unique name starting with logic_to_linear, within which the algebraic equivalents of the logical constraints are placed. If not already associated with a binary variable, each BooleanVar object will receive a generated binary counterpart. These associated binary variables may be accessed via the get_associated_binary() method.

Additional augmented variables and their corresponding constraints may also be created, as described in Advanced LogicalConstraint Examples.

Following solution of the GDP model, values of the Boolean variables may be updated from their algebraic binary counterparts using the update_boolean_vars_from_binary() function.

Updates all Boolean variables based on the value of their linked binary variables.

The second transformation (contrib.logical_to_disjunctive) leverages ideas from factorable programming to first generate an equivalent set of “factored” logical constraints form by traversing each logical proposition and replacing each logical operator with an additional Boolean variable and then adding the “simple” logical constraint that equates the new Boolean variable with the single logical operator.

The resulting “simple” logical constraints are converted to either MIP or GDP form: if the constraint contains only Boolean variables, then then MIP representation is emitted. L

*[Content truncated]*

---

## “Flattening” a Pyomo model — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/flattener/index.html

**Contents:**
- “Flattening” a Pyomo model
- What does it mean to flatten a model?
- Data structures
- Citation

A module for "flattening" the components in a block-hierarchical model with respect to common indexing sets

When accessing components in a block-structured model, we use component_objects or component_data_objects to access all objects of a specific Component or ComponentData type. The generated objects may be thought of as a “flattened” representation of the model, as they may be accessed without any knowledge of the model’s block structure. These methods are very useful, but it is still challenging to use them to access specific components. Specifically, we often want to access “all components indexed by some set,” or “all component data at a particular index of this set.” In addition, we often want to generate the components in a block that is indexed by our particular set, as these components may be thought of as “implicitly indexed” by this set. The pyomo.dae.flatten module aims to address this use case by providing utilities to generate all components indexed, explicitly or implicitly, by user-provided sets.

When we say “flatten a model,” we mean “recursively generate all components in the model,” where a component can be indexed only by user-specified indexing sets (or is not indexed at all).

The components returned are either ComponentData objects, for components not indexed by any of the provided sets, or references-to-slices, for components indexed, explicitly or implicitly, by the provided sets. Slices are necessary as they can encode “implicit indexing” – where a component is contained in an indexed block. It is natural to return references to these slices, so they may be accessed and manipulated like any other component.

If you use the pyomo.dae.flatten module in your research, we would appreciate you citing the following paper, which gives more detail about the motivation for and examples of using this functionality.

---

## Dulmage-Mendelsohn Partition — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/dulmage_mendelsohn.html

**Contents:**
- Dulmage-Mendelsohn Partition

Named tuple containing the subsets of the Dulmage-Mendelsohn partition when applied to matrix columns (variables).

Alias for field number 2

Alias for field number 3

Alias for field number 1

Alias for field number 0

Named tuple containing the subsets of the Dulmage-Mendelsohn partition when applied to matrix rows (constraints).

Alias for field number 1

Alias for field number 3

Alias for field number 2

Alias for field number 0

Partition a bipartite graph or incidence matrix according to the Dulmage-Mendelsohn characterization

The Dulmage-Mendelsohn partition tells which nodes of the two bipartite sets can possibly be unmatched after a maximum cardinality matching. Applied to an incidence matrix, it can be interpreted as partitioning rows and columns into under-constrained, over-constrained, and well-constrained subsystems.

As it is often useful to explicitly check the unmatched rows and columns, dulmage_mendelsohn partitions rows into the subsets:

underconstrained - The rows matched with possibly unmatched columns (unmatched and underconstrained columns)

square - The well-constrained rows, which are matched with well-constrained columns

overconstrained - The matched rows that can possibly be unmatched in some maximum cardinality matching

unmatched - The unmatched rows in a particular maximum cardinality matching

and partitions columns into the subsets:

unmatched - The unmatched columns in a particular maximum cardinality matching

underconstrained - The columns that can possibly be unmatched in some maximum cardinality matching

square - The well-constrained columns, which are matched with well-constrained rows

overconstrained - The columns matched with possibly unmatched rows (unmatched and overconstrained rows)

While the Dulmage-Mendelsohn decomposition does not specify an order within any of these subsets, the order returned by this function preserves the maximum matching that is used to compute the decomposition. That is, zipping “corresponding” row and column subsets yields pairs in this maximum matching. For example:

matrix_or_graph (scipy.sparse.coo_matrix or networkx.Graph) – The incidence matrix or bipartite graph to be partitioned

top_nodes (list) – List of nodes in one bipartite set of the graph. Must be provided if a graph is provided.

matching (dict) – A maximum cardinality matching in the form of a dict mapping from “top nodes” to their matched nodes and from the matched nodes back to the “top nodes”.

row_dmp (RowPartiti

*[Content truncated]*

---

## Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/expressions.html

**Contents:**
- Expressions
- Rules to Generate Expressions
- Piecewise Linear Expressions
  - Keywords:
- Expression Objects

In this section, we use the word “expression” in two ways: first in the general sense of the word and second to describe a class of Pyomo objects that have the name Expression as described in the subsection on expression objects.

Both objectives and constraints make use of rules to generate expressions. These are Python functions that return the appropriate expression. These are first-class functions that can access global data as well as data passed in, including the model object.

Operations on model elements results in expressions, which seems natural in expressions like the constraints we have seen so far. It is also possible to build up expressions. The following example illustrates this, along with a reference to global Python data in the form of a Python variable called switch:

In this example, the constraint that is generated depends on the value of the Python variable called switch. If the value is 2 or greater, then the constraint is summation(model.c, model.x) - model.d >= 0.5; otherwise, the model.d term is not present.

Because model elements result in expressions, not values, the following does not work as expected in an abstract model!

The trouble is that model.d >= 2 results in an expression, not its evaluated value. Instead use if value(model.d) >= 2

Pyomo supports non-linear expressions and can call non-linear solvers such as Ipopt.

Pyomo has facilities to add piecewise constraints of the form y=f(x) for a variety of forms of the function f.

The piecewise types other than SOS2, BIGM_SOS1, BIGM_BIN are implement as described in the paper [VAN10].

There are two basic forms for the declaration of the constraint:

where pwconst can be replaced by a name appropriate for the application. The choice depends on whether the x and y variables are indexed. If so, they must have the same index sets and these sets are give as the first arguments.

A dictionary of lists (where keys are the index set) or a single list (for the non-indexed case or when an identical set of breakpoints is used across all indices) defining the set of domain breakpoints for the piecewise linear function.

pw_pts is always required. These give the breakpoints for the piecewise function and are expected to fully span the bounds for the independent variable(s).

Indicates the type of piecewise representation to use. This can have a major impact on solver performance. Options: (Default “SOS2”)

“SOS2” - Standard representation using sos2 constraints.

“BIGM_BIN” - BigM co

*[Content truncated]*

---

## PyNumero Installation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/installation.html

**Contents:**
- PyNumero Installation
- Method 1
- Method 2
- Method 3

PyNumero is a module within Pyomo. Therefore, Pyomo must be installed to use PyNumero. PyNumero also has some extensions that need built. There are many ways to build the PyNumero extensions. Common use cases are listed below. However, more information can always be found at https://github.com/Pyomo/pyomo/blob/main/pyomo/contrib/pynumero/build.py and https://github.com/Pyomo/pyomo/blob/main/pyomo/contrib/pynumero/src/CMakeLists.txt.

Note that you will need a C++ compiler and CMake installed to build the PyNumero libraries.

One way to build PyNumero extensions is with the pyomo download-extensions and build-extensions subcommands. Note that this approach will build PyNumero without support for the HSL linear solvers.

If you want PyNumero support for the HSL solvers and you have an IPOPT compilation for your machine, you can build PyNumero using the build script

You can build the PyNumero libraries from source using cmake. This generally works best when building from a source distribution of Pyomo. Assuming that you are starting in the root of the Pyomo source distribution, you can follow the normal CMake build process

---

## Overview — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/overview.html

**Contents:**
- Overview
- Background

The Python package called parmest facilitates model-based parameter estimation along with characterization of uncertainty associated with the estimates. For example, parmest can provide confidence regions around the parameter estimates. Additionally, parameter vectors, each with an attached probability estimate, can be used to build scenarios for design optimization.

Functionality in parmest includes:

Model based parameter estimation using experimental data

Bootstrap resampling for parameter estimation

Confidence regions based on single or multi-variate distributions

Leave-N-out cross validation

The goal of parameter estimation is to estimate values for a vector, \({\theta}\), to use in the functional form

where \(x\) is a vector containing measured data, typically in high dimension, \({\theta}\) is a vector of values to estimate, in much lower dimension, and the response vectors are given as \(y_{i}, i=1,\ldots,m\) with \(m\) also much smaller than the dimension of \(x\). This is done by collecting \(S\) data points, which are \({\tilde{x}},{\tilde{y}}\) pairs and then finding \({\theta}\) values that minimize some function of the deviation between the values of \({\tilde{y}}\) that are measured and the values of \(g({\tilde{x}};{\theta})\) for each corresponding \({\tilde{x}}\), which is a subvector of the vector \(x\). Note that for most experiments, only small parts of \(x\) will change from one experiment to the next.

The following least squares objective can be used to estimate parameter values assuming Gaussian independent and identically distributed measurement errors, where data points are indexed by \(s=1,\ldots,S\)

where \(q_{s}({\theta};{\tilde{x}}_{s}, {\tilde{y}}_{s})\) can be:

Sum of squared errors

Weighted sum of squared errors

i.e., the contribution of sample \(s\) to \(Q\), where \(w \in \Re^{m}\) is a vector containing the standard deviation of the measurement errors of \(y\). Custom objectives can also be defined for parameter estimation.

In the applications of interest to us, the function \(g(\cdot)\) is usually defined as an optimization problem with a large number of (perhaps constrained) optimization variables, a subset of which are fixed at values \({\tilde{x}}\) when the optimization is performed. In other applications, the values of \({\theta}\) are fixed parameter values, but for the problem formulation above, the values of \({\theta}\) are the primary optimization variables. Note that in general, the function \(g(\

*[Content truncated]*

---

## Nonlinear Preprocessing Transformations — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/preprocessing.html

**Contents:**
- Nonlinear Preprocessing Transformations
- Variable Aggregator
- Explicit Constraints to Variable Bounds
- Induced Linearity Reformulation
- Constraint Bounds Tightener
- Trivial Constraint Deactivation
- Fixed Variable Detection
- Fixed Variable Equality Propagator
- Variable Bound Equality Propagator
- Variable Midpoint Initializer

pyomo.contrib.preprocessing is a contributed library of preprocessing transformations intended to operate upon nonlinear and mixed-integer nonlinear programs (NLPs and MINLPs), as well as generalized disjunctive programs (GDPs).

This contributed package is maintained by Qi Chen and his colleagues from Carnegie Mellon University.

The following preprocessing transformations are available. However, some may later be deprecated or combined, depending on their usefulness.

var_aggregator.VariableAggregator

Aggregate model variables that are linked by equality constraints.

bounds_to_vars.ConstraintToVarBoundTransform

Change constraints to be a bound on the variable.

induced_linearity.InducedLinearity

Reformulate nonlinear constraints with induced linearity.

constraint_tightener.TightenConstraintFromVars

deactivate_trivial_constraints.TrivialConstraintDeactivator

Deactivates trivial constraints.

detect_fixed_vars.FixedVarDetector

Detects variables that are de-facto fixed but not considered fixed.

equality_propagate.FixedVarPropagator

Propagate variable fixing for equalities of type \(x = y\).

equality_propagate.VarBoundPropagator

Propagate variable bounds for equalities of type \(x = y\).

init_vars.InitMidpoint

Initialize non-fixed variables to the midpoint of their bounds.

Initialize non-fixed variables to zero.

remove_zero_terms.RemoveZeroTerms

Looks for \(0 v\) in a constraint and removes it.

strip_bounds.VariableBoundStripper

Strip bounds from variables.

zero_sum_propagator.ZeroSumPropagator

Propagates fixed-to-zero for sums of only positive (or negative) vars.

The following code snippet demonstrates usage of the variable aggregation transformation on a concrete Pyomo model:

To see the results of the transformation, you could then use the command

Aggregate model variables that are linked by equality constraints.

TODO: unclear what happens to “capital-E” Expressions at this point in time.

Apply the transformation to the given model.

Create a new model with this transformation

Update the values of the variables that were replaced by aggregates.

Change constraints to be a bound on the variable.

Looks for constraints of form: \(k*v + c_1 \leq c_2\). Changes variable lower bound on \(v\) to match \((c_2 - c_1)/k\) if it results in a tighter bound. Also does the same thing for lower bounds.

Keyword arguments below are specified for the apply_to and create_using functions.

tolerance (NonNegativeFloat, default=1e-13) – tolerance on

*[Content truncated]*

---

## Data Structures — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/data.html

**Contents:**
- Data Structures

automodule:: pyomo.contrib.mpc.data.dynamic_data_base :members: :noindex:

automodule:: pyomo.contrib.mpc.data.scalar_data :members: :noindex:

automodule:: pyomo.contrib.mpc.data.series_data :members: :noindex:

automodule:: pyomo.contrib.mpc.data.interval_data :members: :noindex:

Attempt to convert the provided “var” object into a CUID with wildcards

var – Object to process. May be a VarData, IndexedVar (reference or otherwise), ComponentUID, slice, or string.

sets (Tuple of sets) – Sets to use if slicing a vardata object

dereference (None or int) – Number of times we may access referent attribute to recover a “base component” from a reference.

context (Block) – Block with respect to which slices and CUIDs will be generated

ComponentUID corresponding to the provided var and sets

---

## Variables — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/variables.html

**Contents:**
- Variables

Variables are intended to ultimately be given values by an optimization package. They are declared and optionally bounded, given initial values, and documented using the Pyomo Var function. If index sets are given as arguments to this function they are used to index the variable. Other optional directives include:

bounds = A function (or Python object) that gives a (lower,upper) bound pair for the variable

domain = A set that is a super-set of the values the variable can take on.

initialize = A function (or Python object) that gives a starting value for the variable; this is particularly important for non-linear models

within = (synonym for domain)

The following code snippet illustrates some aspects of these options by declaring a singleton (i.e. unindexed) variable named model.LumberJack that will take on real values between zero and 6 and it initialized to be 1.5:

Instead of the initialize option, initialization is sometimes done with a Python assignment statement as in

For indexed variables, bounds and initial values are often specified by a rule (a Python function) that itself may make reference to parameters or other data. The formal arguments to these rules begins with the model followed by the indexes. This is illustrated in the following code snippet that makes use of Python dictionaries declared as lb and ub that are used by a function to provide bounds:

Many of the pre-defined virtual sets that are used as domains imply bounds. A strong example is the set Boolean that implies bounds of zero and one.

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#gdpopt-implementation-and-optional-arguments

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## Model Transformations — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/transformations.html

**Contents:**
- Model Transformations

---

## Examples — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/mpc/examples.html

**Contents:**
- Examples

Please see pyomo/contrib/mpc/examples/cstr/run_openloop.py and pyomo/contrib/mpc/examples/cstr/run_mpc.py for examples of some simple use cases.

---

## Explanations — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/index.html#explanations

**Contents:**
- Explanations

---

## Block Triangularization — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/triangularize.html

**Contents:**
- Block Triangularization

Compute ordered partitions of the matrix’s rows and columns that permute the matrix to block lower triangular form

Subsets in the partition correspond to diagonal blocks in the block triangularization. The order is topological, with ties broken “lexicographically”.

matrix (scipy.sparse.coo_matrix) – Matrix whose rows and columns will be permuted

matching (dict) – A perfect matching. Maps rows to columns and columns back to rows.

row_partition (list of lists) – A partition of rows. The inner lists hold integer row coordinates. col_partition (list of lists) – A partition of columns. The inner lists hold integer column coordinates.

row_partition (list of lists) – A partition of rows. The inner lists hold integer row coordinates.

col_partition (list of lists) – A partition of columns. The inner lists hold integer column coordinates.

Breaking change in Pyomo 6.5.0

The pre-6.5.0 block_triangularize function returned maps from each row or column to the index of its block in a block lower triangularization as the original intent of this function was to identify when coordinates do or don’t share a diagonal block in this partition. Since then, the dominant use case of block_triangularize has been to partition variables and constraints into these blocks and inspect or solve each block individually. A natural return type for this functionality is the ordered partition of rows and columns, as lists of lists. This functionality was previously available via the get_diagonal_blocks method, which was confusing as it did not capture that the partition was the diagonal of a block triangularization (as opposed to diagonalization). The pre-6.5.0 functionality of block_triangularize is still available via the map_coords_to_block_triangular_indices function.

Deprecated since version 6.5.0: get_blocks_from_maps is deprecated. This functionality has been incorporated into block_triangularize.

Deprecated since version 6.5.0: get_diagonal_blocks has been deprecated. Please use block_triangularize instead.

Return the topologically ordered strongly connected components of a bipartite graph, projected with respect to a perfect matching

The provided undirected bipartite graph is projected into a directed graph on the set of “top nodes” by treating “matched edges” as out-edges and “unmatched edges” as in-edges. Then the strongly connected components of the directed graph are computed. These strongly connected components are unique, regardless of the choice of perfect matchin

*[Content truncated]*

---

## Building Expressions Faster — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/expressions/performance.html

**Contents:**
- Building Expressions Faster
- Expression Generation
- Linear, Quadratic and General Nonlinear Expressions
- Pyomo Utility Functions
  - prod
  - quicksum
  - sum_product

Pyomo expressions can be constructed using native binary operators in Python. For example, a sum can be created in a simple loop:

Additionally, Pyomo expressions can be constructed using functions that iteratively apply Python binary operators. For example, the Python sum() function can be used to replace the previous loop:

The sum() function is both more compact and more efficient. Using sum() avoids the creation of temporary variables, and the summation logic is executed in the Python interpreter while the loop is interpreted.

Pyomo can express a very wide range of algebraic expressions, and there are three general classes of expressions that are recognized by Pyomo:

quadratic polynomials

nonlinear expressions, including higher-order polynomials and expressions with intrinsic functions

These classes of expressions are leveraged to efficiently generate compact representations of expressions, and to transform expression trees into standard forms used to interface with solvers. Note that There not all quadratic polynomials are recognized by Pyomo; in other words, some quadratic expressions are treated as nonlinear expressions.

For example, consider the following quadratic polynomial:

This quadratic polynomial is treated as a nonlinear expression unless the expression is explicitly processed to identify quadratic terms. This lazy identification of of quadratic terms allows Pyomo to tailor the search for quadratic terms only when they are explicitly needed.

Pyomo includes several similar functions that can be used to create expressions:

A function to compute a product of Pyomo expressions.

A function to efficiently compute a sum of Pyomo expressions.

A function that computes a generalized dot product.

The prod function is analogous to the builtin sum() function. Its main argument is a variable length argument list, args, which represents expressions that are multiplied together. For example:

The behavior of the quicksum function is similar to the builtin sum() function, but this function often generates a more compact Pyomo expression. Its main argument is a variable length argument list, args, which represents expressions that are summed together. For example:

The summation is customized based on the start and linear arguments. The start defines the initial value for summation, which defaults to zero. If start is a numeric value, then the linear argument determines how the sum is processed:

If linear is False, then the terms in args are assum

*[Content truncated]*

---

## Pyomo Network — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/network.html#modeling-components

**Contents:**
- Pyomo Network
- Modeling Components
  - Port
  - Arc
- Arc Expansion Transformation
- Sequential Decomposition
  - Creating a Graph
  - Computation Order
  - Tear Selection
  - Running the Sequential Decomposition Procedure

Pyomo Network is a package that allows users to easily represent their model as a connected network of units. Units are blocks that contain ports, which contain variables, that are connected to other ports via arcs. The connection of two ports to each other via an arc typically represents a set of constraints equating each member of each port to each other, however there exist other connection rules as well, in addition to support for custom rules. Pyomo Network also includes a model transformation that will automatically expand the arcs and generate the appropriate constraints to produce an algebraic model that a solver can handle. Furthermore, the package also introduces a generic sequential decomposition tool that can leverage the modeling components to decompose a model and compute each unit in the model in a logically ordered sequence.

Pyomo Network introduces two new modeling components to Pyomo:

A collection of variables, which may be connected to other ports

Component used for connecting the members of two Port objects

A collection of variables, which may be connected to other ports

The idea behind Ports is to create a bundle of variables that can be manipulated together by connecting them to other ports via Arcs. A preprocess transformation will look for Arcs and expand them into a series of constraints that involve the original variables contained within the Port. The way these constraints are built can be specified for each Port member when adding members to the port, but by default the Port members will be equated to each other. Additionally, other objects such as expressions can be added to Ports as long as they, or their indexed members, can be manipulated within constraint expressions.

rule (function) – A function that returns a dict of (name: var) pairs to be initially added to the Port. Instead of var it could also be a tuples of (var, rule). Or it could return an iterable of either vars or tuples of (var, rule) for implied names.

initialize – Follows same specifications as rule’s return value, gets initially added to the Port

implicit – An iterable of names to be initially added to the Port as implicit vars

extends (Port) – A Port whose vars will be added to this Port upon construction

Arc Expansion procedure to generate simple equality constraints

Arc Expansion procedure for extensive variable properties

This procedure is the rule to use when variable quantities should be conserved; that is, split for outlets and combined for

*[Content truncated]*

---

## Suffixes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/suffixes.html

**Contents:**
- Suffixes
- Suffix Notation and the Pyomo NL File Interface
- Declaration
- Operations
- Importing Suffix Data
- Exporting Suffix Data
- Using Suffixes With an AbstractModel

Suffixes provide a mechanism for declaring extraneous model data, which can be used in a number of contexts. Most commonly, suffixes are used by solver plugins to store extra information about the solution of a model. This and other suffix functionality is made available to the modeler through the use of the Suffix component class. Uses of Suffix include:

Importing extra information from a solver about the solution of a mathematical program (e.g., constraint duals, variable reduced costs, basis information).

Exporting information to a solver or algorithm to aid in solving a mathematical program (e.g., warm-starting information, variable branching priorities).

Tagging modeling components with local data for later use in advanced scripting algorithms.

The Suffix component used in Pyomo has been adapted from the suffix notation used in the modeling language AMPL [FGK02]. Therefore, it follows naturally that AMPL style suffix functionality is fully available using Pyomo’s NL file interface. For information on AMPL style suffixes the reader is referred to the AMPL website:

A number of scripting examples that highlight the use AMPL style suffix functionality are available in the examples/pyomo/suffixes directory distributed with Pyomo.

The effects of declaring a Suffix component on a Pyomo model are determined by the following traits:

direction: This trait defines the direction of information flow for the suffix. A suffix direction can be assigned one of four possible values:

LOCAL - suffix data stays local to the modeling framework and will not be imported or exported by a solver plugin (default)

IMPORT - suffix data will be imported from the solver by its respective solver plugin

EXPORT - suffix data will be exported to a solver by its respective solver plugin

IMPORT_EXPORT - suffix data flows in both directions between the model and the solver or algorithm

datatype: This trait advertises the type of data held on the suffix for those interfaces where it matters (e.g., the NL file interface). A suffix datatype can be assigned one of three possible values:

FLOAT - the suffix stores floating point data (default)

INT - the suffix stores integer data

None - the suffix stores any type of data

Exporting suffix data through Pyomo’s NL file interface requires all active export suffixes have a strict datatype (i.e., datatype=None is not allowed).

The following code snippet shows examples of declaring a Suffix component on a Pyomo model:

Declaring a Suf

*[Content truncated]*

---

## Motivation — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/flattener/motivation.html

**Contents:**
- Motivation

The pyomo.dae.flatten module was originally developed to assist with dynamic optimization. A very common operation in dynamic or multi-period optimization is to initialize all time-indexed variables to their values at a specific time point. However, for variables indexed by time and arbitrary other indexing sets, this is difficult to do in a way that does does not depend on the variable we are initializing. Things get worse when we consider that a time index can exist on a parent block rather than the component itself.

By “reshaping” time-indexed variables in a model into references indexed only by time, the flatten_dae_components function allows us to perform operations that depend on knowledge of time indices without knowing anything about the variables that we are operating on.

This “flattened representation” of a model turns out to be useful for dynamic optimization in a variety of other contexts. Examples include constructing a tracking objective function and plotting results. This representation is also useful in cases where we want to preserve indexing along more than one set, as in PDE-constrained optimization. The flatten_components_along_sets function allows partitioning components while preserving multiple indexing sets. In such a case, time and space-indexed data for a given variable is useful for purposes such as initialization, visualization, and stability analysis.

---

## Generating Alternative (Near-)Optimal Solutions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/alternative_solutions.html

**Contents:**
- Generating Alternative (Near-)Optimal Solutions
- Basic Usage Example
- Gap Usage Example
- Interface Documentation

Optimization solvers are generally designed to return a feasible solution to the user. However, there are many applications where a user needs more context than this result. For example,

alternative solutions can support an assessment of trade-offs between competing objectives;

if the optimization formulation may be inaccurate or untrustworthy, then comparisons amongst alternative solutions provide additional insights into the reliability of these model predictions; or

the user may have unexpressed objectives or constraints, which only are realized in later stages of model analysis.

The alternative-solutions library provides a variety of functions that can be used to generate optimal or near-optimal solutions for a pyomo model. Conceptually, these functions are like pyomo solvers. They can be configured with solver names and options, and they return a list of solutions for the pyomo model. However, these functions are independent of pyomo’s solver interface because they return a custom solution object.

The following functions are defined in the alternative-solutions library:

enumerate_binary_solutions

Finds alternative optimal solutions for a binary problem using no-good cuts.

enumerate_linear_solutions

Finds alternative optimal solutions for a (mixed-integer) linear program.

enumerate_linear_solutions_soln_pool

Finds alternative optimal solutions for a (mixed-binary) linear program using Gurobi’s solution pool feature.

gurobi_generate_solutions

Finds alternative optimal solutions for discrete variables using Gurobi’s built-in solution pool capability.

obbt_analysis_bounds_and_solutions

Calculates the bounds on each variable by solving a series of min and max optimization problems where each variable is used as the objective function. This can be applied to any class of problem supported by the selected solver.

Many of the functions in the alternative-solutions library have similar options, so we simply illustrate the enumerate_binary_solutions function. We define a simple knapsack example whose alternative solutions have integer objective values ranging from 0 to 90.

We can execute the enumerate_binary_solutions function to generate a list of Solution objects that represent alternative optimal solutions:

Each Solution object contains information about the objective and variables, and it includes various methods to access this information. For example:

When we only want some of the solutions based off a tolerance away from optimal, this 

*[Content truncated]*

---

## Modeling in Pyomo.GDP — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/gdp/modeling.html

**Contents:**
- Modeling in Pyomo.GDP
- Disjunctions
  - Explicit syntax: more descriptive
  - Compact syntax: more concise
- Logical Propositions
  - Supported Logical Operators
  - Indexed logical constraints
  - Integration with Disjunctions
- Advanced LogicalConstraint Examples
  - Composition of standard operators

To demonstrate modeling with disjunctions in Pyomo.GDP, we revisit the small example from the previous page.

Pyomo.GDP explicit syntax (see below) provides more clarity in the declaration of each modeling object, and gives the user explicit control over the Disjunct names. Assuming the ConcreteModel object m and variables have been defined, lines 1 and 5 declare the Disjunct objects corresponding to selection of unit 1 and 2, respectively. Lines 2 and 6 define the input-output relations for each unit, and lines 3-4 and 7-8 enforce zero flow through the unit that is not selected. Finally, line 9 declares the logical disjunction between the two disjunctive terms.

The indicator variables for each disjunct \(Y_1\) and \(Y_2\) are automatically generated by Pyomo.GDP, accessible via m.unit1.indicator_var and m.unit2.indicator_var.

For more advanced users, a compact syntax is also available below, taking advantage of the ability to declare disjuncts and constraints implicitly. When the Disjunction object constructor is passed a list of lists, the outer list defines the disjuncts and the inner list defines the constraint expressions associated with the respective disjunct.

By default, Pyomo.GDP Disjunction objects enforce an implicit “exactly one” relationship among the selection of the disjuncts (generalization of exclusive-OR). That is, exactly one of the Disjunct indicator variables should take a True value. This can be seen as an implicit logical proposition, in our example, \(Y_1 \veebar Y_2\).

Pyomo.GDP also supports the use of logical propositions through the use of the BooleanVar and LogicalConstraint objects. The BooleanVar object in Pyomo represents Boolean variables, analogous to Var for numeric variables. BooleanVar can be indexed over a Pyomo Set, as below:

Using these Boolean variables, we can define LogicalConstraint objects, analogous to algebraic Constraint objects.

Pyomo.GDP logical expression system supported operators and their usage are listed in the table below.

Y[1].equivalent_to(Y[2])

equivalent(Y[1], Y[2])

We omit support for some infix operators, e.g. Y[1] >> Y[2], due to concerns about non-intuitive Python operator precedence. That is Y[1] | Y[2] >> Y[3] would translate to \(Y_1 \lor (Y_2 \Rightarrow Y_3)\) rather than \((Y_1 \lor Y_2) \Rightarrow Y_3\)

In addition, the following constraint-programming-inspired operators are provided: exactly, atmost, and atleast. These predicates enforce, respectively, that exactly, at most,

*[Content truncated]*

---

## Developer Utilities — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/developer_utils/index.html

**Contents:**
- Developer Utilities

---

## Latex Printing — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling_utils/latex_printer.html

**Contents:**
- Latex Printing
- Examples
  - A Model
  - A Constraint
  - A Constraint with Set Summation
  - Using a ComponentMap to Specify Names
  - An Expression
  - A Simple Expression

Pyomo models can be printed to a LaTeX compatible format using the pyomo.contrib.latex_printer.latex_printer function:

This function produces a string that can be rendered as LaTeX

Prints a Pyomo component (Block, Model, Objective, Constraint, or Expression) to a LaTeX compatible string

pyomo_component (BlockData or Model or Objective or Constraint or Expression) – The Pyomo component to be printed

latex_component_map (pyomo.common.collections.component_map.ComponentMap) – A map keyed by Pyomo component, values become the LaTeX representation in the printer

ostream (io.TextIOWrapper or io.StringIO or str) – The object to print the LaTeX string to. Can be an open file object, string I/O object, or a string for a filename to write to

use_equation_environment (bool) – If False, the equation/aligned construction is used to create a singleLaTeX equation. If True, then the align environment is used in LaTeX and each constraint and objective will be given an individual equation number

LaTeX equation. If True, then the align environment is used in LaTeX and each constraint and objective will be given an individual equation number

explicit_set_summation (bool) – If False, all sums will be done over ‘index in set’ or similar. If True, sums will be done over ‘i=1’ to ‘N’ or similar if the set is a continuous set

throw_templatization_error (bool) – Option to throw an error on templatization failure rather than printing each constraint individually, useful for very large models

A LaTeX string of the pyomo_component

If operating in a Jupyter Notebook, it may be helpful to use:

from IPython.display import display, Math

display(Math(latex_printer(m))

---

## MC++ Interface — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/mcpp.html

**Contents:**
- MC++ Interface
- Default Installation
- Manual Installation

The Pyomo-MC++ interface allows for bounding of factorable functions using the MC++ library developed by the OMEGA research group at Imperial College London. Documentation for MC++ may be found on the MC++ website.

Pyomo now supports automated downloading and compilation of MC++. To install MC++ and other third party compiled extensions, run:

To get and install just MC++, run the following commands in the pyomo/contrib/mcpp directory:

This should install MC++ to the pyomo plugins directory, by default located at $HOME/.pyomo/.

Support for MC++ has only been validated by Pyomo developers using Linux and OSX. Installation instructions for the MC++ library may be found on the MC++ website.

We assume that you have installed MC++ into a directory of your choice. We will denote this directory by $MCPP_PATH. For example, you should see that the file $MCPP_PATH/INSTALL exists.

Navigate to the pyomo/contrib/mcpp directory in your pyomo installation. This directory should contain a file named mcppInterface.cpp. You will need to compile this file using the following command:

This links the MC++ required library FADBAD++, MC++ itself, and Python to compile the Pyomo-MC++ interface. If successful, you will now have a file named mcppInterface.o in your working directory. If you are not using Python 3.7, you will need to link to the appropriate Python version. You now need to create a shared object file with the following command:

You may then test your installation by running the test file:

---

## Debugging a numeric singularity using block triangularization — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/tutorial.bt.html

**Contents:**
- Debugging a numeric singularity using block triangularization

We start with some imports. To debug a numeric singularity, we will need PyomoNLP from PyNumero to get the constraint Jacobian, and will need NumPy to compute condition numbers.

We now build the model we would like to debug. Compared to the model in Debugging a structural singularity with the Dulmage-Mendelsohn partition, we have converted the sum equation to use a sum over component flow rates rather than a sum over mass fractions.

We now construct the incidence graph and check unmatched variables and constraints to validate structural nonsingularity.

Our system is structurally nonsingular. Now we check whether we are numerically nonsingular (well-conditioned) by checking the condition number. Admittedly, deciding if a matrix is “singular” by looking at its condition number is somewhat of an art. We might define “numerically singular” as having a condition number greater than the inverse of machine precision (approximately 1e16), but poorly conditioned matrices can cause problems even if they don’t meet this definition. Here we use 1e10 as a somewhat arbitrary condition number threshold to indicate a problem in our system.

The system is poorly conditioned. Now we can check diagonal blocks of a block triangularization to determine which blocks are causing the poor conditioning.

We see that the second block is causing the singularity, and that this block contains the sum equation that we modified for this example. This suggests that converting this equation to sum over flow rates rather than mass fractions just converted a structural singularity to a numeric singularity, and didn’t really solve our problem. To see a fix that does resolve the singularity, see Debugging a structural singularity with the Dulmage-Mendelsohn partition.

---

## PyROS Solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/index.html

**Contents:**
- PyROS Solver
- Citing PyROS
- Feedback and Reporting Issues

PyROS (Pyomo Robust Optimization Solver) is a Pyomo-based meta-solver for non-convex, two-stage adjustable robust optimization problems.

It was developed by Natalie M. Isenberg, Jason A. F. Sherman, and Chrysanthos E. Gounaris of Carnegie Mellon University, in collaboration with John D. Siirola of Sandia National Laboratories. The developers gratefully acknowledge support from the U.S. Department of Energy’s Institute for the Design of Advanced Energy Systems (IDAES) and Carbon Capture Simulation for Industry Impact (CCSI2) projects.

Index of PyROS Documentation

If you use PyROS in your research, please acknowledge PyROS by citing [IAE+21].

Please provide feedback and/or report any problems by opening an issue on the Pyomo GitHub page.

---

## Incidence Analysis — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/index.html

**Contents:**
- Incidence Analysis

Tools for constructing and analyzing the incidence graph of variables and constraints.

This documentation contains the following resources:

If you are wondering what Incidence Analysis is and would like to learn more, please see Overview. If you already know what Incidence Analysis is and are here for reference, see Incidence Analysis Tutorial or API Reference as needed.

---

## Future Solver Interface Changes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/experimental/solvers.html

**Contents:**
- Future Solver Interface Changes
- New Interface Usage
  - Using the new interfaces through the legacy interface
  - Using the new interfaces directly
  - Using the new interfaces through the “new” SolverFactory
  - Switching all of Pyomo to use the new interfaces
  - Linear Presolve and Scaling
- Interface Implementation
- Results
  - Termination Conditions

The new solver interfaces are still under active development. They are included in the releases as development previews. Please be aware that APIs and functionality may change with no notice.

We welcome any feedback and ideas as we develop this capability. Please post feedback on Issue 1030.

Pyomo offers interfaces into multiple solvers, both commercial and open source. To support better capabilities for solver interfaces, the Pyomo team is actively redesigning the existing interfaces to make them more maintainable and intuitive for use. A preview of the redesigned interfaces can be found in pyomo.contrib.solver.

The new interfaces are not completely backwards compatible with the existing Pyomo solver interfaces. However, to aid in testing and evaluation, we are distributing versions of the new solver interfaces that are compatible with the existing (“legacy”) solver interface. These “legacy” interfaces are registered with the current SolverFactory using slightly different names (to avoid conflicts with existing interfaces).

Name registered in the pyomo.contrib.solver.common.factory.SolverFactory

Name registered in the pyomo.opt.base.solvers.LegacySolverFactory

Here we use the new interface as exposed through the existing (legacy) solver factory and solver interface wrapper. This provides an API that is compatible with the existing (legacy) Pyomo solver interface and can be used with other Pyomo tools / capabilities.

In keeping with our commitment to backwards compatibility, both the legacy and future methods of specifying solver options are supported:

Here we use the new interface by importing it directly:

Here we use the new interface by retrieving it from the new SolverFactory:

We also provide a mechanism to get a “preview” of the future where we replace the existing (legacy) SolverFactory and utilities with the new (development) version (see Accessing preview features):

The new interface allows access to new capabilities in the various problem writers, including the linear presolve and scaling options recently incorporated into the redesigned NL writer. For example, you can control the NL writer in the new ipopt interface through the solver’s writer_config configuration option (see the Ipopt interface documentation).

Note that, by default, both linear_presolve and scale_model are enabled. Users can manipulate linear_presolve and scale_model to their preferred states by changing their values.

All new interfaces should be built upon one of t

*[Content truncated]*

---

## Analysis in Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/index.html

**Contents:**
- Analysis in Pyomo

---

## Managing Expressions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/expressions/managing.html

**Contents:**
- Managing Expressions
- Creating a String Representation of an Expression
  - Algebraic vs. Nested Functional Form
  - Labeler and Symbol Map
  - Other Ways to Generate String Representations
- Evaluating Expressions
- Identifying Components and Variables
- Walking an Expression Tree with a Visitor Class
  - StreamBasedExpressionVisitor Example
  - ExpressionValueVisitor Example

There are several ways that string representations can be created from an expression, but the expression_to_string function provides the most flexible mechanism for generating a string representation. The options to this function control distinct aspects of the string representation.

The default string representation is an algebraic form, which closely mimics the Python operations used to construct an expression. The verbose flag can be set to True to generate a string representation that is a nested functional form. For example:

The string representation used for variables in expression can be customized to define different label formats. If the labeler option is specified, then this function (or class functor) is used to generate a string label used to represent the variable. Pyomo defines a variety of labelers in the pyomo.core.base.label module. For example, the NumericLabeler defines a functor that can be used to sequentially generate simple labels with a prefix followed by the variable count:

The smap option is used to specify a symbol map object (SymbolMap), which caches the variable label data. This option is normally specified in contexts where the string representations for many expressions are being generated. In that context, a symbol map ensures that variables in different expressions have a consistent label in their associated string representations.

There are two other standard ways to generate string representations:

Call the __str__() magic method (e.g. using the Python str() function. This calls expression_to_string, using the default values for all arguments.

Call the to_string() method on the ExpressionBase class. This calls expression_to_string and accepts the same arguments.

Expressions can be evaluated when all variables and parameters in the expression have a value. The value function can be used to walk the expression tree and compute the value of an expression. For example:

Additionally, expressions define the __call__() method, so the following is another way to compute the value of an expression:

If a parameter or variable is undefined, then the value function and __call__() method will raise an exception. This exception can be suppressed using the exception option. For example:

This option is useful in contexts where adding a try block is inconvenient in your modeling script.

Both the value function and __call__() method call the evaluate_expression function. In practice, this function will be slightly faster, but th

*[Content truncated]*

---

## Deprecation and Removal of Functionality — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/developer_utils/deprecation.html

**Contents:**
- Deprecation and Removal of Functionality
- Deprecation
- Removal

During the course of development, there may be cases where it becomes necessary to deprecate or remove functionality from the standard Pyomo offering.

We offer a set of tools to help with deprecation in pyomo.common.deprecation.

By policy, when deprecating or moving an existing capability, one of the following utilities should be leveraged. Each has a required version argument that should be set to current development version (e.g., "6.6.2.dev0"). This version will be updated to the next actual release as part of the Pyomo release process. The current development version can be found by running

on your local fork/branch.

deprecated([msg, logger, version, remove_in])

Decorator to indicate that a function, method, or class is deprecated.

deprecation_warning(msg[, logger, version, ...])

Standardized function for formatting and emitting deprecation warnings.

moved_module(old_name, new_name[, msg, ...])

Provide a deprecation path for moved / renamed modules

relocated_module_attribute(local, target, ...)

Provide a deprecation path for moved / renamed module attributes

RenamedClass(name, bases, classdict, *args, ...)

Metaclass to provide a deprecation path for renamed classes

By policy, functionality should be deprecated with reasonable warning, pending extenuating circumstances. The functionality should be deprecated, following the information above.

If the functionality is documented in the most recent edition of Pyomo - Optimization Modeling in Python, it may not be removed until the next major version release.

For other functionality, it is preferred that ample time is given before removing the functionality. At minimum, significant functionality removal will result in a minor version bump.

---

## Incident Variables — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/incidence.html

**Contents:**
- Incident Variables

Functionality for identifying variables that participate in expressions

Get variables that participate in an expression

The exact variables returned depends on the method used to determine incidence. For example, method=IncidenceMethod.identify_variables will return all variables participating in the expression, while method=IncidenceMethod.standard_repn will return only the variables identified by generate_standard_repn which ignores variables that only appear multiplied by a constant factor of zero.

Keyword arguments must be valid options for IncidenceConfig.

expr (NumericExpression) – Expression to search for variables

List containing the variables that participate in the expression

---

## Incidence Options — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/config.html

**Contents:**
- Incidence Options

Configuration options for incidence graph generation

Methods for identifying variables that participate in expressions

Use pyomo.core.expr.visitor.identify_variables

Use pyomo.repn.standard_repn.generate_standard_repn

Use pyomo.repn.standard_repn.generate_standard_repn with compute_values=True

Use pyomo.repn.ampl.AMPLRepnVisitor

Get an instance of IncidenceConfig from provided keyword arguments.

If the method argument is IncidenceMethod.ampl_repn and no AMPLRepnVisitor has been provided, a new AMPLRepnVisitor is constructed. This function should generally be used by callers such as IncidenceGraphInterface to ensure that a visitor is created then re-used when calling get_incident_variables in a loop.

Options for incidence graph generation

include_fixed – Flag indicating whether fixed variables should be included in the incidence graph

linear_only – Flag indicating whether only variables that participate linearly should be included.

method – Method used to identify incident variables. Must be a value of the IncidenceMethod enum.

_ampl_repn_visitor – Expression visitor used to generate AMPLRepn of each constraint. Must be an instance of AMPLRepnVisitor. This option is constructed automatically when needed and should not be set by users!

---

## Trust Region Framework Method Solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/trustregion.html

**Contents:**
- Trust Region Framework Method Solver
- Methodology Overview
- TRF Inputs
- TRF Solver Interface
- TRF Usage Example
  - Step 0: Import Pyomo
  - Step 1: Define the external function and its gradient
  - Step 2: Create the model
  - Step 3: Solve with TRF

The Trust Region Framework (TRF) method solver allows users to solve hybrid glass box/black box optimization problems in which parts of the system are modeled with open, equation-based models and parts of the system are black boxes. This method utilizes surrogate models that substitute high-fidelity models with low-fidelity basis functions, thus avoiding the direct implementation of the large, computationally expensive high-fidelity models. This is done iteratively, resulting in fewer calls to the computationally expensive functions.

This module implements the method from Yoshio & Biegler [Yoshio & Biegler, 2021] and represents a rewrite of the original 2018 implementation of the algorithm from Eason & Biegler [Eason & Biegler, 2018].

In the context of this updated module, black box functions are implemented as Pyomo External Functions.

This work was conducted as part of the Institute for the Design of Advanced Energy Systems (IDAES) with support through the Simulation-Based Engineering, Crosscutting Research Program within the U.S. Department of Energy’s Office of Fossil Energy and Carbon Management.

The formulation of the original hybrid problem is:

\(w \in \mathbb{R}^m\) are the inputs to the external functions

\(z \in \mathbb{R}^n\) are the remaining decision variables (i.e., degrees of freedom)

\(d(w) : \mathbb{R}^m \to \mathbb{R}^p\) are the outputs of the external functions as a function of \(w\)

\(f\), h, g, d are all assumed to be twice continuously differentiable

This formulation is reworked to separate all external function information as follows to enable the usage of the trust region method:

\(y \in \mathbb{R}^p\) are the outputs of the external functions

\(x^T = [w^T, y^T, z^T]\) is a set of all inputs and outputs

Using this formulation and a user-supplied low-fidelity/ideal model basis function \(b\left(w\right)\), the algorithm iteratively solves subproblems using the surrogate model:

This acts similarly to Newton’s method in that small, incremental steps are taken towards an optimal solution. At each iteration, the current solution of the subproblem is compared to the previous solution to ensure that the iteration has moved in a direction towards an optimal solution. If not true, the step is rejected. If true, the step is accepted and the surrogate model is updated for the next iteration.

When using TRF, please consider citing the above papers.

The required inputs to the TRF solve method are the following:

The optimization 

*[Content truncated]*

---

## PyROS Solver Interface — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/solver_interface.html

**Contents:**
- PyROS Solver Interface
- Instantiation
- Overview of Inputs
  - Deterministic Model
  - First-Stage and Second-Stage Variables
  - Uncertain Parameters
  - Uncertainty Set
  - Subordinate NLP Solvers
  - Optional Arguments
  - Separation Priority Ordering

First-Stage and Second-Stage Variables

Subordinate NLP Solvers

Separation Priority Ordering

The PyROS solver is invoked through the solve() method of an instance of the PyROS solver class, which can be instantiated as follows:

PyROS is designed to operate on a single-objective deterministic model (implemented as a ConcreteModel), from which the robust optimization counterpart is automatically inferred. All variables of the model should be continuous, as mixed-integer problems are not supported.

A model may have either first-stage variables, second-stage variables, or both. PyROS automatically considers all other variables participating in the active model components to be state variables. Further, PyROS assumes that the state variables are uniquely defined by the equality constraints.

Uncertain parameters can be represented by either mutable Param or fixed Var objects. Uncertain parameters cannot be directly represented by Python literals that have been hard-coded into the deterministic model.

A Param object can be made mutable at construction by passing the argument mutable=True to the Param constructor. If specifying/modifying the mutable argument is not straightforward in your context, then add the following lines of code to your script before setting up your deterministic model:

All Param objects declared after the preceding code statements will be made mutable by default.

The uncertainty set is represented by an UncertaintySet object. See the Uncertainty Sets documentation for more information.

PyROS requires at least one subordinate local nonlinear programming (NLP) solver (e.g., Ipopt or CONOPT) and subordinate global NLP solver (e.g., BARON or SCIP) to solve subproblems.

In advance of invoking the PyROS solver, check that your deterministic model can be solved to optimality by either your subordinate local or global NLP solver.

The optional arguments are enumerated in the documentation of the solve() method.

Like other Pyomo solver interface methods, the PyROS solve() method accepts the keyword argument options, which must be a dict mapping names of optional arguments to solve() to their desired values. If an argument is passed directly by keyword and indirectly through options, then the value passed directly takes precedence over the value passed through options.

All required arguments to the PyROS solve() method must be passed directly by position or keyword, or else an exception is raised. Required arguments passed indirectly throu

*[Content truncated]*

---

## Installation Instructions — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/parmest/installation.html

**Contents:**
- Installation Instructions
- Python package dependencies
- IPOPT
- Testing

parmest is included in Pyomo (pyomo/contrib/parmest). To run parmest, you will need Python version 3.x along with various Python package dependencies and the IPOPT software library for non-linear optimization.

matplotlib (optional)

scipy.stats (optional)

mpi4py.MPI (optional)

The IPOPT project homepage is https://github.com/coin-or/Ipopt

The following commands can be used to test parmest:

---

## Pyomo Component Design — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/component_design.html

**Contents:**
- Pyomo Component Design

---

## Getting Started with PyROS — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/getting_started.html

**Contents:**
- Getting Started with PyROS
- Installation
- Quickstart
  - Step 0: Import Pyomo and the PyROS Module
  - Step 1: Define the Solver Inputs
    - Deterministic Model
    - First-Stage and Second-Stage Variables
    - Uncertain Parameters
    - Uncertainty Set
    - Subordinate NLP Solvers

Step 0: Import Pyomo and the PyROS Module

Step 1: Define the Solver Inputs

First-Stage and Second-Stage Variables

Subordinate NLP Solvers

Step 2: Solve With PyROS

Try Higher-Order Decision Rules

Analyzing the Price of Robustness

In advance of using PyROS to solve robust optimization problems, you will need (at least) one local nonlinear programming (NLP) solver (e.g., CONOPT, IPOPT, Knitro) and (at least) one global NLP solver (e.g., BARON, COUENNE, SCIP) installed and licensed on your system.

PyROS can be installed as follows:

Install Pyomo. PyROS is included in the Pyomo software package, at pyomo/contrib/pyros.

Install NumPy and SciPy with your preferred package manager; both NumPy and SciPy are required dependencies of PyROS. You may install NumPy and SciPy with, for example, conda:

(Optional) Test your installation: install pytest and parameterized with your preferred package manager (as in the previous step):

You may then run the PyROS tests as follows:

Some tests involving deterministic NLP solvers may be skipped if IPOPT, BARON, or SCIP is not pre-installed and licensed on your system.

We now provide a quick overview of how to use PyROS to solve a robust optimization problem.

Consider the nonconvex deterministic QCQP

in which \(x\) is the sole first-stage variable, \(z\) is the sole second-stage variable, \(y_1, y_2\) are the state variables, and \(q_1, q_2\) are the uncertain parameters.

The uncertain parameters \(q_1, q_2\) each have a nominal value of 1. We assume that \(q_1, q_2\) can independently deviate from their nominal values by up to \(\pm 10\%\), so that \((q_1, q_2)\) is constrained in value to the interval uncertainty set \(\mathcal{Q} = [0.9, 1.1]^2\).

Per our analysis, our selections of first-stage variables and second-stage variables in the present example satisfy our assumption that the state variable values are uniquely defined.

In anticipation of using the PyROS solver and building the deterministic Pyomo model:

The model can be implemented as follows:

Observe that the uncertain parameters \(q_1, q_2\) are implemented as mutable Param objects. See the Uncertain parameters section of the Solver Interface documentation for further guidance.

We take m.x to be the sole first-stage variable and m.z to be the sole second-stage variable:

The uncertain parameters are represented by m.q1 and m.q2:

As previously discussed, we take the uncertainty set to be the interval \([0.9, 1.1]^2\), which we can implement as a 

*[Content truncated]*

---

## Math Programming — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/index.html

**Contents:**
- Math Programming

---

## MPEC — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/mpec.html

**Contents:**
- MPEC

pyomo.mpec supports modeling complementarity conditions and optimization problems with equilibrium constraints.

---

## PyROS Solver Output Log — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pyros/solver_log.html

**Contents:**
- PyROS Solver Output Log
- Default Format
- Configuring the Output Log

Configuring the Output Log

When the PyROS solve() method is called to solve a robust optimization problem, your console output will, by default, look like this:

Observe that the log contains the following information (listed in order of appearance):

Introductory information and disclaimer (lines 1–19): Includes the version number, author information, (UTC) time at which the solver was invoked, and, if available, information on the local Git branch and commit hash.

Summary of solver options (lines 20–24): Enumeration of specifications for optional arguments to the solver.

Model component statistics (lines 25–34): Breakdown of component statistics for the user-provided model and variable selection (before preprocessing).

Preprocessing information (lines 35–37): Wall time required for preprocessing the deterministic model and associated components, i.e., standardizing model components and adding the decision rule variables and equations.

Iteration log table (lines 38–45): Summary information on the problem iterates and subproblem outcomes. The constituent columns are defined in detail in the table that follows.

Termination message (lines 46–47): One-line message briefly summarizing the reason the solver has terminated.

Final result (lines 48–53): A printout of the ROSolveResults object that is finally returned.

Exit message (lines 54–55): Confirmation that the solver has been exited properly.

The iteration log table is designed to provide, in a concise manner, important information about the progress of the iterative algorithm for the problem of interest. The constituent columns are defined in the table below.

Iteration number, equal to one less than the total number of elapsed iterations.

Master solution objective function value. If the objective of the deterministic model provided has a maximization sense, then the negative of the objective function value is displayed. Expect this value to trend upward as the iteration number increases. A dash (“-”) is produced in lieu of a value if the master problem of the current iteration is not solved successfully.

Infinity norm of the relative difference between the first-stage variable vectors of the master solutions of the current and previous iterations. Expect this value to trend downward as the iteration number increases. A dash (“-”) is produced in lieu of a value if the current iteration number is 0, there are no first-stage variables, or the master problem of the current iteration is not solved s

*[Content truncated]*

---

## Design Details — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/expressions/design.html

**Contents:**
- Design Details
- Expression Classes
- Special Expression Classes
  - Named Expressions
  - Linear Expressions
  - Sum Expressions
  - Mutable Expressions
- Expression Semantics
- Context Managers

Pyomo expression trees are not composed of Python objects from a single class hierarchy. Consequently, Pyomo relies on duck typing to ensure that valid expression trees are created.

Most Pyomo expression trees have the following form

Interior nodes are objects that inherit from the ExpressionBase class. These objects typically have one or more child nodes. Linear expression nodes do not have child nodes, but they are treated as interior nodes in the expression tree because they references other leaf nodes.

Leaf nodes are numeric values, parameter components and variable components, which represent the inputs to the expression.

Expression classes typically represent unary and binary operations. The following table describes the standard operators in Python and their associated Pyomo expression class:

Additionally, there are a variety of other Pyomo expression classes that capture more general logical relationships, which are summarized in the following table:

ExternalFunctionExpression

Expr_if(IF=x, THEN=y, ELSE=z)

UnaryFunctionExpression

Expression objects are immutable. Specifically, the list of arguments to an expression object (a.k.a. the list of child nodes in the tree) cannot be changed after an expression class is constructed. To enforce this property, expression objects have a standard API for accessing expression arguments:

args - a class property that returns a generator that yields the expression arguments

arg(i) - a function that returns the i-th argument

nargs() - a function that returns the number of expression arguments

Developers should never use the _args_ property directly! The semantics for the use of this data has changed since earlier versions of Pyomo. For example, in some expression classes the the value nargs() may not equal len(_args_)!

Expression trees can be categorized in four different ways:

constant expressions - expressions that do not contain numeric constants and immutable parameters.

mutable expressions - expressions that contain mutable parameters but no variables.

potentially variable expressions - expressions that contain variables, which may be fixed.

fixed expressions - expressions that contain variables, all of which are fixed.

These three categories are illustrated with the following example:

The following table describes four different simple expressions that consist of a single model component, and it shows how they are categorized:

not potentially variable

Expressions classes contain methods 

*[Content truncated]*

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#discretization-transformations

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Explanations — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/index.html

**Contents:**
- Explanations

---

## Pyomo Network — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/network.html#sequential-decomposition

**Contents:**
- Pyomo Network
- Modeling Components
  - Port
  - Arc
- Arc Expansion Transformation
- Sequential Decomposition
  - Creating a Graph
  - Computation Order
  - Tear Selection
  - Running the Sequential Decomposition Procedure

Pyomo Network is a package that allows users to easily represent their model as a connected network of units. Units are blocks that contain ports, which contain variables, that are connected to other ports via arcs. The connection of two ports to each other via an arc typically represents a set of constraints equating each member of each port to each other, however there exist other connection rules as well, in addition to support for custom rules. Pyomo Network also includes a model transformation that will automatically expand the arcs and generate the appropriate constraints to produce an algebraic model that a solver can handle. Furthermore, the package also introduces a generic sequential decomposition tool that can leverage the modeling components to decompose a model and compute each unit in the model in a logically ordered sequence.

Pyomo Network introduces two new modeling components to Pyomo:

A collection of variables, which may be connected to other ports

Component used for connecting the members of two Port objects

A collection of variables, which may be connected to other ports

The idea behind Ports is to create a bundle of variables that can be manipulated together by connecting them to other ports via Arcs. A preprocess transformation will look for Arcs and expand them into a series of constraints that involve the original variables contained within the Port. The way these constraints are built can be specified for each Port member when adding members to the port, but by default the Port members will be equated to each other. Additionally, other objects such as expressions can be added to Ports as long as they, or their indexed members, can be manipulated within constraint expressions.

rule (function) – A function that returns a dict of (name: var) pairs to be initially added to the Port. Instead of var it could also be a tuples of (var, rule). Or it could return an iterable of either vars or tuples of (var, rule) for implied names.

initialize – Follows same specifications as rule’s return value, gets initially added to the Port

implicit – An iterable of names to be initially added to the Port as implicit vars

extends (Port) – A Port whose vars will be added to this Port upon construction

Arc Expansion procedure to generate simple equality constraints

Arc Expansion procedure for extensive variable properties

This procedure is the rule to use when variable quantities should be conserved; that is, split for outlets and combined for

*[Content truncated]*

---

## Maximum Matching — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/matching.html

**Contents:**
- Maximum Matching

Return a maximum cardinality matching of the provided matrix or bipartite graph

If a matrix is provided, the matching is returned as a map from row indices to column indices. If a bipartite graph is provided, a list of “top nodes” must be provided as well. These correspond to one of the “bipartite sets”. The matching is then returned as a map from “top nodes” to the other set of nodes.

matrix_or_graph (SciPy sparse matrix or NetworkX Graph) – The matrix or graph whose maximum matching will be computed

top_nodes (list) – Integer nodes representing a bipartite set in a graph. Must be provided if and only if a NetworkX Graph is provided.

max_matching – Dict mapping from integer nodes in the first bipartite set (row indices) to nodes in the second (column indices).

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Experimental features — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/experimental/index.html

**Contents:**
- Experimental features

---

## Suffixes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/suffixes.html#suffixes

**Contents:**
- Suffixes
- Suffix Notation and the Pyomo NL File Interface
- Declaration
- Operations
- Importing Suffix Data
- Exporting Suffix Data
- Using Suffixes With an AbstractModel

Suffixes provide a mechanism for declaring extraneous model data, which can be used in a number of contexts. Most commonly, suffixes are used by solver plugins to store extra information about the solution of a model. This and other suffix functionality is made available to the modeler through the use of the Suffix component class. Uses of Suffix include:

Importing extra information from a solver about the solution of a mathematical program (e.g., constraint duals, variable reduced costs, basis information).

Exporting information to a solver or algorithm to aid in solving a mathematical program (e.g., warm-starting information, variable branching priorities).

Tagging modeling components with local data for later use in advanced scripting algorithms.

The Suffix component used in Pyomo has been adapted from the suffix notation used in the modeling language AMPL [FGK02]. Therefore, it follows naturally that AMPL style suffix functionality is fully available using Pyomo’s NL file interface. For information on AMPL style suffixes the reader is referred to the AMPL website:

A number of scripting examples that highlight the use AMPL style suffix functionality are available in the examples/pyomo/suffixes directory distributed with Pyomo.

The effects of declaring a Suffix component on a Pyomo model are determined by the following traits:

direction: This trait defines the direction of information flow for the suffix. A suffix direction can be assigned one of four possible values:

LOCAL - suffix data stays local to the modeling framework and will not be imported or exported by a solver plugin (default)

IMPORT - suffix data will be imported from the solver by its respective solver plugin

EXPORT - suffix data will be exported to a solver by its respective solver plugin

IMPORT_EXPORT - suffix data flows in both directions between the model and the solver or algorithm

datatype: This trait advertises the type of data held on the suffix for those interfaces where it matters (e.g., the NL file interface). A suffix datatype can be assigned one of three possible values:

FLOAT - the suffix stores floating point data (default)

INT - the suffix stores integer data

None - the suffix stores any type of data

Exporting suffix data through Pyomo’s NL file interface requires all active export suffixes have a strict datatype (i.e., datatype=None is not allowed).

The following code snippet shows examples of declaring a Suffix component on a Pyomo model:

Declaring a Suf

*[Content truncated]*

---

## Incidence Analysis Tutorial — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/tutorial.html

**Contents:**
- Incidence Analysis Tutorial

This tutorial walks through examples of the most common use cases for Incidence Analysis:

---

## Persistent Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/persistent.html#working-with-indexed-variables-and-constraints

**Contents:**
- Persistent Solvers
- Using Persistent Solvers
- Working with Indexed Variables and Constraints
- Persistent Solver Performance

The purpose of the persistent solver interfaces is to efficiently notify the solver of incremental changes to a Pyomo model. The persistent solver interfaces create and store model instances from the Python API for the corresponding solver. For example, the GurobiPersistent class maintains a pointer to a gurobipy Model object. Thus, we can make small changes to the model and notify the solver rather than recreating the entire model using the solver Python API (or rewriting an entire model file - e.g., an lp file) every time the model is solved.

Users are responsible for notifying persistent solver interfaces when changes to a model are made!

The first step in using a persistent solver is to create a Pyomo model as usual.

You can create an instance of a persistent solver through the SolverFactory.

This returns an instance of GurobiPersistent. Now we need to tell the solver about our model.

This will create a gurobipy Model object and include the appropriate variables and constraints. We can now solve the model.

We can also add or remove variables, constraints, blocks, and objectives. For example,

This tells the solver to add one new constraint but otherwise leave the model unchanged. We can now resolve the model.

To remove a component, simply call the corresponding remove method.

If a pyomo component is replaced with another component with the same name, the first component must be removed from the solver. Otherwise, the solver will have multiple components. For example, the following code will run without error, but the solver will have an extra constraint. The solver will have both y >= -2*x + 5 and y <= x, which is not what was intended!

The correct way to do this is:

Components removed from a pyomo model must be removed from the solver instance by the user.

Additionally, unexpected behavior may result if a component is modified before being removed.

In most cases, the only way to modify a component is to remove it from the solver instance, modify it with Pyomo, and then add it back to the solver instance. The only exception is with variables. Variables may be modified and then updated with with solver:

The examples above all used simple variables and constraints; in order to use indexed variables and/or constraints, the code must be slightly adapted:

This must be done when removing variables/constraints, too. Not doing this would result in AttributeError exceptions, for example:

The method “is_indexed” can be used to automate the process

*[Content truncated]*

---

## Persistent Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/persistent.html#using-persistent-solvers

**Contents:**
- Persistent Solvers
- Using Persistent Solvers
- Working with Indexed Variables and Constraints
- Persistent Solver Performance

The purpose of the persistent solver interfaces is to efficiently notify the solver of incremental changes to a Pyomo model. The persistent solver interfaces create and store model instances from the Python API for the corresponding solver. For example, the GurobiPersistent class maintains a pointer to a gurobipy Model object. Thus, we can make small changes to the model and notify the solver rather than recreating the entire model using the solver Python API (or rewriting an entire model file - e.g., an lp file) every time the model is solved.

Users are responsible for notifying persistent solver interfaces when changes to a model are made!

The first step in using a persistent solver is to create a Pyomo model as usual.

You can create an instance of a persistent solver through the SolverFactory.

This returns an instance of GurobiPersistent. Now we need to tell the solver about our model.

This will create a gurobipy Model object and include the appropriate variables and constraints. We can now solve the model.

We can also add or remove variables, constraints, blocks, and objectives. For example,

This tells the solver to add one new constraint but otherwise leave the model unchanged. We can now resolve the model.

To remove a component, simply call the corresponding remove method.

If a pyomo component is replaced with another component with the same name, the first component must be removed from the solver. Otherwise, the solver will have multiple components. For example, the following code will run without error, but the solver will have an extra constraint. The solver will have both y >= -2*x + 5 and y <= x, which is not what was intended!

The correct way to do this is:

Components removed from a pyomo model must be removed from the solver instance by the user.

Additionally, unexpected behavior may result if a component is modified before being removed.

In most cases, the only way to modify a component is to remove it from the solver instance, modify it with Pyomo, and then add it back to the solver instance. The only exception is with variables. Variables may be modified and then updated with with solver:

The examples above all used simple variables and constraints; in order to use indexed variables and/or constraints, the code must be slightly adapted:

This must be done when removing variables/constraints, too. Not doing this would result in AttributeError exceptions, for example:

The method “is_indexed” can be used to automate the process

*[Content truncated]*

---

## Units Handling in Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/units.html

**Contents:**
- Units Handling in Pyomo

Pyomo Units Container Module

This module provides support for including units within Pyomo expressions. This module can be used to define units on a model, and to check the consistency of units within the underlying constraints and expressions in the model. The module also supports conversion of units within expressions using the convert method to support construction of constraints that contain embedded unit conversions.

To use this package within your Pyomo model, you first need an instance of a PyomoUnitsContainer. You can use the module level instance already defined as ‘units’. This object ‘contains’ the units - that is, you can access units on this module using common notation.

Units can be assigned to Var, Param, and ExternalFunction components, and can be used directly in expressions (e.g., defining constraints). You can also verify that the units are consistent on a model, or on individual components like the objective function, constraint, or expression using assert_units_consistent (from pyomo.util.check_units). There are other methods there that may be helpful for verifying correct units on a model.

The implementation is currently based on the pint package and supports all the units that are supported by pint. The list of units that are supported by pint can be found at the following url: https://github.com/hgrecco/pint/blob/master/pint/default_en.txt.

If you need a unit that is not in the standard set of defined units, you can create your own units by adding to the unit definitions within pint. See PyomoUnitsContainer.load_definitions_from_file() or PyomoUnitsContainer.load_definitions_from_strings() for more information.

In this implementation of units, “offset” units for temperature are not supported within expressions (i.e. the non-absolute temperature units including degrees C and degrees F). This is because there are many non-obvious combinations that are not allowable. This concern becomes clear if you first convert the non-absolute temperature units to absolute and then perform the operation. For example, if you write 30 degC + 30 degC == 60 degC, but convert each entry to Kelvin, the expression is not true (i.e., 303.15 K + 303.15 K is not equal to 333.15 K). Therefore, there are several operations that are not allowable with non-absolute units, including addition, multiplication, and division.

This module does support conversion of offset units to absolute units numerically, using convert_value_K_to_C, convert_value_C_to_K, con

*[Content truncated]*

---

## Multistart Solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/multistart.html

**Contents:**
- Multistart Solver
- Using Multistart Solver
- Multistart wrapper implementation and optional arguments

The multistart solver is used in cases where the objective function is known to be non-convex but the global optimum is still desired. It works by running a non-linear solver of your choice multiple times at different starting points, and returns the best of the solutions.

To use the multistart solver, define your Pyomo model as usual:

Solver wrapper that initializes at multiple starting points.

# TODO: also return appropriate duals

For theoretical underpinning, see https://www.semanticscholar.org/paper/How-many-random-restarts-are-enough-Dick-Wong/55b248b398a03dc1ac9a65437f88b835554329e0

Keyword arguments below are specified for the solve function.

strategy (In(dict_keys(['rand', 'midpoint_guess_and_bound', 'rand_guess_and_bound', 'rand_distributed', 'midpoint'])), default='rand') – Specify the restart strategy. ”rand”: random choice between variable bounds ”midpoint_guess_and_bound”: midpoint between current value and farthest bound ”rand_guess_and_bound”: random choice between current value and farthest bound ”rand_distributed”: random choice among evenly distributed values ”midpoint”: exact midpoint between the bounds. If using this option, multiple iterations are useless.

Specify the restart strategy.

”rand”: random choice between variable bounds

”midpoint_guess_and_bound”: midpoint between current value and farthest bound

”rand_guess_and_bound”: random choice between current value and farthest bound

”rand_distributed”: random choice among evenly distributed values

”midpoint”: exact midpoint between the bounds. If using this option, multiple iterations are useless.

solver (default='ipopt') – solver to use, defaults to ipopt

solver_args (default={}) – Dictionary of keyword arguments to pass to the solver.

iterations (default=10) – Specify the number of iterations, defaults to 10. If -1 is specified, the high confidence stopping rule will be used

stopping_mass (default=0.5) – Maximum allowable estimated missing mass of optima for the high confidence stopping rule, only used with the random strategy. The lower the parameter, the stricter the rule. Value bounded in (0, 1].

stopping_delta (default=0.5) – 1 minus the confidence level required for the stopping rule for the high confidence stopping rule, only used with the random strategy. The lower the parameter, the stricter the rule. Value bounded in (0, 1].

suppress_unbounded_warning (bool, default=False) – True to suppress warning for skipping unbounded variables.

HCS_max_iterations (d

*[Content truncated]*

---

## API Reference — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/analysis/incidence/api.html

**Contents:**
- API Reference

---

## Abstract Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/philosophy/abstract_modeling.html

**Contents:**
- Abstract Models

TODO: this is a copy of “Abstract vs Concrete” from Getting Started. This should be expanded here.

A mathematical model can be defined using symbols that represent data values. For example, the following equations represent a linear program (LP) to find optimal values for the vector \(x\) with parameters \(n\) and \(b\), and parameter vectors \(a\) and \(c\):

As a convenience, we use the symbol \(\forall\) to mean “for all” or “for each.”

We call this an abstract or symbolic mathematical model since it relies on unspecified parameter values. Data values can be used to specify a model instance. The AbstractModel class provides a context for defining and initializing abstract optimization models in Pyomo when the data values will be supplied at the time a solution is to be obtained.

In many contexts, a mathematical model can and should be directly defined with the data values supplied at the time of the model definition. We call these concrete mathematical models. For example, the following LP model is a concrete instance of the previous abstract model:

The ConcreteModel class is used to define concrete optimization models in Pyomo.

Python programmers will probably prefer to write concrete models, while users of some other algebraic modeling languages may tend to prefer to write abstract models. The choice is largely a matter of taste; some applications may be a little more straightforward using one or the other.

---

## Special Ordered Sets (SOS) — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/sos_constraints.html

**Contents:**
- Special Ordered Sets (SOS)
- Non-indexed Special Ordered Sets
- Indexed Special Ordered Sets
- Declaring Special Ordered Sets using rules
- Compatible solvers
- Full example with non-indexed SOS constraint

Pyomo allows users to declare special ordered sets (SOS) within their problems. These are sets of variables among which only a certain number of variables can be non-zero, and those that are must be adjacent according to a given order.

Special ordered sets of types 1 (SOS1) and 2 (SOS2) are the classic ones, but the concept can be generalised: a SOS of type N cannot have more than N of its members taking non-zero values, and those that do must be adjacent in the set. These can be useful for modelling and computational performance purposes.

By explicitly declaring these, users can keep their formulations and respective solving times shorter than they would otherwise, since the logical constraints that enforce the SOS do not need to be implemented within the model and are instead (ideally) handled algorithmically by the solver.

Special ordered sets can be declared one by one or indexed via other sets.

A single SOS of type N involving all members of a pyomo Var component can be declared in one line:

In the example above, the weight of each variable is determined automatically based on their position/order in the pyomo Var component (model.x).

Alternatively, the weights can be specified through a pyomo Param component (model.mysosweights) indexed by the set also indexing the variables (model.A):

Multiple SOS of type N involving members of a pyomo Var component (model.x) can be created using two additional sets (model.A and model.mysosvarindexset):

In the example above, the weights are determined automatically from the position of the variables. Alternatively, they can be specified through a pyomo Param component (model.mysosweights) and an additional set (model.C):

Arguably the best way to declare an SOS is through rules. This option allows users to specify the variables and weights through a method provided via the rule parameter. If this parameter is used, users must specify a method that returns one of the following options:

a list of the variables in the SOS, whose respective weights are then determined based on their position;

a tuple of two lists, the first for the variables in the SOS and the second for the respective weights;

or, pyomo.environ.SOSConstraint.Skip, if the SOS is not to be declared.

If one is content on having the weights determined based on the position of the variables, then the following example using the rule parameter is sufficient:

If the weights must be determined in some other way, then the following example illustra

*[Content truncated]*

---

## Block Vectors and Matrices — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/pynumero/tutorial.block_vectors_and_matrices.html

**Contents:**
- Block Vectors and Matrices

Block vectors and matrices (BlockVector and BlockMatrix) provide a mechanism to perform linear algebra operations with very structured matrices and vectors.

When a BlockVector or BlockMatrix is constructed, the number of blocks must be specified.

The flatten method converts the BlockVector into a NumPy array.

The tocoo method converts the BlockMatrix to a SciPy sparse coo_matrix.

Once the dimensions of a block have been set, they cannot be changed:

Much of the BlockVector API matches that of NumPy arrays:

Similarly, BlockMatrix behaves very similarly to SciPy sparse matrices:

Empty blocks in a BlockMatrix return None:

The dimensions of a blocks in a BlockMatrix can be set without setting a block:

Note that operations on BlockVector and BlockMatrix cannot be performed until the dimensions are fully specified:

The has_none property can be used to see if a BlockVector is fully specified. If has_none returns True, then there are None blocks, and the BlockVector is not fully specified.

For BlockMatrix, use the has_undefined_row_sizes() and has_undefined_col_sizes() methods:

To efficiently iterate over non-empty blocks in a BlockMatrix, use the get_block_mask() method, which returns a 2-D array indicating where the non-empty blocks are:

Nested BlockMatrix applications work similarly.

For more information, see the API documentation.

---

## GDPopt logic-based solver — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/gdpopt.html#global-logic-based-outer-approximation-gloa

**Contents:**
- GDPopt logic-based solver
- Logic-based Outer Approximation (LOA)
- Global Logic-based Outer Approximation (GLOA)
- Relaxation with Integer Cuts (RIC)
- Logic-based Branch-and-Bound (LBB)
- Logic-based Discrete-Steepest Descent Algorithm (LD-SDA)
- GDPopt implementation and optional arguments

The GDPopt solver in Pyomo allows users to solve nonlinear Generalized Disjunctive Programming (GDP) models using logic-based decomposition approaches, as opposed to the conventional approach via reformulation to a Mixed Integer Nonlinear Programming (MINLP) model.

The main advantage of these techniques is their ability to solve subproblems in a reduced space, including nonlinear constraints only for True logical blocks. As a result, GDPopt is most effective for nonlinear GDP models.

Four algorithms are available in GDPopt:

Logic-based outer approximation (LOA) [Turkay & Grossmann, 1996]

Global logic-based outer approximation (GLOA) [Lee & Grossmann, 2001]

Logic-based branch-and-bound (LBB) [Lee & Grossmann, 2001]

Logic-based discrete steepest descent algorithm (LD-SDA) [Ovalle et al., 2025]

Usage and implementation details for GDPopt can be found in the PSE 2018 paper (Chen et al., 2018), or via its preprint.

Credit for prototyping and development can be found in the GDPopt class documentation, below.

GDPopt can be used to solve a Pyomo.GDP concrete model in two ways. The simplest is to instantiate the generic GDPopt solver and specify the desired algorithm as an argument to the solve method:

The alternative is to instantiate an algorithm-specific GDPopt solver:

In the above examples, GDPopt uses the GDPopt-LOA algorithm. Other algorithms may be used by specifying them in the algorithm argument when using the generic solver or by instantiating the algorithm-specific GDPopt solvers. All GDPopt options are listed below.

The generic GDPopt solver allows minimal configuration outside of the arguments to the solve method. To avoid repeatedly specifying the same configuration options to the solve method, use the algorithm-specific solvers.

Chen et al., 2018 contains the following flowchart, taken from the preprint version:

An example that includes the modeling approach may be found below.

When troubleshooting, it can often be helpful to turn on verbose output using the tee flag.

The same algorithm can be used to solve GDPs involving nonconvex nonlinear constraints by solving the subproblems globally:

The nlp_solver option must be set to a global solver for the solution returned by GDPopt to also be globally optimal.

Instead of outer approximation, GDPs can be solved using the same MILP relaxation as in the previous two algorithms, but instead of using the subproblems to generate outer-approximation cuts, the algorithm adds only no-good cuts fo

*[Content truncated]*

---

## Dynamic Optimization with pyomo.DAE — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/dae.html#dynamic-model-simulation

**Contents:**
- Dynamic Optimization with pyomo.DAE
- Modeling Components
  - ContinuousSet
  - DerivativeVar
- Declaring Differential Equations
- Declaring Integrals
- Discretization Transformations
  - Finite Difference Transformation
  - Collocation Transformation
    - Restricting Optimal Control Profiles

The pyomo.DAE modeling extension [PyomoDAE-paper] allows users to incorporate systems of differential algebraic equations (DAE)s in a Pyomo model. The modeling components in this extension are able to represent ordinary or partial differential equations. The differential equations do not have to be written in a particular format and the components are flexible enough to represent higher-order derivatives or mixed partial derivatives. Pyomo.DAE also includes model transformations which use simultaneous discretization approaches to transform a DAE model into an algebraic model. Finally, pyomo.DAE includes utilities for simulating DAE models and initializing dynamic optimization problems.

Pyomo.DAE introduces three new modeling components to Pyomo:

pyomo.dae.ContinuousSet

Represents a bounded continuous domain

pyomo.dae.DerivativeVar

Represents derivatives in a model and defines how a Var is differentiated

Represents an integral over a continuous domain

As will be shown later, differential equations can be declared using using these new modeling components along with the standard Pyomo Var and Constraint components.

This component is used to define continuous bounded domains (for example ‘spatial’ or ‘time’ domains). It is similar to a Pyomo Set component and can be used to index things like variables and constraints. Any number of ContinuousSets can be used to index a component and components can be indexed by both Sets and ContinuousSets in arbitrary order.

In the current implementation, models with ContinuousSet components may not be solved until every ContinuousSet has been discretized. Minimally, a ContinuousSet must be initialized with two numeric values representing the upper and lower bounds of the continuous domain. A user may also specify additional points in the domain to be used as finite element points in the discretization.

Represents a bounded continuous domain

Minimally, this set must contain two numeric values defining the bounds of a continuous range. Discrete points of interest may be added to the continuous set. A continuous set is one dimensional and may only contain numerical values.

initialize (list) – Default discretization points to be included

bounds (tuple) – The bounding points for the continuous domain. The bounds will be included as discrete points in the ContinuousSet and will be used to bound the points added to the ContinuousSet through the ‘initialize’ argument, a data file, or the add() method

This keeps track 

*[Content truncated]*

---

## Persistent Solvers — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/solvers/persistent.html#persistent-solver-performance

**Contents:**
- Persistent Solvers
- Using Persistent Solvers
- Working with Indexed Variables and Constraints
- Persistent Solver Performance

The purpose of the persistent solver interfaces is to efficiently notify the solver of incremental changes to a Pyomo model. The persistent solver interfaces create and store model instances from the Python API for the corresponding solver. For example, the GurobiPersistent class maintains a pointer to a gurobipy Model object. Thus, we can make small changes to the model and notify the solver rather than recreating the entire model using the solver Python API (or rewriting an entire model file - e.g., an lp file) every time the model is solved.

Users are responsible for notifying persistent solver interfaces when changes to a model are made!

The first step in using a persistent solver is to create a Pyomo model as usual.

You can create an instance of a persistent solver through the SolverFactory.

This returns an instance of GurobiPersistent. Now we need to tell the solver about our model.

This will create a gurobipy Model object and include the appropriate variables and constraints. We can now solve the model.

We can also add or remove variables, constraints, blocks, and objectives. For example,

This tells the solver to add one new constraint but otherwise leave the model unchanged. We can now resolve the model.

To remove a component, simply call the corresponding remove method.

If a pyomo component is replaced with another component with the same name, the first component must be removed from the solver. Otherwise, the solver will have multiple components. For example, the following code will run without error, but the solver will have an extra constraint. The solver will have both y >= -2*x + 5 and y <= x, which is not what was intended!

The correct way to do this is:

Components removed from a pyomo model must be removed from the solver instance by the user.

Additionally, unexpected behavior may result if a component is modified before being removed.

In most cases, the only way to modify a component is to remove it from the solver instance, modify it with Pyomo, and then add it back to the solver instance. The only exception is with variables. Variables may be modified and then updated with with solver:

The examples above all used simple variables and constraints; in order to use indexed variables and/or constraints, the code must be slightly adapted:

This must be done when removing variables/constraints, too. Not doing this would result in AttributeError exceptions, for example:

The method “is_indexed” can be used to automate the process

*[Content truncated]*

---

## Parameters — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/explanation/modeling/math_programming/parameters.html

**Contents:**
- Parameters

The word “parameters” is used in many settings. When discussing a Pyomo model, we use the word to refer to data that must be provided in order to find an optimal (or good) assignment of values to the decision variables. Parameters are declared as instances of a Param class, which takes arguments that are somewhat similar to the Set class. For example, the following code snippet declares sets model.A and model.B, and then a parameter model.P that is indexed by model.A and model.B:

In addition to sets that serve as indexes, Param takes the following options:

default = The parameter value absent any other specification.

doc = A string describing the parameter.

initialize = A function (or Python object) that returns data used to initialize the parameter values.

mutable = Boolean value indicating if the Param values are allowed to change after the Param is initialized.

validate = A callback function that takes the model, proposed value, and indices of the proposed value; returning True if the value is valid. Returning False will generate an exception.

within = Set used for validation; it specifies the domain of valid parameter values.

These options perform in the same way as they do for Set. For example, given model.A with values {1, 2, 3}, then there are many ways to create a parameter that represents a square matrix with 9, 16, 25 on the main diagonal and zeros elsewhere, here are two ways to do it. First using a Python object to initialize:

And now using an initialization function that is automatically called once for each index tuple (remember that we are assuming that model.A contains {1, 2, 3})

In this example, the index set contained integers, but index sets need not be numeric. It is very common to use strings.

Data specified in an input file will override the data specified by the initialize option.

Parameter values can be checked by a validation function. In the following example, the every value of the parameter T (indexed by model.A) is checked to be greater than 3.14159. If a value is provided that is less than that, the model instantiation will be terminated and an error message issued. The validation function should be written so as to return True if the data is valid and False otherwise.

This example will prodice the following error, indicating that the value provided for T[2] failed validation:

---
