# Pyomo - Modeling

**Pages:** 2

---

## Overview of Modeling Components and Processes — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/pyomo_overview/overview_components.html

**Contents:**
- Overview of Modeling Components and Processes
- Set
- Param
- Var
- Objective
- Constraint

Pyomo supports an object-oriented design for the definition of optimization models. The basic steps of a simple modeling process are:

Create model and declare components

Instantiate the model

Interrogate solver results

In practice, these steps may be applied repeatedly with different data or with different constraints applied to the model. However, we focus on this simple modeling process to illustrate different strategies for modeling with Pyomo.

A Pyomo model consists of a collection of modeling components that define different aspects of the model. Pyomo includes the modeling components that are commonly supported by modern AMLs: index sets, symbolic parameters, decision variables, objectives, and constraints. These modeling components are defined in Pyomo through the following Python classes:

set data that is used to define a model instance

parameter data that is used to define a model instance

decision variables in a model

expressions that are minimized or maximized in a model

constraint expressions that impose restrictions on variable values in a model

---

## Mathematical Modeling — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/getting_started/pyomo_overview/math_modeling.html

**Contents:**
- Mathematical Modeling
- Variables
- Parameters
- Relations
- Goals

This section provides an introduction to Pyomo: Python Optimization Modeling Objects. A more complete description is contained in the [PyomoBookIII] book. Pyomo supports the formulation and analysis of mathematical models for complex optimization applications. This capability is commonly associated with commercially available algebraic modeling languages (AMLs) such as [FGK02], [AIMMS], and [GAMS]. Pyomo’s modeling objects are embedded within Python, a full-featured, high-level programming language that contains a rich set of supporting libraries.

Modeling is a fundamental process in many aspects of scientific research, engineering and business. Modeling involves the formulation of a simplified representation of a system or real-world object. Thus, modeling tools like Pyomo can be used in a variety of ways:

Explain phenomena that arise in a system,

Make predictions about future states of a system,

Assess key factors that influence phenomena in a system,

Identify extreme states in a system, that might represent worst-case scenarios or minimal cost plans, and

Analyze trade-offs to support human decision makers.

Mathematical models represent system knowledge with a formalized language. The following mathematical concepts are central to modern modeling activities:

Variables represent unknown or changing parts of a model (e.g., whether or not to make a decision, or the characteristic of a system outcome). The values taken by the variables are often referred to as a solution and are usually an output of the optimization process.

Parameters represents the data that must be supplied to perform the optimization. In fact, in some settings the word data is used in place of the word parameters.

These are equations, inequalities or other mathematical relationships that define how different parts of a model are connected to each other.

These are functions that reflect goals and objectives for the system being modeled.

The widespread availability of computing resources has made the numerical analysis of mathematical models a commonplace activity. Without a modeling language, the process of setting up input files, executing a solver and extracting the final results from the solver output is tedious and error-prone. This difficulty is compounded in complex, large-scale real-world applications which are difficult to debug when errors occur. Additionally, there are many different formats used by optimization software packages, and few formats are recognized by ma

*[Content truncated]*

---
