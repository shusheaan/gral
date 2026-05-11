# Pyomo - Howto

**Pages:** 44

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#varaccess

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Working with Abstract Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/index.html#working-with-abstract-models

**Contents:**
- Working with Abstract Models

---

## BuildAction and BuildCheck — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/BuildAction.html

**Contents:**
- BuildAction and BuildCheck

This is a somewhat advanced topic. In some cases, it is desirable to trigger actions to be done as part of the model building process. The BuildAction function provides this capability in a Pyomo model. It takes as arguments optional index sets and a function to perform the action. For example,

calls the function bpts_build for each member of model.J. The function bpts_build should have the model and a variable for the members of model.J as formal arguments. In this example, the following would be a valid declaration for the function:

A full example, which extends the Symbolic Index Sets and Piecewise Linear Expressions examples, is

This example uses the build action to create a model component with breakpoints for a Piecewise Linear Expressions function. The BuildAction is triggered by the assignment to model.BuildBpts. This object is not referenced again, the only goal is to cause the execution of bpts_build, which places data in the model.bpts dictionary. Note that if model.bpts had been a Set, then it could have been created with an initialize argument to the Set declaration. Since it is a special-purpose dictionary to support the Piecewise Linear Expressions functionality in Pyomo, we use a BuildAction.

Another application of BuildAction can be initialization of Pyomo model data from Python data structures, or efficient initialization of Pyomo model data from other Pyomo model data. Consider the Sparse Index Sets example. Rather than using an initialization for each list of sets NodesIn and NodesOut separately using initialize, it is a little more efficient and probably a little clearer, to use a build action.

For this model, the same data file can be used as for Isinglecomm.py in Sparse Index Sets such as the toy data file:

Build actions can also be a way to implement data validation, particularly when multiple Sets or Parameters must be analyzed. However, the the BuildCheck component is preferred for this purpose. It executes its rule just like a BuildAction but will terminate the construction of the model instance if the rule returns False.

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#changing-the-model-or-data-and-re-solving

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#accessing-parameter-values

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#interrogating-models

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Data Command Files — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/datfiles.html

**Contents:**
- Data Command Files
- Model Data
- The set Command
  - Simple Sets
  - Sets of Tuple Data
  - Set Arrays
- The param Command
  - One-dimensional Parameter Data
  - Multi-Dimensional Parameter Data
- The table Command

The discussion and presentation below are adapted from Chapter 6 of the second edition of the “Pyomo Book” [PyomoBookII]. The discussion of the DataPortal class uses these same examples to illustrate how data can be loaded into Pyomo models within Python scripts (see the Data Portals section).

Pyomo’s data command files employ a domain-specific language whose syntax closely resembles the syntax of AMPL’s data commands [FGK02]. A data command file consists of a sequence of commands that either (a) specify set and parameter data for a model, or (b) specify where such data is to be obtained from external sources (e.g. table files, CSV files, spreadsheets and databases).

The following commands are used to declare data:

The set command declares set data.

The param command declares a table of parameter data, which can also include the declaration of the set data used to index the parameter data.

The table command declares a two-dimensional table of parameter data.

The load command defines how set and parameter data is loaded from external data sources, including ASCII table files, CSV files, XML files, YAML files, JSON files, ranges in spreadsheets, and database tables.

The following commands are also used in data command files:

The include command specifies a data command file that is processed immediately.

The data and end commands do not perform any actions, but they provide compatibility with AMPL scripts that define data commands.

The namespace keyword allows data commands to be organized into named groups that can be enabled or disabled during model construction.

The following data types can be represented in a data command file:

Numeric value: Any Python numeric value (e.g. integer, float, scientific notation, or boolean).

Simple string: A sequence of alpha-numeric characters.

Quoted string: A simple string that is included in a pair of single or double quotes. A quoted string can include quotes within the quoted string.

Numeric values are automatically converted to Python integer or floating point values when a data command file is parsed. Additionally, if a quoted string can be interpreted as a numeric value, then it will be converted to Python numeric types when the data is parsed. For example, the string “100” is converted to a numeric value automatically.

Pyomo data commands do not exactly correspond to AMPL data commands. The set and param commands are designed to closely match AMPL’s syntax and semantics, though these commands only 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#accessing-slacks

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#access-duals-in-a-python-script

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#primal-variable-values

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#display-of-solver-output

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Using a Python Dictionary — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/raw_dicts.html

**Contents:**
- Using a Python Dictionary

Data can be passed to the model create_instance() method through a series of nested native Python dictionaries. The structure begins with a dictionary of namespaces, with the only required entry being the None namespace. Each namespace contains a dictionary that maps component names to dictionaries of component values. For scalar components, the required data dictionary maps the implicit index None to the desired value:

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#activating-and-deactivating-objectives

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#activating-and-deactivating-constraints

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#specifying-the-path-to-a-solver

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#sending-options-to-the-solver

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Using Standard Data Types — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/native.html

**Contents:**
- Using Standard Data Types
- Defining Constant Values
- Initializing Set and Parameter Components
  - Set Components
  - Parameter Components

In many cases, Pyomo models can be constructed without Set and Param data components. Native Python data types class can be simply used to define constant values in Pyomo expressions. Consequently, Python sets, lists and dictionaries can be used to construct Pyomo models, as well as a wide range of other Python classes.

More examples here: set, list, dict, numpy, pandas.

The Set and Param components used in a Pyomo model can also be initialized with standard Python data types. This enables some modeling efficiencies when manipulating sets (e.g. when re-using sets for indices), and it supports validation of set and parameter data values. The Set and Param components are initialized with Python data using the initialize option.

In general, Set components can be initialized with iterable data. For example, simple sets can be initialized with:

list, set and tuple data:

Sets can also be indirectly initialized with functions that return native Python data:

Indexed sets can be initialized with dictionary data where the dictionary values are iterable data:

When a parameter is a single value, then a Param component can be simply initialized with a value:

More generally, Param components can be initialized with dictionary data where the dictionary values are single values:

Parameters can also be indirectly initialized with functions that return native Python data:

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#manipulating-pyomo-models

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#solving-multiple-instances-in-parallel

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Data Portals — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/dataportals.html

**Contents:**
- Data Portals
- Loading Structured Data
- Loading Tabular Data
  - Tabular Data
  - Loading Set Data
    - Loading a Simple Set
    - Loading a Set of Tuples
    - Loading a Set Array
  - Loading Parameter Data
    - Loading a Simple Parameter

Pyomo’s DataPortal class standardizes the process of constructing model instances by managing the process of loading data from different data sources in a uniform manner. A DataPortal object can load data from the following data sources:

TAB File: A text file format that uses whitespace to separate columns of values in each row of a table.

CSV File: A text file format that uses comma or other delimiters to separate columns of values in each row of a table.

JSON File: A popular lightweight data-interchange format that is easily parsed.

YAML File: A human friendly data serialization standard.

XML File: An extensible markup language for documents and data structures. XML files can represent tabular data.

Excel File: A spreadsheet data format that is primarily used by the Microsoft Excel application.

Database: A relational database.

DAT File: A Pyomo data command file.

Note that most of these data formats can express tabular data.

The DataPortal class requires the installation of Python packages to support some of these data formats:

Excel File: win32com, openpyxl or xlrd

These packages support different data Excel data formats: the win32com package supports .xls, .xlsm and .xlsx, the openpyxl package supports .xlsx and the xlrd package supports .xls.

Database: pyodbc, pypyodbc, sqlite3 or pymysql

These packages support different database interface APIs: the pyodbc and pypyodbc packages support the ODBC database API, the sqlite3 package uses the SQLite C library to directly interface with databases using the DB-API 2.0 specification, and pymysql is a pure-Python MySQL client.

DataPortal objects can be used to initialize both concrete and abstract Pyomo models. Consider the file A.tab, which defines a simple set with a tabular format:

The load method is used to load data into a DataPortal object. Components in a concrete model can be explicitly initialized with data loaded by a DataPortal object:

All data needed to initialize an abstract model must be provided by a DataPortal object, and the use of the DataPortal object to initialize components is automated for the user:

Note the difference in the execution of the load method in these two examples: for concrete models data is loaded by name and the format must be specified, and for abstract models the data is loaded by component, from which the data format can often be inferred.

The load method opens the data file, processes it, and loads the data in a format that can be used to construct a m

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#accessing-variable-values

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Managing Data in AbstractModels — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/index.html

**Contents:**
- Managing Data in AbstractModels

There are roughly three ways of using data to construct a Pyomo model:

use standard Python objects,

initialize a model with data loaded with a DataPortal object, and

load model data from a Pyomo data command file.

Standard Python data objects include native Python data types (e.g. lists, sets, and dictionaries) as well as standard data formats like numpy arrays and Pandas data frames. Standard Python data objects can be used to define constant values in a Pyomo model, and they can be used to initialize Set and Param components. However, initializing Set and Param components in this manner provides few advantages over direct use of standard Python data objects. (An import exception is that components indexed by Set objects use less memory than components indexed by native Python data.)

The DataPortal class provides a generic facility for loading data from disparate sources. A DataPortal object can load data in a consistent manner, and this data can be used to simply initialize all Set and Param components in a model. DataPortal objects can be used to initialize both concrete and abstract models in a uniform manner, which is important in some scripting applications. But in practice, this capability is only necessary for abstract models, whose data components are initialized after being constructed. (In fact, all abstract data components in an abstract model are loaded from DataPortal objects.)

Finally, Pyomo data command files provide a convenient mechanism for initializing Set and Param components with a high-level data specification. Data command files can be used with both concrete and abstract models, though in a different manner. Data command files are parsed using a DataPortal object, which must be done explicitly for a concrete model. However, abstract models can load data from a data command file directly, after the model is constructed. Again, this capability is only necessary for abstract models, whose data components are initialized after being constructed.

The following sections provide more detail about how data can be used to initialize Pyomo models.

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#solver-recipes

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#extending-the-objective-function

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## The pyomo Command — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/pyomo_command.html

**Contents:**
- The pyomo Command
- Passing Options to a Solver
- Troubleshooting
- Direct Interfaces to Solvers

The pyomo command is issued to the DOS prompt or a Unix shell. To see a list of Pyomo command line options, use:

There are two dashes before help.

In this section we will detail some of the options.

To pass arguments to a solver when using the pyomo solve command, append the Pyomo command line with the argument --solver-options= followed by an argument that is a string to be sent to the solver (perhaps with dashes added by Pyomo). So for most MIP solvers, the mip gap can be set using

Multiple options are separated by a space. Options that do not take an argument should be specified with the equals sign followed by either a space or the end of the string.

For example, to specify that the solver is GLPK, then to specify a mipgap of two percent and the GLPK cuts option, use

If there are multiple “levels” to the keyword, as is the case for some Gurobi and CPLEX options, the tokens are separated by underscore. For example, mip cuts all would be specified as mip_cuts_all. For another example, to set the solver to be CPLEX, then to set a mip gap of one percent and to specify ‘y’ for the sub-option numerical to the option emphasis use

See Sending Options to the Solver for a discussion of passing options in a script.

Many of things that can go wrong are covered by error messages, but sometimes they can be confusing or do not provide enough information. Depending on what the troubles are, there might be ways to get a little additional information.

If there are syntax errors in the model file, for example, it can occasionally be helpful to get error messages directly from the Python interpreter rather than through Pyomo. Suppose the name of the model file is scuc.py, then

can sometimes give useful information for fixing syntax errors.

When there are no syntax errors, but there troubles reading the data or generating the information to pass to a solver, then the --verbose option provides a trace of the execution of Pyomo. The user should be aware that for some models this option can generate a lot of output.

If there are troubles with solver (i.e., after Pyomo has output “Applying Solver”), it is often helpful to use the option --stream-solver that causes the solver output to be displayed rather than trapped. (See <<TeeTrue>> for information about getting this output in a script). Advanced users may wish to examine the files that are generated to be passed to a solver. The type of file generated is controlled by the --solver-io option and the --keepfiles o

*[Content truncated]*

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#fixing-variables-and-re-solving

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#warm-starts

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#paramaccess

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Manipulating Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/manipulating.html#repeated-solves

**Contents:**
- Manipulating Pyomo Models
- Repeated Solves
- Changing the Model or Data and Re-solving
- Fixing Variables and Re-solving
- Extending the Objective Function
- Activating and Deactivating Objectives
- Activating and Deactivating Constraints

This section gives an overview of commonly used scripting commands when working with Pyomo models. These commands must be applied to a concrete model instance or in other words an instantiated model.

To illustrate Python scripts for Pyomo we consider an example that is in the file iterative1.py and is executed using the command

This is a Python script that contains elements of Pyomo, so it is executed using the python command. The pyomo command can be used, but then there will be some strange messages at the end when Pyomo finishes the script and attempts to send the results to a solver, which is what the pyomo command does.

This script creates a model, solves it, and then adds a constraint to preclude the solution just found. This process is repeated, so the script finds and prints multiple solutions. The particular model it creates is just the sum of four binary variables. One does not need a computer to solve the problem or even to iterate over solutions. This example is provided just to illustrate some elementary aspects of scripting.

Let us now analyze this script. The first line is a comment that happens to give the name of the file. This is followed by two lines that import symbols for Pyomo. The pyomo namespace is imported as pyo. Therefore, pyo. must precede each use of a Pyomo name.

An object to perform optimization is created by calling SolverFactory with an argument giving the name of the solver. The argument would be 'gurobi' if, e.g., Gurobi was desired instead of glpk:

The next lines after a comment create a model. For our discussion here, we will refer to this as the base model because it will be extended by adding constraints later. (The words “base model” are not reserved words, they are just being introduced for the discussion of this example). There are no constraints in the base model, but that is just to keep it simple. Constraints could be present in the base model. Even though it is an abstract model, the base model is fully specified by these commands because it requires no external data:

The next line is not part of the base model specification. It creates an empty constraint list that the script will use to add constraints.

The next non-comment line creates the instantiated model and refers to the instance object with a Python variable instance. Models run using the pyomo script do not typically contain this line because model instantiation is done by the pyomo script. In this example, the create function is called withou

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#accessing-duals

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## How-To Guides — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/index.html

**Contents:**
- How-To Guides

---

## Debugging Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/debugging.html#debugging-models

**Contents:**
- Debugging Models

---

## Debugging Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/debugging.html

**Contents:**
- Debugging Models

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#accessing-solver-status

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Working with Abstract Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/index.html

**Contents:**
- Working with Abstract Models

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#all-variables-from-a-python-script

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---

## Instantiating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/instantiating_models.html

**Contents:**
- Instantiating Models

If you start with a ConcreteModel, each component you add to the model will be fully constructed and initialized at the time it attached to the model. However, if you are starting with an AbstractModel, construction occurs in two phases. When you first declare and attach components to the model, those components are empty containers and not fully constructed, even if you explicitly provide data.

If you look at the model at this point, you will see that everything is “empty”:

Before you can manipulate modeling components or solve the model, you must first create a concrete instance by applying data to your abstract model. This can be done using the create_instance() method, which takes the abstract model and optional data and returns a new concrete instance by constructing each of the model components in the order in which they were declared (attached to the model). Note that the instance creation is performed “out of place”; that is, the original abstract model is left untouched.

AbstractModel users should note that in some examples, your concrete model instance is called “instance” and not “model”. This is the case here, where we are explicitly calling instance = model.create_instance().

The create_instance() method can also take a reference to external data, which overrides any data specified in the original component declarations. The data can be provided from several sources, including using a dict, DataPortal, or DAT file. For example:

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html#changing-the-temporary-directory

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Storing Data from Pyomo Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/abstract_models/data/storing_data.html

**Contents:**
- Storing Data from Pyomo Models
- Storing Model Data in Excel

Currently, Pyomo has rather limited capabilities for storing model data into standard Python data types and serialized data formats. However, this capability is under active development.

---

## How-To Guides — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/index.html#how-to-guides

**Contents:**
- How-To Guides

---

## Solver Recipes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/solver_recipes.html

**Contents:**
- Solver Recipes
- Accessing Solver Status
- Display of Solver Output
- Sending Options to the Solver
- Specifying the Path to a Solver
- Warm Starts
- Solving Multiple Instances in Parallel
- Changing the temporary directory

After a solve, the results object has a member Solution.Status that contains the solver status. The following snippet shows an example of access via a print statement:

The use of the Python str function to cast the value to a be string makes it easy to test it. In particular, the value ‘optimal’ indicates that the solver succeeded. It is also possible to access Pyomo data that can be compared with the solver status as in the following code snippet:

To see the output of the solver, use the option tee=True as in

This can be useful for troubleshooting solver difficulties.

Most solvers accept options and Pyomo can pass options through to a solver. In scripts or callbacks, the options can be attached to the solver object by adding to its options dictionary as illustrated by this snippet:

If multiple options are needed, then multiple dictionary entries should be added.

Sometimes it is desirable to pass options as part of the call to the solve function as in this snippet:

The quoted string is passed directly to the solver. If multiple options need to be passed to the solver in this way, they should be separated by a space within the quoted string. Notice that tee is a Pyomo option and is solver-independent, while the string argument to options is passed to the solver without very little processing by Pyomo. If the solver does not have a “threads” option, it will probably complain, but Pyomo will not.

There are no default values for options on a SolverFactory object. If you directly modify its options dictionary, as was done above, those options will persist across every call to optimizer.solve(…) unless you delete them from the options dictionary. You can also pass a dictionary of options into the opt.solve(…) method using the options keyword. Those options will only persist within that solve and temporarily override any matching options in the options dictionary on the solver object.

Often, the executables for solvers are in the path; however, for situations where they are not, the SolverFactory function accepts the keyword executable, which you can use to set an absolute or relative path to a solver executable. E.g.,

Some solvers support a warm start based on current values of variables. To use this feature, set the values of variables in the instance and pass warmstart=True to the solve() method. E.g.,

The Cplex and Gurobi LP file (and Python) interfaces will generate an MST file with the variable data and hand this off to the solver in addition to 

*[Content truncated]*

---

## Interrogating Models — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/howto/interrogating.html#one-variable-from-a-python-script

**Contents:**
- Interrogating Models
- Accessing Variable Values
  - Primal Variable Values
  - One Variable from a Python Script
  - All Variables from a Python Script
- Accessing Parameter Values
- Accessing Duals
  - Access Duals in a Python Script
- Accessing Slacks

Often, the point of optimization is to get optimal values of variables. Some users may want to process the values in a script. We will describe how to access a particular variable from a Python script as well as how to access all variables from a Python script and from a callback. This should enable the reader to understand how to get the access that they desire. The Iterative example given above also illustrates access to variable values.

Assuming the model has been instantiated and solved and the results have been loaded back into the instance object, then we can make use of the fact that the variable is a member of the instance object and its value can be accessed using its value member. For example, suppose the model contains a variable named quant that is a singleton (has no indexes) and suppose further that the name of the instance object is instance. Then the value of this variable can be accessed using pyo.value(instance.quant). Variables with indexes can be referenced by supplying the index.

Consider the following very simple example, which is similar to the iterative example. This is a concrete model. In this example, the value of x[2] is accessed.

If this script is run without modification, Pyomo is likely to issue a warning because there are no constraints. The warning is because some solvers may fail if given a problem instance that does not have any constraints.

As with one variable, we assume that the model has been instantiated and solved. Assuming the instance object has the name instance, the following code snippet displays all variables and their values:

This code could be improved by checking to see if the variable is not indexed (i.e., the only index value is None), then the code could print the value without the word None next to it.

Assuming again that the model has been instantiated and solved and the results have been loaded back into the instance object. Here is a code snippet for fixing all integers at their current value:

Another way to access all of the variables (particularly if there are blocks) is as follows (this particular snippet assumes that instead of import pyomo.environ as pyo from pyo.environ import * was used):

Accessing parameter values is completely analogous to accessing variable values. For example, here is a code snippet to print the name and value of every Parameter in a model:

Access to dual values in scripts is similar to accessing primal variable values, except that dual values are not captured by 

*[Content truncated]*

---
